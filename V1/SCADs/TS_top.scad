$fn=120;

module kub(x,y,z,r) 
{
    hull() {
        translate([r-(x/2),r-(y/2),0]) cylinder(z,r=r);
        translate([r-(x/2),(y/2)-r,0]) cylinder(z,r=r);
        translate([(x/2)-r,r-(y/2),0]) cylinder(z,r=r);
        translate([(x/2)-r,(y/2)-r,0]) cylinder(z,r=r);
    }
}

module kub2(x,y,z,r) 
{
    r2=r+1.5;
    hull() 
    {
        translate([r-(x/2),r-(y/2),0]) cylinder(z-r2,r=r);
        translate([r-(x/2),r-(y/2),z-r2]) scale([r,r,r2])sphere(r=1);        
        translate([r-(x/2),(y/2)-r,0]) cylinder(z-r2,r=r);
        translate([r-(x/2),(y/2)-r,z-r2]) scale([r,r,r2])sphere(r=1);        
        translate([(x/2)-r,r-(y/2),0]) cylinder(z-r2,r=r);
        translate([(x/2)-r,r-(y/2),z-r2]) scale([r,r,r2])sphere(r=1);        
        translate([(x/2)-r,(y/2)-r,0]) cylinder(z-r2,r=r);
        translate([(x/2)-r,(y/2)-r,z-r2]) scale([r,r,r2])sphere(r=1);
    }
}


module shuttle_A_top() {
    s=40;
    l=60;
    
    difference() {
    
        // main body
        hull() {
            translate([-100-l/2,0,20-3]) kub2(l,70,8+4+3,3);
            translate([-100-l/2+25,0,20-3]) kub2(l,20,8+4+3,3);
        }
        
        // bottom cutout
        translate([-100-l/2,0,20-12]) kub(l+1,90,8+4,3);                
        
        // screw holes
        for(y=[-27,27]) for(x=[-102-5,-98-l+5]) {
            translate([x,y,14.1])cylinder(d=4,100);
            translate([x,y,32-4])cylinder(d=6.5,5);
        }
        
        // inner hole for wiring
        translate([-100-l/2,0,19.9]) kub(l-23,70-4,6.5+4,1);
        translate([-100-l/2-4,0,19.9]) kub(l-13,70-25,6.5+4,1);
    }
    
    // extra blocks to stop things moving inside
    translate([-100-l/2-12,-12,20]) kub(25,15,8+4,3);
    translate([-100-l/2-12,15,20]) kub(25,10,8+4,3);
    
}

STL=0;
if (STL==1) {
    rotate([0,180,0])shuttle_A_top();
} else {
    shuttle_A_top();
}

