/* Wiring 
    
    Using a CNC shield as breakout board.

    All black wires -> GND


    load cell: (green)  -> (D13)
               (yellow) -> (D12)
               (red)    -> 5V
               
    1 Stepper : pulse+ (green?)  -> (A2) "resume"
                dir+   (violet?) -> (A3) "cool EN"
                enable (orange?) -> (D8) ""
    
    3 buttons:
        (blue)  -> "X-" (D9) & GND
        (white) -> "Y-" (D10) & GND
        (red)   -> "Z-" (D11) & GND

    limit switches
        limit pull (green)  -> "Hold"  (A1)
        limit push (blue)  ->  "Abort" (A0) 
    
    LCD
       SCL (yellow) -> (A5)
       SDA (blue)   -> (A4)
       VCC (red)    -> 5V 

*/
 

/*************************************

START -> 'Ready?' -[any button]-> INIT_POS -> [any button] -> SET_LBS -> [+/-/ok] -> READY  

READY -> [+] -> PULL -> [-] -> RELEASE -> READY
      -> [M] -> SET_LBS -> [+/-/ok] -> READY 

***************************************/


/*********************************/

#define version String("1.1")

#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include "HX711.h"
#include <EEPROM.h>


// LOAD CELL
#define LOADCELL_DOUT_PIN 13  // green D13
#define LOADCELL_SCK_PIN 12   // yellow D12
HX711 loadcell;
float f_a;
float f_b;

// Stepper
#define EN 8     // stepper motor enable, low level effective
#define X_DIR A3  //X axis, stepper motor direction control
#define X_STP A2  //X axis, stepper motor control
//#define Y_DIR 3  //Y axis, stepper motor direction control
//#define Y_STP 6  //Y axis, stepper motor control

// BUTTONS
#define NB_BUTTONS 5
#define BUTTON_BLUE 0
#define BUTTON_WHITE 1
#define BUTTON_RED 2
#define BUTTON_LIMIT_PULL 3
#define BUTTON_LIMIT_PUSH 4
#define BUTTON_PIN_BLUE 9         // X-stop (green wire)
#define BUTTON_PIN_WHITE 10       // Y-stop (white wire)
#define BUTTON_PIN_RED 11         // Z-stop (brown wire)
#define BUTTON_PIN_LIMIT_PULL A1  // Hold  (blue wire)
#define BUTTON_PIN_LIMIT_PUSH A0  // Abort   (green wire)
int button_pin[NB_BUTTONS] = { BUTTON_PIN_BLUE, BUTTON_PIN_WHITE, BUTTON_PIN_RED, BUTTON_PIN_LIMIT_PULL, BUTTON_PIN_LIMIT_PUSH };
bool button_pressed[NB_BUTTONS] = { false };

// LCD
LiquidCrystal_I2C lcd = LiquidCrystal_I2C(0x27, 16, 2);


/*********************************/
unsigned long tension_int = 0;          // current load cell value
unsigned long tension_lbs = 0;          // current tension in lbs
unsigned int target_tension_lbs = 0;    // tension to achieve
bool tension_display_enabled = false;   // should the current tension be automatically displayed when updated?

bool direction_pull = true;             // which way is it moving?
const unsigned int pull_speed = 100;    // nominal speeds
const unsigned int push_speed = 75;


/*********************************/
//#define debug(X)
void debug(String msg) {Serial.println(msg);}


void stepper_disengage();
void stepper_engage();

void(* resetFunc) (void) = 0;//declare reset function at address 0


/*********************************
 * Initialisation
 *********************************/
void setup_lcd();
void main_menu();

