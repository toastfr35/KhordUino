$fn=180;

od=300;
id=300-52;
id2=300-26;

module middle_ring() {
    h = 18;
    difference() {
        cylinder(d=od+10,h);        
        translate([0,0,-1])cylinder(d=id2+2,h+2);
        translate([0,0,-1])cylinder(d=od+1,9+1);

        for(a=[0:60:360]) rotate([0,0,15+a]) translate([(od/2)-6.5,0,-1])cylinder(d=6.5,50);     
    }
}

module middle_ring_segment() {
    h=18;
    m=9+3;
    difference() {
        middle_ring();
        rotate([0,0,20])translate([0,-200,-1])cube([200,200,m+1]);
        rotate([0,0,-20])translate([-200,0,m])cube([200,200,(h-m)+1]);
        
        rotate([0,0,10])translate([0,-200,-1])cube([200,200,h+2]);
        rotate([0,0,-10])translate([-200,0,-1])cube([200,200,h+2]);
        
        translate([0,-200,-1])cube([200,200,h+2]);
        translate([-200,-200,-1])cube([200,200,h+2]);
        translate([-200,0,-1])cube([200,200,h+2]);        
    }
}

module middle_ring_full() {
    rotate([0,0,0]) for (a=[0:120:360]) {rotate([0,0,a])middle_ring_segment();}
}


middle_ring_segment();
