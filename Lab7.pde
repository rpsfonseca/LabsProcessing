PImage img;
float r, g, b;
float c, m, Y, k;
float [][] C = new float[208][278];
float [][] M = new float[208][278];
float [][] YY = new float[208][278];
float [][] K = new float[208][278];

ArrayList<ArrayList<Float>> hist = new ArrayList<ArrayList<Float>>(256);


void setup(){
  size(208, 278);
  img = loadImage("PCMLab7.png");
  image(img, 0, 0);
  for(int i = 0; i < 256; i++)
  {
    hist.add(i,new ArrayList<Float>());
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
  //int[] hist = new int[256];
  // Calculate the histogram
  for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        
      r = red(get(x, y));
      g = green(get(x, y));
      b = blue(get(x, y));  
          
      int lumi = int(0.3*r+0.59*g+0.11*b);
      hist.get(lumi).add(hue(get(x,y)));
      //hist[lumi]++; 
    }
  }
  drawHist(hist); 
}

void primaryHistoRed(){
  reset();
  //int[] hist = new int[256];
// Calculate the histogram
  for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        
      int indice = int(red(get(x, y)));
      hist.get(indice).add(hue(get(x,y)));
      //hist[indice]++; 
    }
  }
  drawHist(hist); 
}

void primaryHistoGreen(){
    reset();
  //int[] hist = new int[256];
// Calculate the histogram
  for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        
      int indice = int(green(get(x, y)));
      hist.get(indice).add(hue(get(x,y)));
      //hist[indice]++; 
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
      hist.get(indice).add(hue(get(x,y)));
      //hist[indice]++; 
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
  int[] hist = new int[101];
  // Calculate the histogram
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int indice = int(C[x][y] * 100);
      hist[indice]++;
    }
  }
  drawHist2(hist); 
}

void convertHistoMagenta(){
  reset();
  int[] hist = new int[101];
  // Calculate the histogram
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int indice = int(M[x][y] * 100);
      hist[indice]++;
    }
  }
  drawHist2(hist); 
}

void convertHistoYellow(){
  reset();
  int[] hist = new int[101];
  // Calculate the histogram
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int indice = int(YY[x][y] * 100);
      hist[indice]++;
    }
  }
  drawHist2(hist); 
}

void convertHistoBlack()
{
  reset();
  int[] hist = new int[101];
  // Calculate the histogram
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int indice = int(K[x][y] * 100);
      hist[indice]++;
    }
  }
  drawHist2(hist); 
}

void drawHist(ArrayList<ArrayList<Float>> hist){
  // Find the largest value in the histogram
  /*int histMax = max(hist);
  
  stroke(255); //White color for histogram bars
  // Draw half of the histogram (skip every second value)
  for (int i = 0; i < img.width; i += 2) {
    // Map i (from 0..img.width) to a location in the histogram (0..255)
    int indice = int(map(i, 0, img.width, 0, 255));
    
    // Convert the histogram value to a location between 
    // the bottom and the top of the picture
    int y = int(map(hist[indice], 0, histMax, img.height, 0));
    line(i, img.height, i, y);
  } */
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
      stroke(hist.get(indice).get(j));
      line(i, img.height, i, j);
    }
  }
}

void drawHist2(int hist[]){
  // Find the largest value in the histogram
  int histMax = max(hist);
  
  stroke(255); //White color for histogram bars
  // Draw half of the histogram (skip every second value)
  for (int i = 0; i < img.width; i += 2) {
    // Map i (from 0..img.width) to a location in the histogram (0..255)
    int indice = int(map(i, 0, img.width, 0, 101));
    
    // Convert the histogram value to a location between 
    // the bottom and the top of the picture
    int y = int(map(hist[indice], 0, histMax, img.height, 0));
    line(i, img.height, i, y);
  } 
}

void reset(){
  clear();
  setup();
}
