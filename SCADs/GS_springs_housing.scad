$fn=120;

module kub(x,y,z,r) 
{
    hull() {
        translate([r-(x/2),r-(y/2),0]) cylinder(z,r=r);
        translate([r-(x/2),(y/2)-r,0]) cylinder(z,r=r);
        translate([(x/2)-r,r-(y/2),0]) cylinder(z,r=r);
        translate([(x/2)-r,(y/2)-r,0]) cylinder(z,r=r);
    }
}


module shuttle_B_springs_housing() 
{
    translate([-12,0,0])
    difference() {
    
        // main body
        union() {
            for(y=[-1,1]) {
                hull() {
                    translate([-175,y*23,13])rotate([0,-90,0])cylinder(d=13,23);
                    translate([-175,y*13,13])rotate([0,-90,0])cylinder(d=13,23);
                }
            }
            translate([-203,0,13]) cube([10,60,13],true);           
        }

        // screw holes
        for(y=[-1,1]) {
           hull() {
               translate([-174.99,y*23,13])rotate([0,-90,0])cylinder(d=10,23);
               translate([-174.99,y*13,13])rotate([0,-90,0])cylinder(d=10,23);
           }
           translate([-150,y*23,13])rotate([0,-90,0])cylinder(d=3.5,100);
           translate([-150,y*13,13])rotate([0,-90,0])cylinder(d=3.5,100);           

           translate([-201,y*23,13])rotate([0,-90,0])cylinder(d=6,4);
           translate([-201,y*13,13])rotate([0,-90,0])cylinder(d=6,4);           
        }

        // T-bar
        hull() {
            translate([-208.5,28,13])rotate([90,0,0])cylinder(d=9,56);
            translate([-250,28,13])rotate([90,0,0])cylinder(d=9,56);
        }
    
        // passage for T8 lead screw
        hull() {
            translate([-90,0,13])rotate([0,-90,0])cylinder(d=8,150);
            translate([-90,0,7])rotate([0,-90,0])cylinder(d=10,150);
        }
       
       
    }
}


STL=0;
if (STL==1) {
    rotate([0,90,0]) shuttle_B_springs_housing();
} else {
    shuttle_B_springs_housing();
}