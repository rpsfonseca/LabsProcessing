PImage original, processed;
int loc, grey;
float r, g, b, d, adjustbrightness, maxdist = 50;;
int contrast = 0;
boolean specialEffects = false;
int [][] matrix = {{1, 2, 1},{2, 4, 2},{1, 2, 1}};

void setup(){ //<>//
  original = loadImage("PCMLab6.png");
  //size(208, 278);
  //background(original);
  
  noLoop();
  surface.setSize(original.width, original.height);
}

void draw(){
  if(specialEffects){
    loadPixels();
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        loc = x + y*width;

        r = red(original.pixels[loc]);
        g = green(original.pixels[loc]);
        b = blue(original.pixels[loc]);
        
        // Calculate brightness based on proximity to the mouse
        d = dist(x, y, mouseX, mouseY);
        adjustbrightness = (maxdist-d)/maxdist;
        r *= adjustbrightness;
        g *= adjustbrightness;
        b *= adjustbrightness;
        
        // Constrain RGB
        r = constrain(r, 0, 255);
        g = constrain(g, 0, 255);
        b = constrain(b, 0, 255);
        
        // Set the display pixel to the image pixel
        pixels[loc] = color(r, g, b);
        }
    }
    updatePixels();
    loop(); 
  }else{
    image(original, 0, 0);
    noLoop();
  }
}



void keyPressed(){
  if (key == '1' && !specialEffects) {
    greyscale();
  } 
  if(key == '2' && !specialEffects) {
     //float contrast = 5f * ( mouseX / (float)width); 
    contrast(contrast);
    contrast = 0;
  }
  if(key == '3' && !specialEffects) {
    segment(160);
  }
  if(key == '4' && !specialEffects) {
    specialEffects=true;
    draw();
  }
  if(key == '5') {
    reset();
    specialEffects=false;
  }
  
  if(key == '6') {
    gaussianBlur();
  }
  if(key == 'o')
  {
    /*if(contrast > -100)
    {
      contrast -= 1;
    }*/
    
      contrast -= 1;
    System.out.println(contrast);
  }
  if(key == 'p')
  {
    /*if(contrast < 100)
    {
      contrast += 1;
    }*/
     contrast += 1;
    System.out.println(contrast);
  }
}

color convulotion(int x, int y, int[][] matrix, int m)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = m / 2;
  // Loop through convolution matrix
  for (int i = 0; i < m; i++){
    for (int j= 0; j < m; j++){
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + original.width*yloc;
      // Make sure we have not walked off the edge of the pixel array
      loc = constrain(loc,0,original.pixels.length-1);
      // Calculate the convolution
      // We sum all the neighboring pixels multiplied by the values in the convolution matrix.
      rtotal += (red(original.pixels[loc]) * matrix[i][j]);
      gtotal += (green(original.pixels[loc]) * matrix[i][j]);
      btotal += (blue(original.pixels[loc]) * matrix[i][j]);
    }
  }
  
  rtotal /= 16;
  gtotal /= 16;
  btotal /= 16;
  
  // Make sure RGB is within range
  rtotal = constrain(rtotal,0,255);
  gtotal = constrain(gtotal,0,255);
  btotal = constrain(btotal,0,255);
  // Return the resulting color
  return color(rtotal,gtotal,btotal);
}

void gaussianBlur()
{
  loadPixels();
  
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
 
      loc = x + y*width;
      
      pixels[loc] = convulotion(x,y,matrix,3);
    }
  }
  updatePixels();
}

void greyscale(){  
  loadPixels();
  
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      loc = x + y*width;
      
      r = red(original.pixels[loc]);
      g = green(original.pixels[loc]);
      b = blue(original.pixels[loc]);
      
      // Image Processing
      grey = (int)(0.3*r+0.59*g+0.11*b);

      // Set the display pixel to the image pixel
      pixels[loc] = color(grey, grey, grey); 
    }
  }
  updatePixels();
}



void contrast(float value){
  loadPixels();
  
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      loc = x + y*width;
      
      r = red(original.pixels[loc]);
      g = green(original.pixels[loc]);
      b = blue(original.pixels[loc]);
      
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



void segment(int threshold){
  loadPixels();
  
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      loc = x + y*width;
      
      // Test the brightness against the threshold
      if (brightness(original.pixels[loc]) > threshold) {
        pixels[loc] = color(255);  // White
      }  else {
        pixels[loc]  = color(0);  // Black
      }
    }
  }
  updatePixels();
}


void effect(){
  //TODO
}

void reset(){
  loadPixels();
  
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      loc = x + y*width;

      pixels[loc] = original.pixels[loc];
    }
  }
  updatePixels();
}
