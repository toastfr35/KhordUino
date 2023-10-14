$fn=120;


module shuttle_A_body() {
    s=40;
    l=60;
    {
        difference() {
        
            // body
            union() {
            
                // body
                translate([-100,-s,10])rotate([0,-90,0])cylinder(d=20,l);
                translate([-100,s,10])rotate([0,-90,0])cylinder(d=20,l);
                translate([-100-(l/2),0,10]) cube([l,2*s,20],true);

                translate([-100,0,0])rotate([0,-90,0])cylinder(d=28,30);
                
                // wiring guide
                hull() {
                    translate([-144,-27.5,-5]) cylinder(d=10,5);
                    translate([-144,-27.5,0]) cylinder(d=20,1);
                }
                translate([-144,-27.5,-10]) cylinder(d=10,5);
                
            }
            
            // linear bearing holes
            for (y=[-s,s]) {
                translate([-99,y,10])rotate([0,-90,0])cylinder(d=15,27);
                translate([-99,y,10])rotate([0,-90,0])cylinder(d=13.5,100);
                translate([-l-74,y,10])rotate([0,-90,0])cylinder(d=15,27);
            }
            
            // leadscrew hole
            translate([-80,0,0])rotate([0,-90,0])cylinder(d=9,100);
            
            hull() {
                translate([-80-50,0,0])rotate([0,-90,0])cylinder(d=9,100);
                translate([-80-50,8,0])rotate([0,-90,0])cylinder(d=6.2,100);
                translate([-80-50,-8,0])rotate([0,-90,0])cylinder(d=6.2,100);
            }
            
            // nut screws
            translate([-80,8,0])rotate([0,-90,0])cylinder(d=4,100);
            translate([-80,-8,0])rotate([0,-90,0])cylinder(d=4,100);
            translate([-80,0,-8])rotate([0,-90,0])cylinder(d=4,100);
            
            // nut screws
            translate([-125,8,0])rotate([0,-90,0])cylinder(d=6.2,100);
            translate([-125,-8,0])rotate([0,-90,0])cylinder(d=6.2,100);
            translate([-125,0,-8])rotate([0,-90,0])cylinder(d=6.2,100);
            
            // nut hole
            translate([-90-7,0,0])rotate([0,-90,0])cylinder(d=11,10);

            // side slits
            translate([-120,10+s,9.5]) cube([100,10,1],true);
            translate([-120,-10-s,9.5]) cube([100,10,1],true);
            
            // loadcell space
            translate([-113-(l/2),0,13.01]) cube([27,45,14],true);
            translate([-102-(l/2),0,13.01]) cube([l,10,14],true);
            
            // bar notch
            hull() {
                translate([-108,20,13])rotate([90,0,0])cylinder(d=5,40);
                translate([-104,20,20])rotate([90,0,0])cylinder(d=5,40);
                translate([-107,20,20])rotate([90,0,0])cylinder(d=5,40);
            }
            
            // insert holes
            for(y=[-27,27]) for(x=[-102-5,-98-l+5]) {
                translate([x,y,-20])cylinder(d=3.5,100);
                translate([x,y,-20])cylinder(d=6.5,25,$fn=6);
            }
            
            // HX711
            translate([-126.5,-29.9,6]) cube([6,25,15]);
            translate([-144,-31,6]) cube([23.5,6,15]);
            
            // Hole for cable
            translate([-144,-27.5,-50]) cylinder(d=7,100);
            
            
        }
    }   
}


STL=0;
if (STL==1) {
    rotate([0,90,0])shuttle_A_body();
} else {
    shuttle_A_body();
}