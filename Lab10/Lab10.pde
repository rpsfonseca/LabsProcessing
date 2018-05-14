import processing.video.*;
Movie myMovie;
float lastTime = 0.0;
int currentImgCount = 1;
float sampleRate = 3.0;
int[] hist1 = new int[256];
int[] hist2 = new int[256];
int[] hist3 = new int[256];

PrintWriter output;

enum Exercise
{
  EXERCISE1,
  EXERCISE2,
  EXERCISE3,
  EXERCISE4
}

Exercise currentExercise;

void setup() {
  size(960, 540);
  background(0);
  myMovie = new Movie(this, "PCMLab10.mov");
  myMovie.play();
  
  hist1 = getHisto(myMovie.get());
  currentExercise = Exercise.EXERCISE2;
  
  // Create a new file in the sketch directory
  output = createWriter("time_indexes.txt"); 
}

void draw()
{
  image(myMovie, 0, 0);
}

// Called every time a new frame is available to read
void movieEvent(Movie m)
{
  m.read();
  
  switch(currentExercise)
  {
    case EXERCISE1:
      stroboscopic();
      break;
    case EXERCISE2:
      transition();
      break; 
    case EXERCISE3:
      transition();
      break; 
     
    default:
      break;
  }
}

void keyPressed()
{
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  exit(); // Stops the program
}

void reset(){
  clear();
  setup();
}

void stroboscopic()
{
  if(myMovie.time() - lastTime >= sampleRate)
  {
    lastTime = myMovie.time();
    PImage newImage = createImage(960, 540, RGB);
    newImage = myMovie.get();
    String frameName = "outputImage_"+ currentImgCount++ +".jpg";
    newImage.save(frameName);
    output.println(frameName + " -> " + lastTime);
  }
}

void transition()
{
  if(myMovie.time() - lastTime >= sampleRate)
  {
    lastTime = myMovie.time();
    PImage newImage = createImage(960, 540, RGB);
    newImage = myMovie.get();
    
    hist2 = getHisto(newImage);    
    
    if(histoDifference(hist1, hist2, 50)){
      String frameName = "outputImage_"+ currentImgCount++ +".jpg";
      newImage.save(frameName);
      output.println(frameName + " -> " + lastTime);
    }
    
    hist1 = hist2; //Update Histograms
  }
}

void transition2()
{
  if(myMovie.time() - lastTime >= sampleRate)
  {
    lastTime = myMovie.time();
    PImage newImage = createImage(960, 540, RGB);
    newImage = myMovie.get();
    
    hist2 = getHisto(newImage);    
    
    twinComparison(hist1, hist2);
    
    hist1 = hist2; //Update Histograms
  }
}

int[] getHisto(PImage img){
  int[] hist = new int[256];
  
  // Calculate the histogram
  for (int i = 0; i < img.width; i++) {
    for (int j = 0; j < img.height; j++) {
      int bright = int(brightness(get(i, j)));
      hist[bright]++; 
    }
  }
  return hist;
}

boolean histoDifference(int[] histA, int[] histB, int threshold){
  
  int totalDif = 0;
  
  for(int i=0;i<256;i++){
    hist3[i] = histB[i] - histA[i];
    totalDif += hist3[i];  
  }
  
  if(totalDif > threshold) return true;
  else return false;
}

void twinComparison(int[] histA, int[] histB){
  //TODO
}
