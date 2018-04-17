import java.util.Collections;
import java.util.Comparator;

PImage img;
float r, g, b;
float c, m, Y, k;
float [][] C = new float[208][278];
float [][] M = new float[208][278];
float [][] YY = new float[208][278];
float [][] K = new float[208][278];
 
ArrayList<ArrayList<PVector>> hist = new ArrayList<ArrayList<PVector>>(256);


void setup(){
  size(208, 278);
  img = loadImage("PCMLab7.png");
  image(img, 0, 0);
  for(int i = 0; i < 256; i++)
  {
    hist.add(i,new ArrayList<PVector>());
  }
}

void draw(){ 
}

void keyPressed(){
  if (key == 'l') {
    lumiHisto();
  } 
  if(key == 'r') {
    primaryHistoRed();
  }
  if(key == 'g') {
    primaryHistoGreen();
  }
  if(key == 'b') {
    primaryHistoBlue();
  }
  if(key == 'p')
  {
     System.out.println("Converting RGB to CMYK");
     convertRGBtoCMYK2();
     System.out.println("Done converting!"); 
  }
  if(key == 'c') {
    convertHistoCyan();
  }
  if(key == 'm') {
    convertHistoMagenta();
  }
  if(key == 'y') {
    convertHistoYellow();
  }
  if(key == 'k') {
    convertHistoBlack();
  }
  if(key == '1') {
    reset();
  }
}

void lumiHisto(){
  reset();
  
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
    }
  }
  drawHist(hist); 
}

void primaryHistoRed(){
  reset();
  
  for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        
      int indice = int(red(img.get(x, y)));
      float hue = hue(img.get(x, y));
      float sat = saturation(img.get(x, y));
      float bri = brightness(img.get(x, y));
      PVector pixelColor = new PVector(hue, sat, bri);
      hist.get(indice).add(pixelColor);
    }
  }
  drawHist(hist); 
}

void primaryHistoGreen(){
    reset();
    
  for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        
      int indice = int(green(get(x, y)));
      float hue = hue(img.get(x, y));
      float sat = saturation(img.get(x, y));
      float bri = brightness(img.get(x, y));
      PVector pixelColor = new PVector(hue, sat, bri);
      hist.get(indice).add(pixelColor);
    }
  }
  drawHist(hist); 
}

void primaryHistoBlue(){
    reset();
  //int[] hist = new int[256];
// Calculate the histogram
  for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        
      int indice = int(blue(get(x, y)));
      float hue = hue(img.get(x, y));
      float sat = saturation(img.get(x, y));
      float bri = brightness(img.get(x, y));
      PVector pixelColor = new PVector(hue, sat, bri);
      hist.get(indice).add(pixelColor);
    }
  }
  drawHist(hist); 
}

void convertRGBtoCMYK()
{
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      r = red(get(x, y));
      g = green(get(x, y));
      b = blue(get(x, y));
      
      float white = max(r/255,g/255,b/255);
      c = (white - (r/255))/white;
      m = (white - (g/255))/white;
      Y = (white - (b/255))/white;
      k = 1-white;
      
      C[x][y] = c;
      M[x][y] = m;
      YY[x][y] = Y;
      K[x][y] = k;
    }
  }
}

void convertRGBtoCMYK2()
{
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      r = red(get(x, y));
      g = green(get(x, y));
      b = blue(get(x, y));
      c = 1 - (r/255);
      m = 1 - (g/255);
      Y = 1 - (b/255);
      
      k = 1;
      if (c < k) k = c;
      if (m < k) k = m;
      if (Y < k) k = Y;
      
      if (k == 1)
      {
        c = 0;
        m = 0;
        Y = 0;
      }
      else
      {
         c = (c - k)/(1-k);
         m = (m - k)/(1-k);
         Y = (Y - k)/(1-k); 
      }
      
      C[x][y] = c;
      M[x][y] = m;
      YY[x][y] = Y;
      K[x][y] = k;
    }
  }
}

