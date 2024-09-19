$fn=90;

l=30;
l2=40;
w1=20;
w2=15;
h=12;
w3=5;
m=0.75;


module racket_holder_1_A(q=10) {
    translate([0,0,2])
    difference() {
        union() {
            translate([-q,-w1/2,h/2-h/2-8])cube([l+q,w1,h/2+8]);
            translate([-q,-w2/2,0])cube([l+q,w2,h+0.5]);
            hull() {
                translate([-q,-w1/2,-8])cube([2.9,w1,1]);
                translate([-q,-19,12.5])cube([5,38,1]);
            }
        }
        translate([-5-q,0,h/2 - 2])rotate([0,90,0])cylinder(d=6,l+q+10);
    }
    
    translate([10-q,0,h+2.5])scale([1,1,1.15])rotate([0,0,90])import("../base/spreader.stl");
    translate([12-q,0,h+2.5])scale([1,1,1.15])rotate([0,0,90])import("../base/spreader.stl");
    translate([0-q,-w2/2,h+0.3])cube([10.3,w2,5.65]);
    translate([0-q,-1.97,h+1])cube([6,4,13]);
    
    
}


rotate([0,-0,180])
rotate([0,-90,0])
racket_holder_1_A();



        






