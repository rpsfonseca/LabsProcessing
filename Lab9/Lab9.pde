import java.util.Collections;
import java.util.Comparator;

PImage image;
int contrastval = 0;
float r, g, b, brightvalue=1;
float hue;
boolean animate = false;
int pixi, pixj;
ArrayList<ArrayList<PVector>> hist = new ArrayList<ArrayList<PVector>>(256);
int histMax = 0;

int widthCounter = 0;

void setup() {
  size (208,278);
  image=loadImage("PCMLab9.png");
  image(image, 0, 0);
  
  
  colorMode(HSB, 255);
  color c = color(100, 255, 255);
  hue = hue(c);
  colorMode(RGB, 255);
  for(int i = 0; i < 256; i++)
  {
    hist.add(i,new ArrayList<PVector>());
  }
}

 
void draw(){
  
  if(animate){
    //animation(25);
    if(widthCounter < image.width)
    {
      
      int indice = int(map(widthCounter, 0, image.width, 0, 255));
      
      // Convert the histogram value to a location between 
      // the bottom and the top of the picture
      int y = int(map(hist.get(indice).size(), 0, histMax, 0, image.height));
      
      for(int j = 0; j < y; j++)
      {
        colorMode(HSB, 360, 100, 100);
        System.out.println(hist.get(indice).get(j));
        stroke(hist.get(indice).get(j).x, hist.get(indice).get(j).y, hist.get(indice).get(j).z);
        point(widthCounter,image.height-j);
      }
      
      
      widthCounter += 2;
    }
    else
    {
       animate = false; 
    }
  }
  
}


void keyPressed(){
  if (key == 'p') {
    pixelize(10);
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
  
  if(key == '2')
  {
    monochrome();
  }
  
  if(key == '1') {
    reset();
  }
  
  if(key == '3')
  {
    lumiHisto();
    
  }
}

void monochrome()
{
  image.resize(width, 0);
  image.filter(GRAY);
  PVector gradient[] = new PVector[256];
 
  colorMode(HSB, 255);
  // Creates a gradient of 255 colors between color1 and color2
  for (int d=0; d < 256; d++) {    
    float ratio= float(d)*0.00392156862745;
    gradient[d] = PVector.lerp(new PVector(hue, 255, 0),new PVector(hue, 255, 255),ratio);
  }
  
  noStroke();
  loadPixels();
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      int loc = x + y*image.width;
 
      // get the brightness
      float br = brightness(image.pixels[loc]);
      int index = int(br);
      PVector aux = gradient[index];
      pixels[loc] = color(aux.x, aux.y, aux.z);
    }
  }
  updatePixels();
  colorMode(RGB, 255);
  pixelize(10);
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
     fill(c.x, c.y, c.z);
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
      if(i <= image.width-1)
      {
        for ( int j=currentj; j<currentj + sizeH; j+=1){
          if (j <= image.height-1)
          {
             c.x = red(get(i,j));
             c.y = green(get(i,j));
             c.z = blue(get(i,j));
             finalColor = finalColor.add(c);
             times += 1;
          }
        }
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

void animation(int size){
  // use ratio of height/width...
  /*float ratio;
  if (width < height) {
    ratio = height/width;
  }
  else {
    ratio = width/height;
  }
  
  //set pixel height
  int pxH = int(size * ratio);
  
  noStroke();
   PVector c = getColours(pixi,pixj, size, pxH);
   //color c= image.get(i,j);
   fill(c.x, c.y, c.z);
   System.out.println(c);
   rect(pixi, pixj, size, pxH);
   pixj+=pxH;
   
   if(pixj >= height){
     pixj=0;
     pixi+=size;
   }
   if(pixi >= width){
     pixj=0;
     pixi=0;
     animate = false;
   }*/
   lumiHisto();
   //animate=false;
}

void lumiHisto(){
  reset();
  //int[] hist = new int[256];
  // Calculate the histogram
  for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        
      r = red(get(x, y));
      g = green(get(x, y));
      b = blue(get(x, y));  
          
      int lumi = int(0.3*r+0.59*g+0.11*b);
      float hue = hue(get(x,y));
      float sat = saturation(get(x,y));
      float bri = brightness(get(x,y));
      PVector pixelColor = new PVector(hue, sat, bri);
      hist.get(lumi).add(pixelColor);
      //hist[lumi]++; 
    }
  }
  for(int i = 0; i < hist.size(); i++)
  {
    if(hist.get(i).size() > histMax) histMax = hist.get(i).size();
  }
  
  System.out.println(histMax);
  animate = true;
  //drawHist(hist); 
}

void drawHist(ArrayList<ArrayList<PVector>> hist){
  
  for (int i = 0; i < image.width; i += 2) {
    int indice = int(map(i, 0, image.width, 0, 255));
    
    // Convert the histogram value to a location between 
    // the bottom and the top of the picture
    int y = int(map(hist.get(indice).size(), 0, histMax, 0, image.height));
    for(int j = 0; j < y; j++)
    {
      colorMode(HSB, 360, 100, 100);
      System.out.println(hist.get(indice).get(j));
      stroke(hist.get(indice).get(j).x, hist.get(indice).get(j).y, hist.get(indice).get(j).z);
      point(i,image.height-j);
    }
  }
}


void reset(){
  clear();
  setup();
}
