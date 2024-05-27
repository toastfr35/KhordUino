$fn=90;


module woodscrew_hole(d) {
    d2 = 2*d;
    h=2;
    translate([0,0,-50]) {
        cylinder(d=d,50);
        translate([0,0,50-0.01])cylinder(d1=d,d2=d2,h+0.02);
        translate([0,0,50+h])cylinder(d=d2,50);
    }
}

module PSU() {
	translate([100,0,0])cube([200,114,50],true);
    translate([31,100,-12.5]) rotate([90,0,0])cylinder(d=4.5,200);
    translate([48,-114/2+37,0])cylinder(d=60,50);
}


module B() {
    difference() {
        union() {
        	translate([25,0,0])cube([50,114+4,50+4],true);
            translate([25,0,-24.5])cube([50,150,5],true);
        }
        translate([2,0,0])PSU();
                
        translate([25,-67,-25])woodscrew_hole(4.5);
        translate([25,67,-25])woodscrew_hole(4.5);
    }
}


rotate([0,0,180]) rotate([0,-90,0]) B();

