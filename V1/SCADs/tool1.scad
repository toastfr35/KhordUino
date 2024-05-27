$fn=120;


difference() {
    union() {
        cylinder(d=9,50,$fn=6);
        cylinder(d=9,20);
    }
    translate([0,0,-0.01])cylinder(d=7.25,4,$fn=6);
    translate([0,0,-0.01])cylinder(d=4.5,100);
}
    

