$fn=120;

module woodscrew_hole(d) {
    d2 = 2*d;
    h=2;
    translate([0,0,-50]) {
        cylinder(d=d,50);
        translate([0,0,50-0.01])cylinder(d1=d,d2=d2,h+0.02);
        translate([0,0,50+h])cylinder(d=d2,50);
    }
}



module string_puller_end_bracket() {
    e=7;
    s=40;
    l=35;
    l2=l+5;
    za=0.5;
    
    difference() {
        union() {
        
            // body center
            translate([-46.5,0,za/2])cube([20,57,57-za],true);
            translate([-46.5,0,za/2])cube([20,70,57-za],true);
            
            // body top
            hull() {
                translate([-36.5,-29,29])rotate([0,-90,0])cylinder(d=12,20);
                translate([-36.5,29,29])rotate([0,-90,0])cylinder(d=12,20);
            }

            // body width
            hull() {
                translate([-36.5,-s,10])rotate([0,-90,0])cylinder(d=16,20);
                translate([-36.5,s,10])rotate([0,-90,0])cylinder(d=16,20);
                translate([-46.5,55,za-57/2])cylinder(d=20,20);
                translate([-46.5,-55,za-57/2])cylinder(d=20,20);
            }
            
            // lateral back supports
            for(i=[1,-1])
            hull() {
                translate([-46.5+l,i*60,za-57/2])cylinder(d=16,10);
                translate([-46.5,i*35,za-57/2])cylinder(d=16,10);
                translate([-46.5,i*35,13])sphere(d=10);
            }

            // middle back support
            hull() {
                translate([-46.5+l2,0,za-57/2])cylinder(d=24,10);
                translate([-46.5+2,0,za-57/2])cylinder(d=24,10);
                translate([-46.5+8,0,6])sphere(d=24);
                translate([-16,0,6])sphere(d=16);
            }
    
            // bottom plate
            hull() {
                translate([-46.5+l,60,za-57/2])cylinder(d=16,2);
                translate([-46.5+l,-60,za-57/2])cylinder(d=16,2);
                translate([-46.5,35,za-57/2])cylinder(d=16,2);
                translate([-46.5,-35,za-57/2])cylinder(d=16,2);
                translate([-46.5+l2,0,za-57/2])cylinder(d=24,2);
            }
            
            // wiring tube
            translate([-32,16,za-57/2]) cylinder(d=10,20,$fn=60);
    
        }              
                
        // center hole for bearing and T8
        translate([-48,0,0])rotate([0,-90,0])cylinder(d=22.5,9,$fn=120);
        translate([-46,0,0])rotate([0,-90,0])cylinder(d=18,100,$fn=120);
        translate([-25,0,0])rotate([0,-90,0])cylinder(d=10,100,$fn=120);
        
        // push screw hole
        translate([20,0,0])rotate([0,-90,0])cylinder(d=5.5,100,$fn=120);
        translate([12,0,0])rotate([0,-90,0])cylinder(d=12,19,$fn=120); // head
        translate([-20,0,0])rotate([0,-90,0])cylinder(d=9.25,5.5,$fn=6); // nut
        
        // rail holes
        translate([-41.6,-s,10])rotate([0,-90,0])cylinder(d=8.75,15,$fn=60);
        translate([-41.6,s,10])rotate([0,-90,0])cylinder(d=8.75,15,$fn=60);        
                
        // limit switch hole
        translate([-35.51,0,-6])
        rotate([0,0,90]) translate([-12.5,4,25]) {
           translate([2,6,2])cube([21,10+1,6.4]);
           translate([2,-3.02,2.5])cube([21,30,5.5]);
        }

        // woodscrew holes
        translate([-47,-55,-10])woodscrew_hole(4.5);
        translate([-47,55,-10])woodscrew_hole(4.5);
        translate([-46.5+l,60,-20])woodscrew_hole(4.5);
        translate([-46.5+l,-60,-20])woodscrew_hole(4.5);
        translate([-46.5+l2+4,0,-20])woodscrew_hole(4.5);

        // wiring hole
        translate([-32,16,za-57/2-0.5]) cylinder(d=7,18,$fn=60);
        translate([-32,16,za-57/2]) cylinder(d=4,50,$fn=60);               
    }    
}
     
     
translate([0,0,28]) string_puller_end_bracket();
    