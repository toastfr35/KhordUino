// 110, 10
$fn=90;


rotate([0,0,180])
difference() {
    union() {
        translate([0,0,3])cube([120,20,6],true);
        translate([0,-8,10])cube([120,4,20],true);
        
        
    }
    
    translate([56,0,-1])cylinder(d=3.5,20);
    translate([56,0,3])rotate([0,0,30])cylinder(d=7.25,20,$fn=6);
    
    translate([-56,0,-1])cylinder(d=3.5,20);
    translate([-56,0,3])rotate([0,0,30])cylinder(d=7.25,20,$fn=6);
    
    
    translate([45,0,13])rotate([90,0,0])cylinder(d=3.5,20);
    translate([-45,0,13])rotate([90,0,0])cylinder(d=3.5,20);
    
    
    translate([45,-5.5,13])rotate([90,0,0])cylinder(d2=3.5,d1=8,2);
    translate([-45,-5.5,13])rotate([90,0,0])cylinder(d2=3.5,d1=8,2);
}



