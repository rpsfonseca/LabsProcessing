import java.util.Collections;
import java.util.Comparator;

/*PImage img;
float r, g, b;
float c, m, Y, k;
float [][] C = new float[208][278];
float [][] M = new float[208][278];
float [][] YY = new float[208][278];
float [][] K = new float[208][278];
float posx, posy; 
 
ArrayList<ArrayList<PVector>> hist = new ArrayList<ArrayList<PVector>>(256);


void setup()
{
  size(450,450);
  PImage myImage = loadImage("PCMLab9.png");
  image(myImage, 0, 0);
  myImage.updatePixels();
}

void draw()
{

  loadPixels();
  color pixel = get(mouseX,mouseY);
  //pixels[i]= pixel;
  noStroke();
  fill(pixel);

  if(mousePressed == true) {

    posx=mouseX-(mouseX%20);
    posy=mouseY-(mouseY%20);
    rect(posx,posy,20,20);
  }
}*/

PImage image;

void setup() {
  size (208,278);
  image=loadImage("PCMLab9.png");
  image(image, 0, 0);
}
 
void draw(){
}


void keyPressed(){
  if (key == 'p') {
    pixelize(50);
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

void reset(){
  clear();
  setup();
}
