import java.util.Collections;
import java.util.Comparator;

PImage image;
int contrastval = 0;
float r, g, b, brightvalue=1;

void setup() {
  size (208,278);
  image=loadImage("PCMLab9.png");
  image(image, 0, 0);
}

 
void draw(){
}


void keyPressed(){
  if (key == 'p') {
    pixelize(5);
  } 
  if (key == 'c') {
    contrast(contrastval);
    contrastval = 0;
  } 
   if(key == 'x')
  {
    contrastval -= 1;
    System.out.println(contrastval);
  }
  if(key == 'v')
  {
    contrastval += 1;
    System.out.println(contrastval);
  }
  if (key == 'n') {
    bright(brightvalue);
    brightvalue = 1;
  } 
   if(key == 'b')
  {
    brightvalue -= 0.25;
    System.out.println(brightvalue);
  }
  if(key == 'm')
  {
    brightvalue += 0.25;
    System.out.println(brightvalue);
  }
  if(key == '1') {
    reset();
  }
}


void pixelize(int size){
  // use ratio of height/width...
  float ratio;
  if (width < height) {
    ratio = height/width;
  }
  else {
    ratio = width/height;
  }
  
  // ... to set pixel height
  int pxH = int(size * ratio);
  
  noStroke();
  
  for ( int i=0; i<width; i+=size){
    for ( int j=0; j<height; j+=pxH){
     PVector c = getColours(i,j, size, pxH);
     //color c= image.get(i,j);
     fill(c.x, c.y, c.z);
     System.out.println(c);
     rect(i, j, size, pxH);
    }
  }
}


PVector getColours(int currenti, int currentj, float sizeW, float sizeH){
  PVector finalColor = new PVector();
  PVector c = new PVector();
  int times = 0;
  colorMode(RGB, 255);
  for ( int i=currenti; i<currenti + sizeW; i+=1 ){
      for ( int j=currentj; j<currentj + sizeH; j+=1){
           c.x = red(image.get(i,j));
           c.y = green(image.get(i,j));
           c.z = blue(image.get(i,j));
           finalColor = finalColor.add(c);
           times += 1;
        }
  }
  finalColor.x /= times;
  finalColor.y /= times;
  finalColor.z /= times;
  return finalColor;
}


void contrast(float value){
  loadPixels();
  
  int loc;
  
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      loc = x + y*width;
      
      r = red(pixels[loc]);
      g = green(pixels[loc]);
      b = blue(pixels[loc]);
      
      float factor = 259*(value + 255)/(255*(259 - value));
      
      r = (int)(factor*(r - 127) + 127);
      g = (int)(factor*(g - 127) + 127);
      b = (int)(factor*(b - 127) + 127);

      // Set the display pixel to the image pixel
      pixels[loc] = color(r, g, b); 
    }
  }
  updatePixels();
}


void bright(float brightvalue){
  reset();
  loadPixels();
  int loc;
  
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      loc = x + y*width;

      r = red(pixels[loc]);
      g = green(pixels[loc]);
      b = blue(pixels[loc]);
      
      // Apply brightness change
      r *= brightvalue;
      g *= brightvalue;
      b *= brightvalue;
      
      // Constrain RGB
      r = constrain(r, 0, 255);
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);
      
      // Set the display pixel to the image pixel
      pixels[loc] = color(r, g, b);
      }
  }
  updatePixels(); 
}


void reset(){
  clear();
  setup();
}