void setup() 
{
  int i;

  Serial.begin(9600);
  Serial.println("Hi");
  Wire.begin();

  // initialize lcd
  setup_lcd();
  lcd.backlight();
  lcd.clear();
  lcd.setCursor(1, 0);
  lcd.print("Khorduino " + version);

  // initialize loadcell
  loadcell.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN, 64);  // 128
  loadcell.wait_ready();
  loadcell.set_scale();
  loadcell.tare();  //Reset the loadcell to 0

  // initialize stepper
  pinMode(X_DIR, OUTPUT);
  pinMode(X_STP, OUTPUT);
  pinMode(EN, OUTPUT);
  digitalWrite(X_DIR, true);  // set direction to 'pull'
  stepper_disengage();

  // initialize buttons
  for (i = 0; i < NB_BUTTONS; i++) {
    pinMode(button_pin[i], INPUT_PULLUP);
  }

  // read last configured target tension from eprom
  EEPROM.get(0, target_tension_lbs);
  if (target_tension_lbs > 300) {target_tension_lbs = 300; EEPROM.put(0, target_tension_lbs);}
  if (target_tension_lbs < 180) {target_tension_lbs = 180; EEPROM.put(0, target_tension_lbs);}
  EEPROM.get(4, f_a);
  EEPROM.get(8, f_b);

  debug ("target_tension_lbs = " + String (target_tension_lbs));
  debug ("f_a = " + String (f_a));
  debug ("f_b = " + String (f_b));

  delay(1500);

  main_menu(); 

}

/********************************************************/
/*                   MAIN LOOP                          */
/********************************************************/


/* Actions */
int main_menu_input();
int setup_menu_input();
void reset_puller();         // Move the puller to the 'ready' position
void user_set_target_lbs();  // Let the user set the target tension
int wait_for_input();        // wait for the user: 0-> pull, 1 -> set the target.
int do_pull();               // pull the string. Return:  0 -> hold, 1 -> release
int do_hold();               // hold the string. Return: 0 -> pull, 1-> release, 2 -> SET_LBS
void do_release();           // release the tension

void set_coefficient_A();
void load_cell_test();



void loop() 
{
  enum states { RESET,
                SETUP,
                SET_LBS,
                GET_INPUT,
                PULL,
                HOLD,
                RELEASE };
  static states current_state = RESET;
  static states state_after_set_lbs;
  int choice = -1;

  debug("Current State is " + String(current_state));

  tension_display_enabled = false;

  switch (current_state) {
    // perform action for the current state and move to next state

    case RESET:
      lcd.clear();
      reset_puller();
      current_state = SET_LBS;
      state_after_set_lbs = GET_INPUT;
      break;

    case SET_LBS:
      user_set_target_lbs();
      current_state = state_after_set_lbs;
      break;

    case GET_INPUT:
      choice = wait_for_input();
      if (choice == 0) {
        current_state = PULL;
      } else {
        current_state = SET_LBS;
        state_after_set_lbs = GET_INPUT;
      }
      break;

    case PULL:
      choice = do_pull();
      if (choice == 0) {
        current_state = HOLD;
      } else {
        current_state = RELEASE;
      }
      break;

    case HOLD:
      choice = do_hold();
      if (choice == 0) {
        current_state = PULL;
      } else if (choice == 1) {
        current_state = RELEASE;
      } else {
        current_state = SET_LBS;
        state_after_set_lbs = HOLD;
      }
      break;

    case RELEASE:
      do_release();
      current_state = GET_INPUT;
      break;

    default:
      debug("ERROR");
      break;
  }
}


/********************************************************/
/*                  BUTTONS                             */
/********************************************************/

/*********************************
 * update 'buttons' array by reading 
 * change of state of 5 physical buttons
 *********************************/  
void update_buttons() 
{
  static unsigned long last_change[NB_BUTTONS] = { 0 };
  static int buttons[NB_BUTTONS] = { 1 };
  int i;

  for (i = NB_BUTTONS - 1; i >= 0; i--) {
    int v = digitalRead(button_pin[i]);
    if (buttons[i] != v) {
      unsigned long now = millis();
      unsigned long dt = now - last_change[i];
      if (dt > 50) {
        buttons[i] = v;
        button_pressed[i] = (v == 0);
        last_change[i] = now;
        //debug ("B" + String(i) + " v = " + String(v));
        //debug ("B pressed " + String(i) + " changed to " + String(button_pressed[i]));
      }
    }
  }
}

