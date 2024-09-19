$fn=90;


module woodscrew_hole() {
    d=3.75;
    d2=6;
    translate([0,0,-50]) {
        cylinder(d=d,50);
        translate([0,0,50])cylinder(d=d2,50);
    }
}

module m3_captive_nut_hole()
{
    translate([0,0,-50])cylinder(d=3.5,100);
    translate([0,0,0])cylinder(d=7,3,$fn=6);
}

module center_hole()
{
    rotate([0,0,25])translate([0,0,-10]) scale([200,245,1])cylinder(100,d=1,$fn=90);
}

module M5_T_nut()
{
    th1=6;
    dc=0.5;

    cylinder(d=5.5,100);
    
    hull(){
        cylinder(d=8,9);
        translate([-4+dc/2,4-dc/2,0])cylinder(d=dc,9);
        translate([4-dc/2,-4+dc/2,0])cylinder(d=dc,9);
    }
    
    translate([0,0,th1/2])cube([8,20,th1],center=true);
}



module A() {
    h=10;

    intersection() {
    
        difference() {
            translate([0,0,-2])cylinder(h+2,d=330+4,$fn=90);
            //translate([0,0,-10])ring();
            center_hole();
            
            // wood screw
            translate([-120,26,h-3]) woodscrew_hole();
            translate([-155,0,h-3]) woodscrew_hole();
            translate([-110,-26,h-3]) woodscrew_hole();                        
            
            // M5
            //#translate([-137+10,0,-2]) M5_T_nut();
            translate([-137,0,-2]) M5_T_nut();
            //#translate([-137-10,0,-2]) M5_T_nut();
            
        }
    
        hull() {
            translate([-168,0,0])cube([1,50,100],true);
            translate([-109,30,-50])cylinder(100,d=10);
            translate([-101,-30,-50])cylinder(100,d=10);
        }
            
    }
}
        
        
STL=0;
if (STL==1) {
    rotate([0,0,0]) translate([0,0,-10-13])A();        
} else {                        
    translate([0,0,-10-13])A();        
}    
        
        
