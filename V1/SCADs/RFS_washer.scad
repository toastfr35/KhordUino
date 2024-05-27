$fn=90;
 
 
 module F()
 {
    difference() {
        cylinder(d=20,4);
        cylinder(d=5.5,5);
    }
 }
 
 
translate([-135,0,0]) F();
        
        
        