/*********************************
 * is the PULL limit switch depressed?
 *********************************/ 
bool limit_switch_pull() 
{
  return (digitalRead(BUTTON_PIN_LIMIT_PULL) == 0) ? true : false;
}

/*********************************
 * is the PUSH limit switch depressed?
 *********************************/ 
bool limit_switch_push() 
{
  return (digitalRead(BUTTON_PIN_LIMIT_PUSH) == 0) ? true : false;
}


/*********************************
 * Wait for a button input (with optional timeout in ms)
 ********************************/ 
int wait_button_press(unsigned int timeout = 0) 
{
  unsigned long start = millis();
  unsigned int i, result = 0;
  bool prev[NB_BUTTONS];
  update_buttons();
  for (i = 0; i < NB_BUTTONS; i++) prev[i] = button_pressed[i];

  do {
    update_tension();
    update_buttons();
    for (i = 0; i < NB_BUTTONS; i++) {
      if (!prev[i] && button_pressed[i]) result |= (1 << i);
      if (!button_pressed[i]) prev[i] = false;
    }

    if (timeout != 0) {
      if ((millis() - start) >= timeout) {
        return 0;
      }
    }

  } while (!result);
  return result;
}


/********************************************************/
/*                  TENSION                             */
/********************************************************/

/*********************************
 * Display the current tension immediately
 *********************************/ 
void show_tension_now() 
{
  lcd.setCursor(0, 0);
  lcd.print("    " + String(tension_lbs / 10) + "." + String(tension_lbs % 10) + " lbs  ");
  //debug("Tension = " + String(tension_int) + " " + String(tension_lbs / 10) + "." + String(tension_lbs % 10) + " lbs");
}

/*********************************
 * Display the current tension at most every 0.5 s
 *********************************/ 
void show_tension()
{
  static unsigned long last = 0;
  unsigned long now = millis();
  unsigned long dt = now - last;
  if (dt > 500) {
    show_tension_now();
    last = now;
  }
}

/*********************************
 * Convert load cell value to LBS
 *********************************/ 
// 10lbs = f_a * load_cell + f_y
unsigned long int_to_lbs(unsigned int v)
{
  // lbs = (v - b) / a
  int r;
  float f_v = (float)v;
  r = (int)(10.0 * ((f_a * f_v) + f_b));
  if (r < 0) r = 0;
  return r;
}

/*********************************
 * Read load cell and update current tension
 *********************************/ 
void update_tension() 
{
  long v;
  if (loadcell.is_ready()) {
    v = 64 + (loadcell.read() / 1000);
    if (v < 0) v = 0;
    tension_int = v;
    tension_lbs = int_to_lbs(v);
    if (tension_display_enabled) show_tension();
  }
}



/********************************************************/
/*                  MOTORS CONTROL                      */
/********************************************************/

/*********************************
 * Disengage stepper motor
 *********************************/ 
void stepper_disengage() 
{
  digitalWrite(EN, HIGH);
}

/*********************************
 * Engage stepper motor
 *********************************/ 
void stepper_engage() 
{
  digitalWrite(EN, LOW);
}

/*********************************
 * Set stepper to move in PULL direction
 *********************************/ 
void set_direction_pull() {
  if (!direction_pull) {
    direction_pull = true;
    digitalWrite(X_DIR, false);
  }
}

/*********************************
 * Set stepper to move in PUSH direction
 *********************************/ 
void set_direction_push() {
  if (direction_pull) {
    direction_pull = false;
    digitalWrite(X_DIR, true);
  }
}

/*********************************
 * Move the stepper motor one step
 * return 0 if successfull
 *        1 if stop_on_tension is true and the requested tension is reached
 *        2 if the pull limit is reached
 *        3 if the push limit is reached
 *********************************/ 
