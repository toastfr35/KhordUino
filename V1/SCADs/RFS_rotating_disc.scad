$fn=90;

module m3_captive_nut_hole()
{
    translate([0,0,-50])cylinder(d=3.5,100);
    translate([0,0,0])cylinder(d=7,3,$fn=6);
}


 
 
 module D()
 {
    h=6; 
    difference() {
        union() {
            translate([0,0,-8])cylinder(d=22,8);
            translate([0,0,-8])cylinder(d=26,6);
        }        
        // M3 holes
        translate([-7.5,0,-5])m3_captive_nut_hole();
        translate([7.5,0,-5])m3_captive_nut_hole();                
    }
 }

translate([-104,0,0]) D();



                          

        
        
        
