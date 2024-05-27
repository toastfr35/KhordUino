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


module A()
{
    difference() {
        union() {
            cylinder(d=20,10);
            translate([0,5,0])cube([25,5,10]);
        }
 
        translate([0,0,-1])cylinder(d=12.5,20);
        translate([23.5,0,-1])rotate([0,0,45])cube([25,5,12]);
    }   
}

module B() {
  dz=1.75;
  difference() {
    union() {
        cylinder(d=12,10+dz);  
        translate([0,0,10+dz])cylinder(d=20,2);  
    }
    translate([0,0,11])woodscrew_hole(4);
  }
}


A();

translate([0,25,13.75])mirror([0,0,1]) B();