int motors_one_step(int step_sleep, bool stop_on_tension) 
{
  static unsigned int step_count = 0;
  static unsigned int tension_check_rate = 256;
  static bool tick = false;
  unsigned long start = micros();
  unsigned long now, delta;
  unsigned int sleep = step_sleep;

  tick = !tick;

  if (direction_pull) {

    if (stop_on_tension) 
    {
      // regular (adaptative) check of the tension to see if we should stop
      step_count++;
      if (((step_count % tension_check_rate )== 0)) update_tension();
      if (tension_lbs >= target_tension_lbs) {
        debug("Tension reached");
        return 1;
      }

      // adapt tension check frequency to proximity of target tension
      tension_check_rate = 16;
      if ((target_tension_lbs - tension_lbs) > 50)  {tension_check_rate = 32;}
      if ((target_tension_lbs - tension_lbs) > 100) {tension_check_rate = 1024;}
      if ((target_tension_lbs - tension_lbs) > 200) {tension_check_rate = 8192;}
      
      // Slow down when getting close
      if ((target_tension_lbs - tension_lbs) < 50)  {sleep *= 4;}
      if ((target_tension_lbs - tension_lbs) < 100) {sleep *= 2;}    
    }

    if (limit_switch_pull()) {
      return 2;
    }

  } else {
    if (limit_switch_push()) {
      return 3;
    }
  }

  // adaptive delay 
  now = micros();
  if (now < start) {
    // wrap around
    delayMicroseconds(sleep);
  } else {
    delta = now - start;
    if (delta < sleep) delayMicroseconds(sleep - delta);
  }

  // step
  if (tick) {
    digitalWrite(X_STP, HIGH);
  } else {
    digitalWrite(X_STP, LOW);
  }

  return 0;
}

/*********************************
 * Move the stepper motor n steps in the current direction
 * returns 0 if successfull
 *        1 if stop_on_tension is true and the requested tension is reached
 *        2 if the pull limit is reached
 *        3 if the push limit is reached
 *********************************/
int motors_n_steps(int nb_steps, int step_sleep, bool stop_on_tension) 
{
  unsigned int i, error;
  unsigned int max = 2 * nb_steps;
  unsigned int increment = 1;

  if (nb_steps == 0) {
    // infinite loop
    max = 1;
    increment = 0;
  }

  for (i = 0; i < max; i += increment) {
    error = motors_one_step(step_sleep, stop_on_tension);
    if (error != 0) {
      debug("Stop motors " + String(error));
      update_buttons();
      return error;
    }
  }
  update_buttons();
  return 0;
}



/********************************************************/
/*                    ACTIONS                           */
/********************************************************/

/*********************************
 * Move the puller to the 'ready' position
 *********************************/
void reset_puller() 
{
  int error;

  debug("Reset puller");
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Wait...");
  stepper_engage();
  set_direction_push();
  motors_n_steps(0, push_speed, false);
  set_direction_pull();
  motors_n_steps(1600, push_speed, false);
  stepper_disengage();
}

/*********************************
 * Let the user set the target tension
 *********************************/
void user_set_target_lbs() 
{
  unsigned int new_target_tension_lbs = target_tension_lbs;
  debug("Set Lbs");
  lcd.clear();
  lcd.setCursor(2, 1);
  lcd.print("-    OK    +");
  while (1) {
    String lbs_str1 = String(new_target_tension_lbs / 10);
    String lbs_str2 = String(new_target_tension_lbs % 10);
    lcd.setCursor(4, 0);
    lcd.print(lbs_str1 + "." + lbs_str2 + " lbs");
    unsigned int button = wait_button_press();
    if (button & (1 << BUTTON_BLUE)) new_target_tension_lbs -= 5;
    if (button & (1 << BUTTON_RED)) new_target_tension_lbs += 5;
    if (new_target_tension_lbs >= 300) new_target_tension_lbs = 300;
    if (new_target_tension_lbs <= 180) new_target_tension_lbs = 180;
    if (button & (1 << BUTTON_WHITE)) break;
  }

  if (new_target_tension_lbs != target_tension_lbs) {
    target_tension_lbs = new_target_tension_lbs;
    unsigned int v;
    EEPROM.get(0, v);
    if (v != target_tension_lbs) EEPROM.put(0, target_tension_lbs);
  }
}

