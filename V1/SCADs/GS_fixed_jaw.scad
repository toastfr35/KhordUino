$fn=120;

h=10;
d1=48;
d2=52;
d3=6;
x=(d2-d1)/2;

k=5;

module fixed_jaw1()
{
    intersection() {
    
        difference() {
            union() {
                cylinder(d=d2,h);
                translate([0,0,h-1.6])cylinder(d1=d2,d2=d2+6,3.1);
                translate([0,0,h+1.5])cylinder(d=d2+6,1);
                translate([0,0,h+0.5])cylinder(d=d2,1);
            }
            translate([52,0,0]) cube([100,100,100],true);
        }
        union() {
            hull() {
                translate([-d3/2,(d2/2)-(d3/2)-0.3,-1]) cylinder(d=d3,h+30);
                translate([-d3/2,-(d2/2)+(d3/2)+0.3,-1]) cylinder(d=d3,h+30);
                translate([-100,(d2/2)-(d3/2),-1]) cylinder(d=d3,h+30);
                translate([-100,-(d2/2)+(d3/2),-1]) cylinder(d=d3,h+30);
            }
            translate([0,0,h+3.5])rotate([0,45,0])cube([5,d2-6,5],true);
        }
    }
}



module core()
{
    difference() 
    {
        fixed_jaw1();

        translate([0,0,h/2])
        rotate_extrude(angle=360) translate([d1/2, 0])
        {
            hull() {
                translate([1,0])circle(d=2);
                translate([1+x,3])circle(d=2);
                translate([1+x,-3])circle(d=2);
            }
        }

        translate([-d1*1.5+10,0,h/2])
        scale([1.5,1,1])
        rotate_extrude(angle=360) translate([d1, 0])
        {
            translate([1,0])circle(d=6);
        }

        h2=h/2+0.3;

        translate([-1,0,h2])rotate([0,-90,0])cylinder(d=6.7,9.5);
        translate([-1-9.5/2,0,h2+6.7/4])cube([9.5,6.7,6.7/2],true);
    }
}


module fixed_jaw() {
    h2=1;
    core();
    
    intersection() {
        union() {
            translate([10,0,h2/2])cube([40,5,h2],true);
            translate([10,20,h2/2])cube([25,5,h2],true);
            translate([10,-20,h2/2])cube([25,5,h2],true);
        }
        
        translate([3,0,0]) cylinder(d=d2+1,40);
    }
    
    for(y=[-12,12]) {
        difference() {
            translate([8+3.5,y,0])cylinder(d=10,h+0.2);
            translate([8+3.5,y,1])cylinder(d=4,50);
        }
    }
    
}


module m3_screw_hole() {
 cylinder(d=3.75,21);
 translate([0,0,20])cylinder(d=6,10);  
}


module string_clamp_plate() {
    s=40;
    {
        difference() {
            union() {
                difference() {
                    translate([-25-6,0,8]) cube([60,82,4],true);
                    translate([-25-7.5,15,9]) cylinder(d=d2+1,10);
                }
                translate([-25-10,15,9]) fixed_jaw();
            }
            
            
            
            // M3 screw holes
            translate([-6,0,-12]) m3_screw_hole();           // back
            translate([-6,-s+6,-12]) m3_screw_hole();        // back
            translate([170-220+6,-s+6,-12]) m3_screw_hole(); // front
            translate([-6,s-6,-12]) m3_screw_hole();         // back            
            
            translate([170-220+6,s-6,-1.5]) m3_screw_hole();   // front high
       }
    }  
   
}




string_clamp_plate();
