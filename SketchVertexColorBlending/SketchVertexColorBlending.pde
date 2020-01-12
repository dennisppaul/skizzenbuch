void setup()  { 
  size(1024, 768, P3D); 
  noStroke(); 
  colorMode(HSB, 1); 
} 
 
void draw()  { 
  background(0.2);
  
  pushMatrix(); 
  translate(width/2, height/2, 0); 
    
  scale(90);
  beginShape(QUADS);
  fill(sin(atan2(mouseY-height/2, mouseX-width/2)) * 0.5 + 0.5, 1, 1); vertex(-1,  1);
  fill(0.0, 1, 1); vertex( 1,  1);
  fill(0.33, 1, 1); vertex( 1, -1);
  fill(0.66, 1, 1); vertex(-1, -1);
  endShape();
  
  popMatrix(); 
} 