/*********************************
 * Wait for the user: 0-> pull, 1 -> set the target.
 *********************************/
int wait_for_input() 
{
  debug("Wait input");
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Ready...");
  lcd.setCursor(0, 1);
  lcd.print("      SET   PULL");
  while (1) {
    unsigned int button = wait_button_press();
    if (button & (1 << BUTTON_WHITE)) return 1;
    if (button & (1 << BUTTON_RED)) return 0;
  }
}

/*********************************
 * Pull the string. Return:  0 -> hold, 1 -> release
 *********************************/
int do_pull() 
{
  debug("Do pull");
  lcd.clear();
  lcd.setCursor(0, 1);
  lcd.print("Pulling...");
  tension_display_enabled = true;
  stepper_engage();
  set_direction_pull();
  motors_n_steps(0, pull_speed, true);
}

/*********************************
 * Hold the string. Return: 0 -> pull, 1-> release, 2 -> SET_LBS
 *********************************/
int do_hold() 
{
  debug("Do hold");
  lcd.clear();
  lcd.setCursor(0, 1);
  lcd.print("FREE  SET   PULL");
  tension_display_enabled = true;
  while (1) {
    unsigned int button = wait_button_press(100);
    if (button & (1 << BUTTON_BLUE)) return 1;
    if (button & (1 << BUTTON_WHITE)) return 2;
    if (button & (1 << BUTTON_RED)) return 0;

    if (!limit_switch_pull()) {
      if (tension_lbs < target_tension_lbs) motors_n_steps(32, pull_speed*2, true);
    }
  }
}

/*********************************
 * Release the tension
 *********************************/
void do_release() 
{
  debug("Do release");
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Releasing...");
  stepper_engage();
  set_direction_push();
  motors_n_steps(0, push_speed, false);
  stepper_disengage();
  delay(3000);
  stepper_engage();
  set_direction_pull();
  motors_n_steps(1600, push_speed, false);
  stepper_disengage();
}



/********************************************************/
/*                                                      */
/********************************************************/

void show_version()
{
  lcd.clear();
  lcd.setCursor(0,0); 
  lcd.print (" Version " + version);
  delay (3000);
}


void show_eeprom()
{
  unsigned int v1;
  float v2;
  EEPROM.get(0, v1);
  lcd.clear(); lcd.setCursor(0,0); lcd.print ("tgt lbs = " + String (v1));
  delay (1000);

  EEPROM.get(4, v2);
  lcd.clear(); lcd.setCursor(0,0); lcd.print ("f_a = " + String (v2));
  delay (1000);

  EEPROM.get(8, v2);
  lcd.clear(); lcd.setCursor(0,0); lcd.print ("f_b = " + String (v2));
  delay (1000);
}


void test()
{
  int button;
  int left = 5;
  lcd.clear();
  lcd.setCursor(left,1); lcd.print("[     ]");  
  tension_display_enabled = 1;
  int done = 0;

  while(done != 0x1F) {
      button = wait_button_press(250);
      update_tension();
      if (button & (1 << BUTTON_BLUE))       {lcd.setCursor(left+1,1); lcd.print("X"); done |= 0x1;}
      if (button & (1 << BUTTON_WHITE))      {lcd.setCursor(left+2,1); lcd.print("X"); done |= 0x2;}
      if (button & (1 << BUTTON_RED))        {lcd.setCursor(left+3,1); lcd.print("X"); done |= 0x4;} 
      if (button & (1 << BUTTON_LIMIT_PULL)) {lcd.setCursor(left+4,1); lcd.print("X"); done |= 0x8;} 
      if (button & (1 << BUTTON_LIMIT_PUSH)) {lcd.setCursor(left+5,1); lcd.print("X"); done |= 0x10;}       
  }
  tension_display_enabled = 0;
  lcd.setCursor(left,1); lcd.print("[@@@@@] OK");  
  delay (3000);
}


