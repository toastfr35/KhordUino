$fn=60;

module D() {
    import("../base/Underdesk_Drawer.stl");
}


module D1() {
    difference() {
        D();
        translate([-150,0,-150])cube([300,300,300]);
    }
}

module D2() {
    intersection() {
        D();
        translate([-150,0,-150])cube([300,300,300]);
    }
}

module E() {
    dy=19;
    render() {
        translate([0,dy,0])D1();
        translate([0,-dy,0])D2();
    }
}
 
module E1() {
    difference() {
        E();
        translate([-150,-150,0])cube([300,300,20]);
    }
}

module E2() {
    intersection() {
        E();
        translate([-150,-150,0])cube([300,300,20]);
    }
}


module F() {
    dz=8;
    render() {
        translate([0,0,-dz])E1();
        translate([0,0,0])E2();
    }
}

module woodscrew_hole(d) {
    d2 = 2*d;
    h=2;
    translate([0,0,-50]) {
        cylinder(d=d,50);
        translate([0,0,50-0.01])cylinder(d1=d,d2=d2,h+0.02);
        translate([0,0,50+h])cylinder(d=d2,50);
    }
}

module G() {
    //#scale([1,0.82,1]) import("../base/Drawer_Runners_Wide__Long.stl");
    
    difference() {
        union() {
            translate([-100,-76,0])cube([200,10,5]);
            translate([-100,0,0])cube([200,10,5]);
            translate([-100,71,0])cube([200,10,5]);
          
            translate([-100,-79.85,0])cube([200,4,12]);
    
            translate([-100,-79,0])cube([5,160,5]);
            translate([95,-79,0])cube([5,160,5]);
    
            hull() {
                translate([-100,-79,5])cube([5,160,0.001]);
                translate([-100,-79,12])cube([10,160,0.001]);
            }    

            hull() {
                translate([95,-79,5])cube([5,160,0.001]);
                translate([90,-79,12])cube([10,160,0.001]);
            }    
        }
        
        for(y=[-71.5,5]) for(x=[-85,0,85]) {
            translate([x,y,1.5])woodscrew_hole(4);
        }    

        for(y=[76]) for(x=[-85,-30,85]) {
            translate([x,y,1.5])woodscrew_hole(4);
        }    
    
        translate([-10,56,-1])cube([28,20,10]);
    
    }
    
}


module latch() {
translate([0,84,22]) {
    rotate([90,0,0]) cylinder(d=19.5,10);

    rotate([0,45,0])
    hull() {
        translate([16.5,-8.5,0])rotate([90,0,0]) cylinder(d=10,2);
        translate([0,-8.5,0])rotate([90,0,0]) cylinder(d=22,2);
    }
    
    translate([0,-3,0])rotate([90,0,0]) cylinder(d=22,7);

}
}

/*
#G();
#translate([0,6.5,54])mirror([0,0,1])F();
*/  
  
F();


