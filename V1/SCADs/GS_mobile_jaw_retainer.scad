$fn=120;



module m3_screw_hole() {
 cylinder(d=3.75,21);
 translate([0,0,20])cylinder(d=6,10);  
}

module retainer() {
    difference() {
        hull() {
            for(y=[-12,12]) translate([0,y,0])cylinder(d=13,1);            
            for(y=[-12,12]) translate([0,y,1]) scale([13,13,6])sphere(d=1);            
        }       
        for(y=[-12,12]) translate([0,y,-19])m3_screw_hole();        
        translate([0,0,-50])cube([100,100,100], true);
    }
}

retainer();
