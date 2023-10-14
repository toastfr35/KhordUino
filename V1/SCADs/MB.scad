$fn = 120;


module woodscrew_hole(d) 
{
    d2 = 2*d;
    h=2;
    translate([0,0,-50]) {
        cylinder(d=d,50);
        translate([0,0,50-0.01])cylinder(d1=d,d2=d2,h+0.02);
        translate([0,0,50+h])cylinder(d=d2,50);
    }
}


module string_puller_nema23_bracket() 
{
    e=7;
    l=20;
    s=40;
    za=0.5;
    
    difference() {
        
        union() {
        
            // body center part
            translate([-46.5,0,za/2])cube([20,57,57-za],true);
            translate([-46.5,0,za/2])cube([20,70,57-za],true);
            translate([-46.5,0,0])cube([20,34,70],true);
            
            // body top
            hull() {
                translate([-36.5,-29,29])rotate([0,-90,0])cylinder(d=12,20);
                translate([-36.5,29,29])rotate([0,-90,0])cylinder(d=12,20);
            }          
            
            // body sides
            hull() {
                translate([-36.5,-s,10])rotate([0,-90,0])cylinder(d=16,20);
                translate([-36.5,s,10])rotate([0,-90,0])cylinder(d=16,20);
                translate([-46.5,0,za+10-57/2])cube([20,130,20],true);
            }
            
            // back supports
            for(i=[1,-1])
            hull() {
                translate([-46.5+55,i*38,za-57/2])cylinder(d=16,10);
                translate([-46.5,i*38,za-57/2])cylinder(d=16,10);
                translate([-46.5+8,i*38,16])sphere(d=4);
            }
        }              
        
        // motor flange hole
        translate([-32.5-2,0,0])rotate([0,-90,0])cylinder(d=40,4,$fn=120);
        
        // coupler hole
        translate([0,0,0])rotate([0,-90,0])cylinder(d=32,310,$fn=120);
        
        // rail holes
        translate([-41.6,-s,10])rotate([0,-90,0])cylinder(d=8.75,15,$fn=60);
        translate([-41.6,s,10])rotate([0,-90,0])cylinder(d=8.75,15,$fn=60);        
        
        // nema mounting holes
        for(x=[-47.14/2,47.14/2])for(y=[-47.14/2,47.14/2]) {
            translate([-5.5,x,y])rotate([0,-90,0])cylinder(d=5.2,100,$fn=30);
            translate([-56.5+5,x,y])rotate([0,-90,0])rotate([0,0,30])cylinder(d=9.25,100,$fn=6);
        }
        
        // switch hole 
        translate([-35.51,0,-8])
        rotate([0,0,90]) translate([-12.5,4,25]) {
           translate([2,6,2])cube([21,10+1,6.4]);
           translate([2,-3.02,2.5])cube([21,30,5.5]);
        }

        // Woodscrew holes
        translate([-47,-55,-10])woodscrew_hole(4.5);
        translate([-47,55,-10])woodscrew_hole(4.5);
        translate([-46.5+55,38,-20])woodscrew_hole(4.5);
        translate([-46.5+55,-38,-20])woodscrew_hole(4.5);

        // Wiring guide hole
        difference(){
            translate([-26.5-5,0,0])rotate([0,-90,0])cylinder(d=50,10,$fn=90);
            translate([0,0,0])rotate([0,-90,0])cylinder(d=45,100,$fn=90);
            translate([0,-50,0])cube([100,100,100],true);
        }
        translate([-38.5,0,-32.5])cube([5,5,20],true);               
    }    
}

        
        
        
STL=0;
if (STL==1) {
    rotate([0,-90,0]) translate([0,0,28])string_puller_nema23_bracket();
} else {
    translate([0,0,28])string_puller_nema23_bracket();
}