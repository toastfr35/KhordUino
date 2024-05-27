$fn=120;

module top_board()
{ 
    difference() {
        cylinder(18,d=340,$fn=180);
        translate([0,0,-1])scale([1,0.8,1])cylinder(20,d=240,$fn=180);
        
        for (a=[0:60:360]) rotate([0,0,a+30])translate([125,0,-50])cylinder(d=6,100);
        for (a=[0:60:360]) rotate([0,0,a+30])translate([125,0,18-5])cylinder(d=9,100);

        rotate([0,0,25])translate([142,0,-1])cylinder(d=14,100);
        
    }
}   

top_board();