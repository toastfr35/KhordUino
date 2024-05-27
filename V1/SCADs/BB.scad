$fn=120;

module base_board()
{ 
    th=18;

    difference() {
        union() {
            hull() {  
                translate([-150,-120,0])cylinder(th,d=100,$fn=180);
                translate([-150,120,0])cylinder(th,d=100,$fn=180);
                translate([550,-120,0])cylinder(th,d=100,$fn=180);
                translate([550,120,0])cylinder(th,d=100,$fn=180);
            }
        }
        translate([0,0,-1])cylinder(20,d=246,$fn=180);
        translate([390,0,0])cube([350,38,100],true);
        translate([390,-100,-47]) cube([140,90,500],true);
        
        for (a=[0:60:360]) rotate([0,0,a+30])translate([137,0,-50])cylinder(d=6,100);
        
    }    
}   


base_board();
    