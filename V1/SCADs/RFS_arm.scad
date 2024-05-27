$fn=90;
    
        
module B()
{
    h=13; 
 
    difference() {
        union() {
            hull() {
                translate([-96,0,0])scale([0.5,1,1])cylinder(d=28,h);
                translate([-175,0,0])scale([0.5,1,1])cylinder(d=14,h);
            }            
            // Ring
            hull() {
                translate([-104,0,0])cylinder(d=34,h);            
                translate([-104,18,0])cylinder(d=9,h);
                translate([-104,-18,0])cylinder(d=9,h);
                }
        }
        
        // slots
        hull() {for (dx=[-20,15]) {translate([-142+dx,0,-1])cylinder(d=5.5,100);}}
        
        // Ring hole
        translate([-104,0,-1])cylinder(d=27,h-2+1);
        translate([-104,0,-1])cylinder(d=23,h+2);

        translate([-104,18,-1])cylinder(d=3.5,h+2);
        translate([-104,-18,-1])cylinder(d=3.5,h+2);

        // undercut
        h2=5;
        hull() {
            translate([-104,0,0])cylinder(d=34.5,h2);
            translate([-104,18,0])cylinder(d=9.5,h2);
            translate([-104,-18,0])cylinder(d=9.5,h2);
            }

        translate([-104,18,h-3])cylinder(d=6,3.1);
        translate([-104,-18,h-3])cylinder(d=6,3.1);       
    }
 }


STL=0;
if (STL==1) {
    rotate([180,0,0]) translate([0,0,-13])B();
} else {
    translate([0,0,-13])B();
}                      

        
        
        