void convertHistoCyan(){
  reset();
  
  // Calculate the histogram
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int indice = int(C[x][y] * 100);
      float hue = hue(img.get(x, y));
      float sat = saturation(img.get(x, y));
      float bri = brightness(img.get(x, y));
      PVector pixelColor = new PVector(hue, sat, bri);
      hist.get(indice).add(pixelColor);
    }
  }
  drawHist2(hist); 
}

void convertHistoMagenta(){
  reset();
  
  // Calculate the histogram
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int indice = int(M[x][y] * 100);
      float hue = hue(img.get(x, y));
      float sat = saturation(img.get(x, y));
      float bri = brightness(img.get(x, y));
      PVector pixelColor = new PVector(hue, sat, bri);
      hist.get(indice).add(pixelColor);
    }
  }
  drawHist2(hist); 
}

void convertHistoYellow(){
  reset();
  
  // Calculate the histogram
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int indice = int(YY[x][y] * 100);
      float hue = hue(img.get(x, y));
      float sat = saturation(img.get(x, y));
      float bri = brightness(img.get(x, y));
      PVector pixelColor = new PVector(hue, sat, bri);
      hist.get(indice).add(pixelColor);
    }
  }
  drawHist2(hist); 
}

void convertHistoBlack()
{
  reset();
  
  // Calculate the histogram
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int indice = int(K[x][y] * 100);
      float hue = hue(img.get(x, y));
      float sat = saturation(img.get(x, y));
      float bri = brightness(img.get(x, y));
      PVector pixelColor = new PVector(hue, sat, bri);
      hist.get(indice).add(pixelColor);
    }
  }
  drawHist2(hist); 
}

void drawHist(ArrayList<ArrayList<PVector>> hist){
  for(int i = 0; i < hist.size(); i++)
  {
    Collections.sort(hist.get(i), new Comparator<PVector>() {
      public int compare(PVector o1, PVector o2) {
          return Float.compare(o1.x, o2.x);
      }
    });
  }
  
  int histMax = 0;
  for(int i = 0; i < hist.size(); i++)
  {
    if(hist.get(i).size() > histMax) histMax = hist.get(i).size();
  }
  
  for (int i = 0; i < img.width; i += 2) {
    // Map i (from 0..img.width) to a location in the histogram (0..255)
    int indice = int(map(i, 0, img.width, 0, 255));
    
    // Convert the histogram value to a location between 
    // the bottom and the top of the picture
    int y = int(map(hist.get(indice).size(), 0, histMax, 0, img.height));
    for(int j = 0; j < y; j++)
    {
      colorMode(HSB, 360, 100, 100);
      System.out.println(hist.get(indice).get(j));
      stroke(hist.get(indice).get(j).x, hist.get(indice).get(j).y, hist.get(indice).get(j).z);
      point(i,img.height-j);
    }
  }
}

void drawHist2(ArrayList<ArrayList<PVector>> hist){
  for(int i = 0; i < hist.size(); i++)
  {
    Collections.sort(hist.get(i), new Comparator<PVector>() {
      public int compare(PVector o1, PVector o2) {
          return Float.compare(o1.x, o2.x);
      }
    });
  }
  
  int histMax = 0;
  for(int i = 0; i < hist.size(); i++)
  {
    if(hist.get(i).size() > histMax) histMax = hist.get(i).size();
  }
  
  for (int i = 0; i < img.width; i += 2) {
    // Map i (from 0..img.width) to a location in the histogram (0..255)
    int indice = int(map(i, 0, img.width, 0, 101));
    
    // Convert the histogram value to a location between 
    // the bottom and the top of the picture
    int y = int(map(hist.get(indice).size(), 0, histMax, 0, img.height));
    for(int j = 0; j < y; j++)
    {
      colorMode(HSB, 360, 100, 100);
      System.out.println(hist.get(indice).get(j));
      stroke(hist.get(indice).get(j).x, hist.get(indice).get(j).y, hist.get(indice).get(j).z);
      point(i,img.height-j);
    }
  } 
}

void reset(){
  colorMode(RGB, 255, 255, 255);
  for(int i = 0; i < hist.size(); i++)
  {
    hist.get(i).clear();
  }
  clear();
  setup();
}
