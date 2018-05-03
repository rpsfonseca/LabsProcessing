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
    pixelize(5);
  } 
  if(key == '1') {
    reset();
  }
}

void pixelize(int size){
  for ( int i=0; i<width; i+=size ){
    for ( int j=0; j<height; j+=size){
     //color c= getColours(i,j, size);
     color c= image.get(i,j);
     fill(c);
     rect(i, j, size, size);
    }
  }
}

color getColours(int currenti, int currentj, int size){
  color finalColor = 0;
  color c = 0;
  int times = 0;
  
  for ( int i=(currenti); i<(currenti + size); i+=1 ){
    if(i >= 0 && i <= width){
      for ( int j=(currentj); j<(currentj + size); j+=1){
        if(j >= 0 && j <= height){
           c = image.get(i,j);
           finalColor += c ;
           times += 1;
        }
      }
    }
  }
  return finalColor/times;
}

void reset(){
  clear();
  setup();
}
