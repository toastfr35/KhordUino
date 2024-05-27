$fn=60;



module woodscrew_hole(d) {
    d2 = 2*d;
    h=2;
    translate([0,0,-50]) {
        cylinder(d=d,50);
        translate([0,0,50-0.01])cylinder(d1=d,d2=d2,h+0.02);
        translate([0,0,50+h])cylinder(d=d2,50);
    }
}


module X(d,w1,w2) {
    difference() {
        hull() {
            translate([-w2/2-d/2,0,0])cylinder(d=w1,d+2);
            translate([w2/2+d/2,0,0])cylinder(d=w1,d+2);
        }
        
        hull() {
            translate([0,50,d/2])rotate([90,0,0])cylinder(d=d,100);
            translate([0,50,-d/2])rotate([90,0,0])cylinder(d=d,100);
        }
        
        translate([-w2/2-d/2,0,d]) woodscrew_hole(4.5);
        translate([w2/2+d/2,0,d]) woodscrew_hole(4.5);
        
    }
}

mirror([0,0,1]) {
X(7,15,10);
translate([0,20,2])X(5,12,10);
translate([0,35,3.5]) X(3.5,12,10);
translate([0,50,3.5]) X(3.5,12,10);
}

/*
difference() {
    union() {
        hull() {
            translate([-20,0,0])cylinder(d=20,25);
            translate([20,0,0])cylinder(d=20,25);
        }
        hull() {
            translate([-40,0,20])cylinder(d=22,7);
            translate([40,0,20])cylinder(d=22,7);
        }
    }
    translate([-13,-25,0]) cube([26,50,18.5]);
    translate([-20,0,26]) woodscrew_hole(4.5);
    translate([20,0,26]) woodscrew_hole(4.5);
    
    translate([0,50,24.5])rotate([90,0,0])cylinder(d=3.8,100);
    hull() {
        translate([0,50,24.5])rotate([90,0,0])cylinder(d=3,100);
        translate([0,50,124.5])rotate([90,0,0])cylinder(d=3,100);
    }

}
*/