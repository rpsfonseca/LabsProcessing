import processing.video.*;
Movie myMovie, myMovie2;
PImage img, mimg;
PImage mmask;
float threshold = 254;

float fadeDuration = 5.0;

int currentAlpha = 0;
int xtemp = 0;

boolean fadeInNotPlaying = true;
boolean fadeOutNotPlaying = true;
boolean firstAnimation = true;
boolean startWipe = false;
boolean endFirstClip = false;
boolean endSecondClip = false;


enum Exercise
{
  EXERCISE1,
  EXERCISE2,
  EXERCISE3,
  EXERCISE4
}

Exercise currentExercise;
 
void settings(){
      img = loadImage("black.png");
      size(960, 540);
}
 
void setup() {
  background(0);
  currentExercise = Exercise.EXERCISE1;
  switch(currentExercise)
  {
    case EXERCISE1:
      myMovie = new Movie(this, "PCMLab10.mov");
      mmask = new PImage(960,540);
      for (int x = 0; x < 960; x++)
      {
        for (int y = 0; y < 540; y++)
        {
          mmask.set(x,y, 255);
        }
      }
      break;
    case EXERCISE2:
      myMovie = new Movie(this, "PCMLab10.mov");
      myMovie2 = new Movie(this, "PCMLab11-2.mov");
      mmask = new PImage(960,540);
      break; 
    case EXERCISE3:
      break;
    case EXERCISE4:
      img = loadImage("background.png");
      size(960, 540);
      myMovie = new Movie(this, "PCMLab11-2.mov");
      mmask = new PImage(960,540);
      break;
    default:
      break;
  }
  myMovie.play();
  
}

void keyPressed()
{
   if(key == '+' && threshold < 254)
   {
     threshold += 1;
     System.out.println(threshold);
   }
   if(key == '-' && threshold > 0)
   {
     threshold -= 1;
     System.out.println(threshold);
   }
   if(key == '1')
   {
     startWipe = true;
     System.out.println(startWipe);
   }
}
 
void draw()
{
  switch(currentExercise)
  {
    case EXERCISE1:
      if (mimg != null)
      {
        if(!fadeInNotPlaying)
        {
          mimg.mask(mmask);
          image(img, 0, 0);
          image(mimg, xtemp+8, 0);
        }
        else if(!fadeOutNotPlaying)
        {
          mimg.mask(mmask);
          image(img, 0, 0);
          image(mimg, 0, 0);
        }
        else
        {
          image(mimg, 0, 0);
        }
      }
      break;
    case EXERCISE2:
      if(endFirstClip)
      {
         myMovie.stop();
         myMovie2.play();
      }
      if(endSecondClip)
      {
         myMovie2.stop(); 
      }
      if (mimg != null)
      {
        if(!fadeInNotPlaying)
        {
          mimg.mask(mmask);
          image(img, 0, 0);
          image(mimg, 0, 0);
        }
        else if(!fadeOutNotPlaying)
        {
          mimg.mask(mmask);
          image(img, 0, 0);
          image(mimg, 0, 0);
        }
        else
        {
          image(mimg, 0, 0);
        }
      }
      break; 
    case EXERCISE3:
      break;
    case EXERCISE4: 
      if (mimg != null)
      {
        mimg.mask(mmask);
        image(img, 0, 0);
        image(mimg, 0, 0);
      }
      break;
    default:
      break;
  }
}

// Called every time a new frame is available to read
void movieEvent(Movie m)
{
  switch(currentExercise)
  {
    case EXERCISE1:
      m.read();
      wipe(m);
      break;
    case EXERCISE2:
      if(m == myMovie)
      {
        myMovie.read();
      }
      if(m == myMovie2)
      {
        myMovie2.read();
      }
      fade(m);
      break; 
    case EXERCISE3:
      break;
    case EXERCISE4:
      m.read();
      chromaKey(m);
      break;
    default:
      break;
  }
}

void wipe(Movie m){
     mimg = m.get();
         
   if (firstAnimation && (m.duration() - m.time()) <= fadeDuration)
   {
      fadeInNotPlaying = false;
      for (int x = xtemp; x < xtemp+8; x++)
      {
        for (int y = 0; y < 540; y++)
        {
          
          mmask.set(x, y, 255);
        }
      }
      xtemp+=8;
   }
}

void fade(Movie m)
{
   mimg = m.get();
   System.out.println(mimg);
   if (firstAnimation && (m.duration() - m.time()) <= fadeDuration && currentAlpha > 0)
   {
      fadeInNotPlaying = false;
      for (int x = 0; x < 960; x++)
      {
        for (int y = 0; y < 540; y++)
        {
          mmask.set(x,y, currentAlpha);
        }
      }
      currentAlpha-=5;
      System.out.println(m.time());
      System.out.println(currentAlpha);
   }
   else if(!fadeInNotPlaying && currentAlpha <= 0)
   {
      currentAlpha = 0;
      fadeInNotPlaying = true;
      firstAnimation = false;
      endFirstClip = true;
      mimg = null;
      mmask = new PImage(960,540);
   }
   
   if (!firstAnimation && myMovie2.time() <= fadeDuration && currentAlpha < 254)
   {
      fadeOutNotPlaying = false;
      for (int x = 0; x < 960; x++)
      {
        for (int y = 0; y < 540; y++)
        {
          mmask.set(x,y, currentAlpha);
        }
      }
      currentAlpha+=5;
   }
   else if(!fadeOutNotPlaying && currentAlpha >= 254)
   {
      fadeOutNotPlaying = true;
      endSecondClip = true;
   }
}

void chromaKey(Movie m)
{
  mimg = m.get();
  for (int x = 0; x < 960; x++)
  {
     for (int y = 0; y < 540; y++)
     {
        int green = (mimg.get(x,y) >> 8) & 0xff;
        
        if (green > threshold)
        {
          mmask.set(x,y,0);
        }
        else
        {
          mmask.set(x,y,255);
        }
     }
  }
}
