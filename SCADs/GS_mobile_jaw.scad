$fn=120;


h=10;
d1=48;
d2=52;
d3=6;
x=(d2-d1)/2;
k=5;


module b(higher)
{
    intersection() {
        difference() {
            union() {
                cylinder(d=d2,h);
            }
            translate([52,0,0]) cube([100,100,100],true);
        }
        union() {
            hull() {
                translate([-d3/2,(d2/2)-(d3/2)-0.3,-1]) cylinder(d=d3,h+30);
                translate([-d3/2,-(d2/2)+(d3/2)+0.3,-1]) cylinder(d=d3,h+30);
                translate([-100,(d2/2)-(d3/2),-1]) cylinder(d=d3,h+30);
                translate([-100,-(d2/2)+(d3/2),-1]) cylinder(d=d3,h+30);
            }
            translate([0,0,h+3.5])rotate([0,45,0])cube([5,d2-6,5],true);
        }
    }
}


module core()
{
    difference() 
    {
        b();

        translate([0,0,h/2])
        rotate_extrude(angle=360) translate([d1/2, 0])
        {
            hull() {
                translate([1,0])circle(d=2);
                translate([1+x,3])circle(d=2);
                translate([1+x,-3])circle(d=2);
            }
        }

        translate([-d1*1.5+10,0,h/2])
        scale([1.5,1,1])
        rotate_extrude(angle=360) translate([d1, 0])
        {
            translate([1,0])circle(d=6);
        }

        translate([-1,0,h/2+0.3])rotate([0,-90,0])cylinder(d=6.7,9.5);        
    }
}




module mobile_jaw() {
    h=1;
    m=0.2;    
    difference() {
        mirror([1,0,0])core();
        translate([10,0,h/2])cube([26+2*m,5+2*m,h+2*m],true);
        translate([10,20,h/2])cube([26+2*m,5+2*m,h+2*m],true);
        translate([10,-20,h/2])cube([26+2*m,5+2*m,h+2*m],true);
        
        // pillar holes
        for(y=[-12,12])
        hull() {
            translate([8,y,-1])cylinder(d=10+m,20);
            translate([8+4,y,-1])cylinder(d=10+m,20);
        }
        
        translate([0,0,12])rotate([0,45,0])cube([5,100,5],true);        
    }
    
    // tab
    translate([0,0,10]) {
        intersection() {
            cylinder(d=d2,2);
            translate([24.5,0,0])cube([5,20,3],true);
        }
    }
}


STL=0;
if (STL==1) {
    rotate([0,-90,0]) mobile_jaw();
} else {
    mobile_jaw();
}