use <CP_body.scad>;

STL=0;
if (STL==1) {
    rotate([0,180,0]) box_cover();
} else {
    box_cover();
}
