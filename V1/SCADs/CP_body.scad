$fn=90;

module kub(x,y,z,r) 
{
    hull() {
        translate([r-(x/2),r-(y/2),0]) cylinder(z,r=r);
        translate([r-(x/2),(y/2)-r,0]) cylinder(z,r=r);
        translate([(x/2)-r,r-(y/2),0]) cylinder(z,r=r);
        translate([(x/2)-r,(y/2)-r,0]) cylinder(z,r=r);
    }
}


// LCD
// 80 x 36
// screw hole centers 75 x 31
// LCD hole 58 x 12
// LCD height : 7


module LCD_holes(h) 
{
    cube([58,14,50],true);
    for (x=[-75/2,75/2]) for(y=[-31/2,31/2]) {
        translate([x,y,-20]) cylinder(d=3.5,50);
        translate([x,y,h-2]) cylinder(d=6.2,50);
    }
}

module LCD_poles() 
{
    for (x=[-75/2,75/2]) for(y=[-31/2,31/2])
    translate([x,y,-7]) difference() {
        cylinder(d=7.5,7);
        translate([0,0,-1])cylinder(d=4,10);
    }
}


l=140;
w=90;    


module box_poles_holes(h) {
    for (x=[-l/2+8,l/2-8]) for (y=[-w/2-2,w/2-18]) {        
        translate([x,y,-1])cylinder(d=3.5,100);
        translate([x,y,h-2])cylinder(d=6.2,100);
    }
}


module box_cover() { 
    e=1.5;
    h=10;
    difference() {
        
        union() {
            difference() {
                union() {
                    translate([0,-10,-5]) kub(l,w,e+5,5);
                    hull() {
                        translate([0,-10,h]) kub(l-2,w-2,1,5);
                        translate([0,-10,0]) kub(l+10,w+10,1,5);
                    }
                }
                translate([0,-10,-4+3]) kub(l-30,w-10,h+1,5);
            }
            translate([0,0,h])LCD_poles();    
        }
        
        translate([0,-10,-10]) kub(l-3,w-3,10,4.2);
        LCD_holes(h);
        for(x=[-30,0,30]) translate([x,-29,-1]) cylinder(d=13.5,20);
        box_poles_holes(h);
        
        
        translate([30,-45,h+1.5-0.7])
        linear_extrude (5)
        text  ("+", size=12, halign="center", valign="center", font="Arial:style=Bold");
        
        translate([-31,-45,h+1.5-0.7])
        linear_extrude (5) scale([2,1,1])
        text  ("-", size=12, halign="center", valign="center", font="Arial:style=Bold");

        for (y=[0,3.5,7])
        translate([0,-46.5+y,h+1.5-0.7])
        linear_extrude (5) scale([1,1.2,1])
        text  ("_", size=12, halign="center", valign="center", font="Arial:style=Bold");

        
        
    }
    
}






module board_pole() 
{
    difference() {
        union() {
            cylinder(d=11,6);
            cylinder(d=7,8);
        }
        cylinder(d=4,20);
        translate([0,0,2])cylinder(d=6.6,3,$fn=6);
    }
    
    
}    

module board_poles() 
{
    board_pole();
    translate([65.5,0,0])board_pole();
    translate([65.5,53.4,0])board_pole();
    translate([65.5-49.2,53.4,0])board_pole();
}


module box_pole(h) {
    difference() {
        cylinder(d=11,h);
        translate([0,0,20])cylinder(d=4,h+2);
        translate([0,0,h-8])cylinder(d=6.6,3,$fn=6);
    }
}


module box_poles(h) {
    translate([-l/2+8,w/2-18,0])box_pole(h-0.5);
    translate([l/2-8,w/2-18,0])box_pole(h-0.5);
    translate([-l/2+8,-w/2-2,0])box_pole(h-0.5);
    translate([l/2-8,-w/2-2,0])box_pole(h-0.5);
}




module box() { 
    h=50+15;
    difference() {
        union() {
            difference() {
                union() {
                    translate([0,-10,0]) kub(l,w,h-4,5);
                    translate([0,-10,0]) kub(l-3.5,w-3.5,h,5);
                    hull() {
                        translate([0,-w/2-20,h-7-12])cylinder(d=20,2);
                        translate([0,w/2,h-7-12])cylinder(d=20,2);
                        translate([0,-10,0])cylinder(d=1,2);
                    }
                }
                translate([0,-10,1.5]) kub(l-6,w-6,h,4.2);

                translate([0,-w/2-20,0])cylinder(d=4.5,100);
                translate([0,w/2,0])cylinder(d=4.5,100);
                translate([0,-w/2-20,h-22])cylinder(d1=10,d2=4.5,2);
                translate([0,w/2,h-22])cylinder(d1=10,d2=4.5,2);
                translate([0,-w/2-20,0])cylinder(d=10,h-22);
                translate([0,w/2,0])cylinder(d=10,h-22);

            }                        
        }
        
        translate([0,-10,0])
        for(z=[0,18]) {
            for(y=[-10,0,10])
            translate([-100,y-10,10+z]) rotate([0,90,0]) cylinder(d=9,200,$fn=6);
            for(y=[-15,-5,5,15])
            translate([-100,y-10,10+9+z]) rotate([0,90,0]) cylinder(d=9,200,$fn=6);
        }
        
        translate([40,w/2-15,20]) cube([15,10,12]);
        translate([-46,-w/2-15,35]) rotate([-90,0,0]) cylinder(10,d=11);
        
    }

    box_poles(h);

    translate([-33,-37,1.5]) board_poles();    
    //translate([0,-10,0]) cube([73,60,5],true);

    //translate([52,-10,0]) cube([30,10,50],true);
    //#translate([-54,12,0]) cube([25,10,50],true);
    
}


module box_all()  {
    box();
    translate([0,0,66]) box_cover();
}


//box_cover();

box();


