$fn=120;


module shuttle_B_body() {
    s=40;
    l=60;
    {
        difference() {
        
            // body
            union() {
                translate([-170,-s,10])rotate([0,-90,0])cylinder(d=20,50);
                translate([-170,s,10])rotate([0,-90,0])cylinder(d=20,50);
                translate([-170-25,0,10+2]) cube([50,2*s,20+4],true);           
            }
            
            // bearings
            translate([-90,-s,10])rotate([0,-90,0])cylinder(d=15,150);
            translate([-90,s,10])rotate([0,-90,0])cylinder(d=15,150);
            
            // side slits
            translate([-180,10+s,9.5]) cube([100,10,1],true);
            translate([-180,-10-s,9.5]) cube([100,10,1],true);            
            
            // middle slot
            hull() {
                translate([-90,0,13])rotate([0,-90,0])cylinder(d=8,150);
                translate([-90,0,7])rotate([0,-90,0])cylinder(d=10,150);
                translate([-90,0,0])rotate([0,-90,0])cylinder(d=10,150);
            }
            
            // main cavity
            translate([-200-28,0,13]) cube([l,62,14.01],true);
                        
            // springs cavity
            for (y=[-1,1]) {
                hull() {
                    translate([-175.01,y*23,13])rotate([0,-90,0])cylinder(d=14,23);
                    translate([-175.01,y*13,13])rotate([0,-90,0])cylinder(d=14,23);
                }
                translate([-150,y*22,13])rotate([0,-90,0])cylinder(d=3.5,100);
                translate([-150,y*12,13])rotate([0,-90,0])cylinder(d=3.5,100);
            }
                
            // insert holes
            translate([-170-6,0,17]) cylinder(d=4,60);
            translate([-170-6,-s+6,17]) cylinder(d=4,60);
            translate([-220+6,-s+6,17]) cylinder(d=4,60);
            translate([-170-6,s-6,17]) cylinder(d=4,60);
            translate([-220+6,s-6,17]) cylinder(d=4,60);
                        
       }
    }   
}


STL=0;
if (STL==1) {
    rotate([0,90,180])shuttle_B_body();
} else {
    shuttle_B_body();
}






