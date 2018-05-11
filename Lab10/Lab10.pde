import processing.video.*;
Movie myMovie;
float lastTime = 0.0;
int currentImgCount = 1;
float sampleRate = 3.0;

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
  
  currentExercise = Exercise.EXERCISE1;
  
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
