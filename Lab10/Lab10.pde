import processing.video.*;
Movie myMovie;
float lastTime = 0.0;
int currentImgCount = 1;
float sampleRate = 3.0;
int threshold = 500000;
int[] hist1 = new int[256];
int[] hist2 = new int[256];


boolean inSmooth = false;
float cummulativeDifference = 0;

int[] framesHistoDif = new int[1000];

int j = 0;

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
  currentExercise = Exercise.EXERCISE3;
  
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
      transition(threshold); // 900000
      break; 
    case EXERCISE3:
      transition2();
      break;
    case EXERCISE4:
      break;
    default:
      break;
  }
}

void keyPressed()
{
  createList();
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file  
  exit(); // Stops the program
}

void reset()
{
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

void transition(float threshold)
{
  PImage newImage = createImage(960, 540, RGB);
  newImage = myMovie.get();
  
  hist2 = getHisto(newImage);    
  
  if(histoDifference(hist1, hist2, threshold, 1))
  {
    lastTime = myMovie.time();
    outputSaving(newImage);
  }
  
  hist1 = hist2; //Update Histograms
}

void transition2()
{
    lastTime = myMovie.time();
    PImage newImage = createImage(960, 540, RGB);
    newImage = myMovie.get();
    
    hist2 = getHisto(newImage);    
    
    twinComparison(hist1, hist2, 10000, threshold);
    
    hist1 = hist2; //Update Histograms
}

int[] getHisto(PImage img){
  int[] hist = new int[256];
  
  // Calculate the histogram
  for (int i = 0; i < img.width; i++) {
    for (int j = 0; j < img.height; j++) {
      int bright = int(brightness(img.get(i, j)));
      hist[bright]++; 
    }
  }
  return hist;
}

boolean histoDifference(int[] histA, int[] histB, float threshold, int method)
{  
  float sumA = 0;
  float sumB = 0;
  double totalDif = 0;
  
  for(int i=0;i<256;i++)
  {
    switch(method)
    {
      case 0:
        totalDif += Math.abs(histA[i] - histB[i]);
        break;
      case 1:
        if(histA[i] != 0)
        {
          totalDif += chiSquared(histA[i], histB[i]);
        }
        //System.out.println("A: " + histA[i] + " || B: " + histB[i]);
        break;
      case 2:
        totalDif += intersection(histA[i], histB[i]);
        break;
    }
  }
  
  //Save histogram difference
  framesHistoDif[j] = totalDif;
  j++;
  
  System.out.println(totalDif);
  if(method == 2)
  {
    if(totalDif < threshold) return true;
    else return false;
  }
  
  if(totalDif > threshold)
  {
    
    return true;
  }
  else return false;
}

void twinComparison(int[] histA, int[] histB, float lowerThres, float higherThres)
{
  if(!inSmooth && histoDifference(histA, histB, higherThres, 1))
  {
    return;
  }
  
  float diff = cummulativeDiff(histA, histB, lowerThres);
  if(diff != 0.0f)
  {
    inSmooth = true;
    cummulativeDifference += diff;
  }
  else
  {
    System.out.println(cummulativeDifference);
    if(cummulativeDifference > higherThres)
    {
      PImage newImage = createImage(960, 540, RGB);
      newImage = myMovie.get();
      outputSaving(newImage); 
    }
    inSmooth = false;
    cummulativeDifference = 0.0f;
  }
}

float cummulativeDiff(int[] histA, int[] histB, float threshold)
{
  float totalDif = 0;
  
  for(int i=0;i<256;i++)
  {
    if(histA[i] != 0.0f)
    {
      totalDif += chiSquared(histA[i], histB[i]);
    }
       
  }
  System.out.println(totalDif);
  
  if(totalDif > threshold) return totalDif;
  else return 0.0f;
}

float chiSquared(float valA, float valB)
{
  return (valA-valB)*(valA-valB)/valA;
}

<<<<<<< HEAD
float intersection(float valA, float valB)
{
  return min(valA, valB);
}

void outputSaving(PImage image)
{
  String frameName = "outputImage_"+ currentImgCount++ +".jpg";
  image.save(frameName);
  output.println(frameName + " -> " + lastTime);
=======
void createList(){
  output = createWriter("histo_differences.txt"); 
  
  output.println("Frame   Histogram_Diff   Threshold1   Threshold2");
  
  for(int i = 0; i<515; i++){
       output.println(i + "   " + framesHistoDif[i]);
       System.out.println(i);
        System.out.println(framesHistoDif[i]);
  }
>>>>>>> 8435c5373cb48e64ac1783a3214eeb03219bd3e1
}