void calibrate()
{
  int button;
  tension_display_enabled = 0;
  unsigned int target_tension_int = 150;
  unsigned int values[16];
  unsigned int idx = 0;
  bool last_cmd_is_push = false;
  bool last_cmd_is_pull = false;

  stepper_engage();
  set_direction_push();
  motors_n_steps (0, push_speed, false);
  delay(1000);
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Attach scale");
  lcd.setCursor(0, 1);
  lcd.print("Press when ready");
  button = wait_button_press();
  lcd.clear();
  set_direction_pull();
  motors_n_steps(128, pull_speed*4, false);
  unsigned int v1 = 0;
  unsigned int v2 = 0;

  for (int tgt=10; tgt<=15; tgt+=5) 
  {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print(String("Target = ") + String(tgt) + String(" Kg"));

    int incr = 40;
    int decr = 20;
    int steps = 128;
    int speed_mult = 4;
    int fine_tune = 0;


    while(1) {
      button = wait_button_press(50);
      if (button & (1 << BUTTON_BLUE))  {target_tension_int-=decr; last_cmd_is_push=true; last_cmd_is_pull=false;}
      if (button & (1 << BUTTON_RED))   {target_tension_int+=incr; last_cmd_is_push=false; last_cmd_is_pull=true;}
      if (button & (1 << BUTTON_WHITE)) {
        last_cmd_is_push=false; 
        last_cmd_is_pull=false;
        if (fine_tune) {
          unsigned int avg = 0;
          for (int i = 0; i < 16; i++) avg += values[i];
          debug(String (">> ") + String(tgt) + String ("Kg => ") + String(avg/16));
          if (tgt==10) v1 = avg/16  ;
          if (tgt==15) v2 = avg/16  ;
          break;
        }
        fine_tune = 1;
        steps = 4;
        speed_mult = 1;
        lcd.clear();
        lcd.setCursor(0, 0);
        lcd.print(String("Fine tune ") + String(tgt) + String(" Kg"));
        delay(1000);
      }

      update_tension();

      if ((tension_int != -1) && (!limit_switch_pull())) 
      {
        if (fine_tune) {
          values[idx] = tension_int;
          idx = (idx + 1) % 16;
        }

        if ((tension_int < target_tension_int) && (last_cmd_is_pull || fine_tune)) {
          set_direction_pull();
          motors_n_steps(steps, pull_speed*speed_mult, false);
        }
        if ((tension_int > target_tension_int) && (last_cmd_is_push || fine_tune)) {
          set_direction_push();
          motors_n_steps(steps/2, push_speed*speed_mult, false);
        }
      }

      lcd.setCursor(0, 1);
      int delta = ((int)target_tension_int)-((int)tension_int);
      lcd.print(" -    " + String(delta) + "    +");
      if (limit_switch_pull()) {debug ("abort"); break;}
    }    
  }


  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Calibrated... ");
  set_direction_push();
  motors_n_steps (0, push_speed, false);
  stepper_disengage();

  // Show and save calibration data
  float f_a = (33.07-22.05) / (float)(v2-v1);
  float f_b = -((float)(3*v1 - 2*v2)) * f_a;

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(String("v1 = ") + String(v1));
  lcd.setCursor(0, 1);
  lcd.print(String("v2 = ") + String(v2));
  delay (5000);

  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(String("f_a = ") + String(f_a));
  lcd.setCursor(0, 1);
  lcd.print(String("f_b = ") + String(f_b));
  EEPROM.put(4, f_a);
  EEPROM.put(8, f_b);
  delay (5000);
}



void check()
{
  tension_display_enabled = 1;
  stepper_engage();
  set_direction_push();
  motors_n_steps (0, push_speed, false);

  lcd.clear();

  while(1) {
    unsigned int button = wait_button_press(100);
    if ((button & (1 << BUTTON_BLUE)) && (!limit_switch_push())) {set_direction_push(); motors_n_steps(128, push_speed, false);}
    if ((button & (1 << BUTTON_RED))  && (!limit_switch_pull())) {set_direction_pull(); motors_n_steps(128, pull_speed, false);}
    if (button & (1 << BUTTON_WHITE)) {break;}
  }
  stepper_disengage();
  tension_display_enabled = 0;
  lcd.clear();
}




