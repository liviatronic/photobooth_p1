import processing.video.*;
import com.hamoid.*;

//variables for webcam, movie, video export, video buffer
Capture cam;
Movie mov;
VideoExport videoExport;
PGraphics pg;

//variables for timer
int newFrame = 0;
int savedTime;
int totalTime = 6000;

//variables for counter
int currentCycle;
int lastCycle;


void setup() {
  size(640, 480);
  frameRate(30);
  
  //start the counter
  currentCycle = 1;
  
  //init function starts the sketch
  init();
}



void draw() {
  
  //start drawing PGraphics for the video
  pg.beginDraw();
  //set PGraphics background to transparent
  pg.background(255, 0);
  
  //wait until webcam and loaded movie are available before doing anything
  if (cam.available()) {
    cam.read();
      if (mov.available()) {
        mov.read();

      mov.loadPixels();
      
      //set up timer
      int passedTime = millis() - savedTime;
      
      // Loops through every pixel of the recorded video...
      for (int x = 0; x < mov.width; x++) {
        for (int y = 0; y < mov.height; y++) {
    
          // Calculate the 1D location from a 2D grid
          int loc = x + y*mov.width;
    
          // Get the R,G,B,A values from image
          float r, g, b, a;
          r = red  (mov.pixels[loc]);
          g = green(mov.pixels[loc]);
          b = blue (mov.pixels[loc]);
          a = alpha (mov.pixels[loc]);
    
          // Calculate an amount to change brightness based on mouseX position
          float adjustbrightness = map(mouseX, 0, width, 0, 4);
          r *= adjustbrightness;
          g *= adjustbrightness;
          b *= adjustbrightness;
          a *= adjustbrightness;
    
          // Constrain RGBA to make sure they are within 0-255 color range
          r = constrain(r, 0, 255);
          g = constrain(g, 0, 255);
          b = constrain(b, 0, 255);
          a = constrain(a, 0, 255);
    
          // Make a new color and set pixel in the window
          color c = color(r, g, b, a);
          mov.pixels[loc] = c;
        }
      }
      updatePixels();
      
      //draw the movie into the PGraphics variable
      pg.image(mov, 0, 0, width, height);
      pg.endDraw();
    
      //Draw the camera image MIRRORED
      pushMatrix();
      scale(-1.0, 1.0);
      image(cam,-cam.width,0);
      popMatrix();
      
      blend(mov, 0, 0, width, height, 0, 0, width, height, DARKEST);
      
      //save a frame for the video export
      videoExport.saveFrame();
      
      //if the timer is up, export the movie
      if (passedTime > totalTime) {
        export();
      }
  
    } 
  }
}

void init() {
  
  //update the counter
  currentCycle++;
  lastCycle = currentCycle - 1;

  //variable for timer
  savedTime = millis();
  
  //initialize VideoExport object
  videoExport = new VideoExport(this);
  videoExport.setMovieFileName("./data/vid" + currentCycle + ".mp4");
  videoExport.setFfmpegPath("/usr/local/bin/ffmpeg");
  //videoExport.setFfmpegPath("/Users/liviafoldes/Documents/projects/gray area/Processing/sketches/photo booth/photobooth_p1/data");
  videoExport.startMovie();

  //initialize Capture object
  cam = new Capture(this, width, height, "HD Pro Webcam C920", 30); 
  cam.start();
  
  //load the video from the previous cycle
  mov = new Movie(this, "vid" + lastCycle + ".mp4");
  mov.loop();
  
  //initialize PGraphics
  pg = createGraphics(width, height);
  
  //make the pixel array available for manipulation
  loadPixels();
}



void export() {  
    videoExport.endMovie();
    init();
    //background(255);
}

//void keyPressed() {
//  if (key == 'q') {
//    init();
//  }
//}
