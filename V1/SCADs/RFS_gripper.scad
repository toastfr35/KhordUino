$fn=90;

module E()
{
    h=6;

    difference() {
    
        union() {
    
          // top hook
          hull() {
            translate([-7.5,0,15])cylinder(d=6.5,8);
            translate([2,0,17])cylinder(d=4,3);
          }
 
            difference() {
                union() {        
                
                    // pillar
                    hull() {
                        translate([-18,0,0])cylinder(d=15,6);
                        translate([-7.5,0,0])cylinder(d=7,23);
                    }    
                    
                    //base
                    hull() 
                    {
                        translate([-16,0,0])cylinder(d=15,3);
                        translate([0,0,0])cylinder(d=25,3);
                    }

                    hull() 
                    {
                        translate([-7.5,0,0])cylinder(d=6.5,4);
                        translate([7.5,0,0])cylinder(d=9,4);
                    }
                   
                    hull() {
                        translate([-7.5,0,4])scale([8,6.5,1])cylinder(d=1,0.1);
                        translate([-7.5,0,10])cylinder(d=6.5,0.1);
                    }
                    
                    //eyes
                    translate([-6,-2.5,20])sphere(d=4);
                    translate([-6,2.5,20])sphere(d=4);
                    
                }

                // back notch
                translate([-33,0,-1])cylinder(d=25,50);
                
                // racket hole
                hull() {
                    translate([3,0,(11/2)+4])rotate([90,0,0])translate([0,0,-10])scale([4,13,1])cylinder(d=1,20);
                    translate([-2,0,(11/2)+4])rotate([90,0,0])translate([0,0,-10])scale([4,13,1])cylinder(d=1,20);
                }        
                translate([-2,0,(11/2)+3.5])rotate([90,0,0])translate([0,0,-10])scale([5.75,4,1])cylinder(d=1,20);
            }
        }
    
        
        // M3 holes
        translate([-7.5,0,-50])cylinder(d=3.5,100);
        translate([7.5,0,-50])cylinder(d=3.5,100); 
        translate([7.5,0,2])cylinder(d=6,10); 
    }
    
 }

 
translate([-104,0,0]) E();

        
        
        
