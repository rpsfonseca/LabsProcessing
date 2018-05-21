import processing.video.*;
Movie myMovie;
PImage img, mimg;
PImage mmask;
float threshold = 254;
 
void settings(){
  img = loadImage("background.png");
  size(img.width, img.height);
}
 
void setup() {
  size(960, 540);
  background(0);
  myMovie = new Movie(this, "PCMLab11-2.mov");
  myMovie.play();
  mmask = new PImage(960,540);
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
}
 
void draw()
{
  //
  if (mimg != null)
  {
    mimg.mask(mmask);
    image(img, 0, 0);
    image(mimg, 0, 0);
  }
}

// Called every time a new frame is available to read
void movieEvent(Movie m)
{
  m.read();
  chromaKey(m);
}

void chromaKey(Movie m)
{
  mimg=m.get();
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
