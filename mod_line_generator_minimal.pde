// MOD. line generator - a minimal version to test vsync problems
// Written by @xiq

color MODLightPurple = color(187,41,187);
color MODVideoPurple = color(107,17,109);
color Black = color(0,0,0);

/* things that need to be smoothly variable:
  line speed (including stationary), direction

  things that need to be variable (but not smoothly)
  line orientation
*/

// can't change this smoothly if the displays have to wrap
int verticalLineCount = 10;
float linePercentage = 50.0;

// how many screens (or what portion of the screen) is traversed in a second
float lineRate = 0.2; // screens/sec

boolean isHorizontal = true;

float HORIZ = 1.0;
float VERT  = 0.0;
float STOPPED = 0.0;

int displayId = 1;

// { dur, rate, perc, vlc, horiz }
float[][] sequence = {
  // first duration is treated as 0.0 regardless of value
  // positive is left-to-right movement
  
  {            0,    secsPerWidth(5),  50.0, 10.0, VERT},
//{ minSec(1,15),    secsPerWidth(5),  50.0, 10.0, VERT},
  {  minSec(0,5),    secsPerWidth(5),  50.0, 10.0, VERT},
  {            0,   secsPerWidth(-5),  50.0, 10.0, VERT},
  {      secs(9), secsPerWidth(-2.5),  50.0, 10.0, VERT},
  {      secs(4),            STOPPED,  50.0, 10.0, VERT},
  {            0,    secsPerWidth(5),  50.0, 10.0, VERT},
//{     secs(10),  secsPerWidth(2.5),  50.0, 10.0, VERT},
  {      secs(1),  secsPerWidth(2.5),  50.0, 10.0, VERT},
  {      secs(4),            STOPPED,  50.0, 10.0, VERT},
  {            0,    secsPerWidth(5),  50.0, 10.0, VERT},
//{     secs(30),    secsPerWidth(5),  50.0, 10.0, VERT},
  {      secs(3),    secsPerWidth(5),  50.0, 10.0, VERT},
  {            0,   secsPerWidth(15),  50.0, 10.0, VERT},
//{     secs(30),   secsPerWidth(15),  50.0, 10.0, VERT},
  {      secs(3),   secsPerWidth(15),  50.0, 10.0, VERT},
  {            0,  secsPerWidth(2.5),  50.0, 10.0, VERT},
//{     secs(30),  secsPerWidth(2.5),  50.0, 10.0, VERT},
  {      secs(3),  secsPerWidth(2.5),  50.0, 10.0, VERT},
  {            0, secsPerWidth(-2.5),  50.0, 10.0, VERT},
//{     secs(30), secsPerWidth(-2.5),  50.0, 10.0, VERT},
  {      secs(3), secsPerWidth(-2.5),  50.0, 10.0, VERT},  
};

float[][] sequenceRight = {
  {            0,   secsPerWidth(15),  50.0, 10.0, VERT},
  {     secs(30),   secsPerWidth(15),  50.0, 10.0, VERT},
  {            0,   secsPerWidth(-5),  50.0, 10.0, VERT},
  {     secs(30),   secsPerWidth(-5),  50.0, 10.0, VERT},
  {            0,    secsPerWidth(5),  50.0, 10.0, VERT},
  {     secs(30),    secsPerWidth(5),  50.0, 10.0, VERT},
  {            0,  secsPerWidth(-15),  50.0, 10.0, VERT},  
  {     secs(35),  secsPerWidth(-15),  50.0, 10.0, VERT},
  {            0,   secsPerWidth(-5),  50.0, 10.0, VERT},
  {     secs(30),   secsPerWidth(-5),  50.0, 10.0, VERT},
  {            0,    secsPerWidth(5),  50.0, 10.0, VERT},
  {      secs(9),  secsPerWidth(2.5),  50.0, 10.0, VERT},
  {      secs(4),            STOPPED,  50.0, 10.0, VERT},
  {            0,    secsPerWidth(5),  50.0, 10.0, VERT},
  {     secs(10),  secsPerWidth(2.5),  50.0, 10.0, VERT},
  {      secs(4),            STOPPED,  50.0, 10.0, VERT},
  {            0,  secsPerHeight(10),  50.0, 10.0, HORIZ},
  {     secs(30),  secsPerHeight(10),  50.0, 10.0, HORIZ},
  {            0,  secsPerHeight(-5),  50.0, 10.0, HORIZ},
  {     secs(30),  secsPerHeight(-5),  50.0, 10.0, HORIZ},
  {            0,   secsPerHeight(5),  50.0, 10.0, HORIZ},
  { minSec(1,20),   secsPerHeight(5),  50.0, 10.0, HORIZ},   
};

