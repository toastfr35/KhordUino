$fn=90;

//---------------------------------------------------
// racket_holder_1
//---------------------------------------------------



        
module woodscrew_hole() 
{
    d=3.75;
    d2 = 6;
    translate([0,0,-42]) {
        cylinder(d=d,50);
        translate([0,0,50])cylinder(d=d2,3);
    }
}       
      
      
module racket_holder_1_B() 
{
    l=30;
    l2=40;
    w0=40;
    w1=20;
    w2=15;
    h=12;
    w3=5;
    m=0.75;


    translate([0,0,2])
    difference() {
        union() {
            extra=10;
            hull() {
                translate([-extra,-w1/2-5,-3-12])cube([l2,w1+10,2+12]);
                translate([-extra+2,-w0/2-2,-3])cube([l2,w0+4,h+2]);
                translate([-7,22,-15])cylinder(d=6,h+14);
                translate([-7,-22,-15])cylinder(d=6,h+14);
                translate([l2,22,-15])cylinder(d=6,h+14);
                translate([l2,-22,-15])cylinder(d=6,h+14);
            }
        }   
        translate([-28,-(w1+m)/2,h/2-h/2-(m/2)-8])cube([20+l2,w1+m,h/2+m+8]);
        translate([-28,-(w2+m)/2,-m/2])cube([l2+20,w2+m,h+m]);
        translate([l2-40,0,h/2-2])rotate([0,90,0])cylinder(d=5.5,50,$fn=60);
        
        
        translate([35,17,0])woodscrew_hole();
        translate([7,14,0])woodscrew_hole();
        translate([35,-17,0])woodscrew_hole();
        translate([7,-14,0])woodscrew_hole();        
        
    }
        
}


racket_holder_1_B();



//#translate([0,0,-9]) cube([160,160,18],true);