/********************************************************/
/*                                                      */
/********************************************************/
void set_coefficient(char v)
{
  int state = 0;
  int save = 0;
  int decimals;
  int button;
  float value;
  float delta_val = 0.0001;
  char buff1[10];
  char buff2[10];

  if (v=='A') value = f_a;
  if (v=='B') value = f_b;

  if (v=='B') state = 1;

  while(1) {

    switch (state) {
      case 0 : delta_val = 0.0001; decimals = 4; break;
      case 1 : delta_val = 0.001; decimals = 3; break;
      case 2 : delta_val = 0.01; decimals = 2; break;
      case 3 : delta_val = 0.1; decimals = 1; break;
      case 4 : delta_val = 1.0; decimals = 0; break;
      case 5 : delta_val = 10.0; decimals = 0; break;
      case 6 : delta_val = 0.0; decimals = 4; break;
      default :             
        state = 0; 
        delta_val = 0.0001; 
        decimals = 4;
        if (v=='B') {
          state = 1;
          delta_val = 0.001; 
          decimals = 3;
        }
    }

    dtostrf (value, 2, 4, buff1);
    dtostrf (delta_val, 2, decimals, buff2);      

    lcd.clear();
    if (state == 6) {
      //debug ("Z");
      lcd.setCursor(0, 0); lcd.print("Set " + String(v) + " = " + String(buff1));
      lcd.setCursor(0, 1); lcd.print("Ok  Cancel  Next");
    } else {    
      lcd.setCursor(0, 0); lcd.print(String (buff1) + " (" + buff2 + ")");
      lcd.setCursor(0, 1); lcd.print("-      +    Next");
    }

    button = wait_button_press();

    if (state == 6) {
      if (button & (1 << BUTTON_BLUE))  {save = 1; break;}
      if (button & (1 << BUTTON_WHITE)) {break;}
    } else {
      if (button & (1 << BUTTON_BLUE))  {value-=delta_val;}
      if (button & (1 << BUTTON_WHITE)) {value+=delta_val;}
    }
    if (button & (1 << BUTTON_RED))   {state++;}    
  }

  if (save) {    
    lcd.clear();
    lcd.setCursor(0, 0); 
    lcd.print("Saving " + String(v) + " ...");
    lcd.setCursor(0, 1); 
    lcd.print(String(v) + " = " + String(buff1));

    if (v == 'A') {
      f_a = value;
      EEPROM.put(4, f_a);
    }
    if (v == 'B') {
      f_b = value;
      EEPROM.put(8, f_b);
    }

    delay (2000);
    resetFunc(); //call reset 
  }
}


void set_coefficient_A() {set_coefficient('A');}
void set_coefficient_B() {set_coefficient('B');}

/********************************************************/
/*                                                      */
/********************************************************/

byte up[8] = {
  B00000,
  B00000,
  B00100,
  B01110,
  B11111,
  B11111,
  B00000,
};

byte down[8] = {
  B00000,
  B00000,
  B11111,
  B11111,
  B01110,
  B00100,
  B00000,
};

byte ret1[8] = {
  B00000,
  B00001,
  B00011,
  B00111,
  B00011,
  B00001,
  B00000,
};

byte ret2[8] = {
  B00001,
  B00001,
  B00001,
  B11111,
  B00000,
  B00000,
  B00000,
};

typedef void (*t_fptr)(void);

typedef struct {
  char str[17];
  void * submenu;
  int value;
  t_fptr action;
} t_menu_item;


void setup_lcd() {
  lcd.init();
  lcd.createChar(0, up);
  lcd.createChar(1, down);
  lcd.createChar(2, ret1);
  lcd.createChar(3, ret2);
}


/********************************************************/
/* Menus                                                */
/********************************************************/


t_menu_item menu_info_data[] = 
{
  {"Version",   NULL, 0, &show_version},
  {"EEPROM",    NULL, 0, &show_eeprom},
  {"Back",      NULL, -1, NULL},
  {"",          NULL,  0, NULL},
};

