$fn=60;

module kub(x,y,z,r) 
{
    hull() {
        translate([r-(x/2),r-(y/2),0]) cylinder(z,r=r);
        translate([r-(x/2),(y/2)-r,0]) cylinder(z,r=r);
        translate([(x/2)-r,r-(y/2),0]) cylinder(z,r=r);
        translate([(x/2)-r,(y/2)-r,0]) cylinder(z,r=r);
    }
}

module logo() 
{
color("Orange") kub(100,70,1,5);
color("black")
linear_extrude(1.5)
translate([-2.5-50,-43-35,0])scale([0.5,0.5,0.5])import("../base/logo.svg");
}

logo();
