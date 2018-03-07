// MOD. line generator - a minimal version to test vsync problems
// Written by @xiq

color MODLightPurple = color(187,41,187);
color Black = color(0,0,0);

void setup() {
  //size(1920,1080,P3D);
  fullScreen(P2D);
  frameRate(120);
  noCursor();
}

void draw() {
  int now = millis();
  
  background(Black);
  
  fill(MODLightPurple);
  noStroke();
  
  int period = 2000; // 2 seconds
  float phase = (now % period) / (period-1.0);
  
  float rectWidth = width/10.0;
  
  float pitch = rectWidth*2;
  
  float x = phase * pitch - rectWidth;
  
  for(float xn = x; xn < width; xn+=pitch) {
      rect(xn,0,rectWidth,height);
  }
  
  println(frameRate);
}