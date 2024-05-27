$fn=90;

//---------------------------------------------------
// racket_holder_1
//---------------------------------------------------

l=30;
l2=40;
w1=20;
w2=15;
h=12;
w3=5;
m=0.75;

// a : -1,1
// x 2 130,158
module X(a,x,d,h) 
{
    translate([-122,0,0]) rotate([0,0,a*10]) translate([x,0,-3])cylinder(d=d,h,$fn=60);
}    
    
module X2(a,x,d,h) 
{
    translate([-122,0,0]) rotate([0,0,a*10]) translate([x,0,-3])cylinder(d=d,h,$fn=6);
}    
   

module racket_holder_1_B() {
    translate([0,0,2])
    difference() {
        union() {

            extra=10;
            hull() {
                translate([-extra,-w1/2-5,-3])cube([l2,w1+10,2]);
                translate([-extra+2,-w1/2-2,-3])cube([l2,w1+4,h+2]);
                translate([6,6,-3])cylinder(d=12,h+2);
                X(1,130,12,8);
                translate([6,-6,-3])cylinder(d=12,h+2);
                X(-1,130,12,8);
                translate([l2-6,12,-3])cylinder(d=12,h+2);
                X(1,158,13,8);
                translate([l2-6,-12,-3])cylinder(d=12,h+2);
                X(-1,158,13,8);
            }

            
            
                        
        }   
        translate([-28,-(w1+m)/2,h/2-h/2-(m/2)])cube([20+l2,w1+m,h/2+m]);
        translate([-28,-(w2+m)/2,-m/2])cube([l2+20,w2+m,h+m]);
        translate([l2-40,0,h/2])rotate([0,90,0])cylinder(d=5.5,50,$fn=60);
        
        for (x=[-1,1]) for (y=[130,158]) {
            translate([0,0,9.2]) X(x,y,6,20);
            translate([0,0,-5]) X(x,y,3.5,20);
        }
    }
}



racket_holder_1_B();

        






