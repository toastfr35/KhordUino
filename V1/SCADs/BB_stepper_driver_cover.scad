$fn=90;

a=50;
b=30;

difference() {

    union() {
        hull() {
            translate([-90/2,0,0])cube([90,15,25]);
            translate([-50/2,50,0])cube([50,1,25]);
        }
        translate([-50/2,50,0])cube([50,15,25]);

        hull() {
            translate([a,7,0]) cylinder(d=14,25);
            translate([-a,7,0]) cylinder(d=14,25);
        }

        hull() {
            translate([b,58,0]) cylinder(d=14,25);
            translate([-b,58,0]) cylinder(d=14,25);
        }
    
    }

    hull() {
       translate([-86/2,-0.1,2])cube([86,15,25]);
       translate([-46/2,50,2])cube([46,1,25]);
    }
    translate([-46/2,50,2])cube([46,13,25]);

    // screw holes    

    translate([a,7,-1]) cylinder(d=4.5,30);
    translate([a,7,3]) cylinder(d2=4.5,d1=10,2);
    translate([a,7,-1]) cylinder(d=10,4.01);

    translate([-a,7,-1]) cylinder(d=4.5,30);
    translate([-a,7,3]) cylinder(d2=4.5,d1=10,2);
    translate([-a,7,-1]) cylinder(d=10,4.01);

    translate([b,58,-1]) cylinder(d=4.5,30);
    translate([b,58,3]) cylinder(d2=4.5,d1=10,2);
    translate([b,58,-1]) cylinder(d=10,4.01);
    
    translate([-b,58,-1]) cylinder(d=4.5,30);
    translate([-b,58,3]) cylinder(d2=4.5,d1=10,2);
    translate([-b,58,-1]) cylinder(d=10,4.01);
    
    // cable hole
    translate([0,60,13])rotate([-90,0,0])cylinder(d=12,10);
    
}    
    
//#translate([-80/2,40,0])cube([80,1,25]);