int updatesPerSecond = 120;

int lastFrameTime = 0;

float linePhase = 0.0;

long startTime = 0;

float minSec(float m, float s) {
  return secs(m*60+s);
}

float secs(float s) {
  return s*1000.0;
}

float secsPerWidth(float s) {
  return 1.0/s;
}

float secsPerHeight(float s) {
  // assuming 1280x800
  return 0.625/s;  
}

float[] getSequence(float millis) {
  // { dur, rate, perc, vlc, horiz }
  float[] res = { 0.0, 0.0, 50.0, 10.0, 1.0 };
  while (millis>0.0) {
    for ( int i = 0; i < sequence.length; i++ ) {
      //System.arraycopy(event,0,res,0,res.length);
      float dur = sequence[i][0];
      if (dur<millis || i==0) {
        millis-=dur;
      } else {
        float[] start = sequence[i-1];
        float[] end = sequence[i];
        if (end[0]==0.0) {
          System.arraycopy(end,0,res,0,end.length);
        } else {
          float phase = millis / end[0];
          for ( int j = 0; j<start.length; j++) {
            res[j] = lerp(start[j],end[j],phase);
          }
        }
        return res;
      }
    }
  }
  // milis went negative?? shouldn't happen but just return res
  return res;
}

void parseArgs() {
  // test some args
  args = new String[] { "--right" };
  if (args != null) {
    for (int i = 0; i<args.length; i++) {
      switch (args[i]) {
        case "--right": 
          // all the code for switching from left to right mode is here
          // maybe not a great idea
          displayId = 2;
          sequence = sequenceRight;
          break;
          
        case "-d":
        case "--display":
          try {
            displayId = Integer.parseInt(args[++i]);
          } catch (Exception e) {
            println("ERROR: missing arg for -d or --display");
          }
          break;
          
        case "-s":
        case "--start":
          try {
            startTime = Long.parseLong(args[++i]);
          } catch (Exception e) {
            println("ERROR: missing arg for -s or --startTime");
          }
          break;
        
        case "-h":
        case "--help":
          println("--right        run right side display");
          println("--display <n>  override display id");
          break;
      }
    }
  }
}

void setup() {
  parseArgs();
  
  if (startTime==0) {
    startTime = System.currentTimeMillis();
  }
  
  // in the VM i need to use the default renderer
  //fullScreen(displayId);
  // but on my laptop it only looks buttery with P3D
  fullScreen(P3D, displayId);
  //we try to render faster than the monitor refresh rate in the hope that vsync will slow us down
  //we might drop frames if we try to anticipate the monitor refresh rate
  frameRate(100);
  noCursor();
  
  // just debugging
  println(System.currentTimeMillis());
}

void update(int frameTime) {
  int maxUpdatePeriod = 1000/updatesPerSecond;

  while(frameTime>maxUpdatePeriod) {
    update(maxUpdatePeriod);
    frameTime-=maxUpdatePeriod;
  }
  
  //float[] event = getSequence(millis());
  float[] event = getSequence(System.currentTimeMillis()-startTime);
  // { dur, rate, perc, vlc, horiz }
  lineRate = event[1];
  linePercentage = event[2];
  verticalLineCount = (int)event[3];
  isHorizontal = event[4]==0.0;
  
  //print("lineRate "); println(lineRate);
  //print("isHorizontal "); println(isHorizontal);
  //print("verticalLineCount "); println(verticalLineCount);
  //print("linePercentage "); println(linePercentage);
  
  // lineRate is secs/screen
  // lineRate/verticalLineCount is secs/line
  // verticalLineCount/lineRate is lines/sec
  
  // lineRate is screens/sec
  // lineRate*verticalLineCount is lines/sec
  
  if (lineRate!=0.0) {
    linePhase = linePhase + ((verticalLineCount*lineRate) * (frameTime/1000.0));
  }
  
  linePhase%=1.0;
  
}

void draw() {
  int now = millis();
 
  int frameTime = now-lastFrameTime;

  update(frameTime);

  int linePitch = width/verticalLineCount;
  float lineWidth = linePitch * linePercentage/100.0;

  background(Black);
  
  fill(MODVideoPurple);
  noStroke();
  
  
  float x = linePhase * linePitch - lineWidth;
  if (isHorizontal) {
    for(float xn = x; xn < width; xn+=linePitch) {
        rect(xn,0,lineWidth,height);
    }
  } else {
    for(float yn = x; yn < height; yn+=linePitch) {
        rect(0,yn,width,lineWidth);
    }
  }
  
  
  
  lastFrameTime = now;
}