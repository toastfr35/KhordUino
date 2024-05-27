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
    translate([100-35,0,0])cube([200,114-10,50-10],true);
    translate([32,100,-12.5]) rotate([90,0,0])cylinder(d=4.5,200);
    translate([32,0,12.5]) rotate([90,0,0])cylinder(d=4.5,100);    
    translate([30+33/2,28,5])cube([33,28,50], true);
    translate([30+33/2,-28,5])cube([33,28,50], true);
}


module A() {
    difference() {
        union() {
        	translate([55,0,0])cube([110,114+4,50+4],true);
            translate([55,0,-24.5])cube([110,150,5],true);
        }
        translate([35+2,0,0])PSU();
                
        translate([0,0,0]){
            cube([50,27,19],true);
            translate([-10,20,0])rotate([0,90,0]) cylinder(50,d=3.5);
            translate([-10,-20,0])rotate([0,90,0]) cylinder(50,d=3.5);
        }

        translate([0,40,0]){
            cube([50,12.5,19],true);
        }

        translate([0,-40,0]){
            translate([-10,0,0])rotate([0,90,0]) cylinder(50,d=4);
        }
        
        
        translate([10,-67,-25])woodscrew_hole(4.5);
        translate([10,67,-25])woodscrew_hole(4.5);
        translate([100,-67,-25])woodscrew_hole(4.5);
        translate([100,67,-25])woodscrew_hole(4.5);
        
        translate([20,0,27-0.5]) linear_extrude(1) rotate([0,0,-90])
        text("24V", valign="center", halign="center", size=20);
        
    }
}


rotate([0,0,180]) rotate([0,-90,0]) A();