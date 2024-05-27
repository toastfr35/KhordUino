$fn=30;

module cub(x,y,z,r) 
{
    translate([-x/2,-y/2,-z/2])
    hull() {
        translate([r,r,0]) cylinder(z,r=r);
        translate([x-r,r,0]) cylinder(z,r=r);
        translate([r,y-r,0]) cylinder(z,r=r);
        translate([x-r,y-r,0]) cylinder(z,r=r);
    }
}


module B() 
{
    render()
    difference() {
        union() {
            translate([-102,-102,106])import ("../base/bracket.stl");
            translate([0,0,2.5])cub(50,60,5,4);
        }
        for(x=[-17,17]) for(y=[-22,22])
        translate([x,y,0]) {
            translate([0,0,-1])cylinder(d=4,10);
            translate([0,0,3])cylinder(d1=4,d2=10,2.1);
        }
        translate([0,0,5.8])cube([100,14,4],true);
        translate([22,0,5.8])cube([20,25,4],true);
    }
}


module L(a,l)
{
    x=81;
    
    module leg() 
    {
        translate([-61.915,77.3095,-132.5])rotate([90,0,0])import("../base/leg.stl");
    }

    module center_part() 
    {
        hull() {
            intersection() {
                leg();
                translate([12,-25,-25])cube([x,50,50]);
            }
        }
    }
       
    
    translate([2,0,14])
    rotate([0,-a,0])
    {
        difference() {
            union() {
                difference() {
                    leg();
                    translate([12,-25,-25])cube([500,50,50]);
                }
                center_part();
                translate([l,0,0]) {
                    center_part();
                    #intersection() {
                        leg();
                        translate([x+12,-25,-25])cube([150,50,50]);
                    }
                }
            }
        }
    }
}



import("../base/leg.stl");