t_menu_item menu_setup_data[] = 
{
  {"Test",        NULL, 0,  &test},
  {"Check",       NULL, 0,  &check},
  {"Calibrate",   NULL, 0,  &calibrate},
  {"Set param A", NULL, 0,  &set_coefficient_A},
  {"Set param B", NULL, 0,  &set_coefficient_B},
  {"Back",        NULL, -1, NULL},
  {"",            NULL,  0, NULL},
};


t_menu_item main_menu_data[] = 
{
  {"Start",      NULL,            1, NULL},
  {"Setup",      menu_setup_data, 0, NULL},
  {"Info",       menu_info_data,  0, NULL},
  {"",           NULL,  0, NULL},
};


char * center_padding(char * str)
{
  int length = strlen(str);
  int padd = (16-length)/2;
  int i;
  static char result[17];
  for (i=0;i<16;i++) result[i] = ' '; 
  result[16] = 0;
  for (i=0;i<length;i++) result[padd+i] = str[i];
  return (result);
}


int generic_menu (void * menu_data)
{
  t_menu_item * menu = (t_menu_item *) menu_data;
  int selection = 0;
  int last_item, button, i;

  for (i = 0; menu[i].str[0] != 0; i++) last_item = i;

  while(1) 
  {
    lcd.clear();
    lcd.setCursor(1,1);  lcd.write(byte(0));
    lcd.setCursor(7,1);  lcd.write(byte(2));
    lcd.setCursor(8,1);  lcd.write(byte(3));
    lcd.setCursor(14,1);  lcd.write(byte(1));
    lcd.setCursor(0,0); lcd.print (center_padding(menu[selection].str));
    button = wait_button_press();
    if (button & (1 << BUTTON_BLUE)) {selection--;}
    if (button & (1 << BUTTON_RED))  {selection++;}
    if (selection<0) selection = last_item;
    if (selection>last_item) selection = 0;
    if (button & (1 << BUTTON_WHITE)) {      
      if (menu[selection].submenu != NULL) {
        debug("submenu");
        generic_menu(menu[selection].submenu);
        debug("back from submenu");
      }
      else if (menu[selection].action != NULL) {
        debug("action");
        menu[selection].action();
        debug("back from action");
      } 
      else {
        debug("Value: " + String(selection) + " " + String (menu[selection].value) ); 
        return menu[selection].value;
      }
    }
    lcd.setCursor(0,0); lcd.print (center_padding(menu[selection].str));
  }
}




void main_menu()
{
  generic_menu(main_menu_data);
}










/********************************************************/
/*                    FOR TESTING ONLY                  */
/********************************************************/

/*
void pingpong()
{
  int x,i;
  int delay_micro_seconds = 200;

  target_tension_lbs = 230;
  tension_display_enabled = 1;

  stepper_engage();
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Push...");    
  set_direction_push();
  motors_n_steps (0, push_speed, false);

  while(1) {
    target_tension_lbs += 10;
    if (target_tension_lbs > 300) return;
    stepper_engage();

    lcd.clear();
    lcd.setCursor(0, 1);
    lcd.print("Push...");    
    set_direction_push();
    motors_n_steps (10000, push_speed, false);

    lcd.clear();
    lcd.setCursor(0, 1);
    lcd.print("Pull " + String(target_tension_lbs / 10));    
    set_direction_pull();
    motors_n_steps (0, pull_speed, true);   

    lcd.clear();
    lcd.setCursor(0, 1);
    lcd.print("Hold " + String(target_tension_lbs / 10));    

    for (i=0;i<5*10;i++) {
      update_tension();
      if (!limit_switch_pull()) {
        if (tension_lbs < target_tension_lbs) motors_n_steps(16, pull_speed*4, true);
      }
      delay(200);
    }

    stepper_disengage();
    delay(1000);
    update_tension();

  }
}
*/




/*
void load_cell_test()
{
  update_tension();
  Serial.println(String(tension_int));
  delay(1000);
}
*/


