$fn=90;

module m3_captive_nut_hole()
{
    translate([0,0,-50])cylinder(d=3.5,100);
    translate([0,0,0])cylinder(d=7,3,$fn=6);
}

module C()
{
    h=5;
 
    difference() {
        union() {
            // Ring
            hull() {
                translate([-104,0,0])cylinder(d=34,h);            
                translate([-104,18,0])cylinder(d=9,h);
                translate([-104,-18,0])cylinder(d=9,h);
                }
        }
        
        translate([-104,18,-1]) m3_captive_nut_hole();
        translate([-104,-18,-1]) m3_captive_nut_hole();
        
    }
 }


STL=0;
if (STL==1) {
    rotate([180,0,0])translate([0,0,-13])C();  
} else {
    translate([0,0,-13])C();  
}                          
        
        
        
