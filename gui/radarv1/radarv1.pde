
/*   Arduino Radar Project
 *
 *   Updated version. Fits any screen resolution!
 *   Just change the values in the size() function,
 *   with your screen resolution.
 *      
 *  by Dejan Nedelkovski, 
 *  www.HowToMechatronics.com
 *  
 */
import processing.serial.*; // imports library for serial communication
import java.awt.event.KeyEvent; // imports library for reading the data from the serial port
import java.io.IOException;
Serial myPort; // defines Object Serial
// defubes variables
String angle="";
String distance="";
String data="";
String noObject;
float pixsDistance;
int iAngle=0, iDistance=0;
int index1=0;
int index2=0;
PFont orcFont;
void setup() {
  
 size (600, 600); // ***CHANGE THIS TO YOUR SCREEN RESOLUTION***
 smooth();
/* myPort = new Serial(this,"COM4", 9600); // starts the serial communication
 myPort.bufferUntil('.');*/ // reads the data from the serial port up to the character '.'. So actually it reads this: angle,distance.
 orcFont = loadFont("FreeMonoBold-48.vlw");
}
void draw() {
  
  fill(98,245,31);
  textFont(orcFont);
  // simulating motion blur and slow fade of the moving line
  noStroke();
  fill(0,4); 
  rect(0, 0, width, height-height*0.0340); 
  
  fill(98,245,31); // green color
  // calls the functions for drawing the radar
  drawRadar(); 
  drawObject();
  drawText();
}

void serialEvent (Serial myPort) { // starts reading data from the Serial Port
  // reads the data from the Serial Port up to the character '.' and puts it into the String variable "data".
  data = myPort.readStringUntil('.');
  data = data.substring(0,data.length()-1);
  
  index1 = data.indexOf(","); // find the character ',' and puts it into the variable "index1"
  angle= data.substring(0, index1); // read the data from position "0" to position of the variable index1 or thats the value of the angle the Arduino Board sent into the Serial Port
  distance= data.substring(index1+1, data.length()); // read the data from position "index1" to the end of the data pr thats the value of the distance
  
  // converts the String variables into Integer
  iAngle = int(angle);
  iDistance = int(distance);
}
void drawRadar() {
  pushMatrix();
  translate(width/2,height/2); 
  rotate(PI);// moves the starting coordinats to new location
  noFill();
  strokeWeight(8);
  stroke(98,245,31);
  // draws the arc lines
  arc(0,0,(width-width*0.09),(width-width*0.09),0,TWO_PI);
  // draws the angle lines
  line(0,0,(width-width*0.09)*cos(radians(30))*0.5,(width-width*0.09)*sin(radians(30))*0.5);
  line(0,0,(width-width*0.09)*cos(radians(90))*0.5,(width-width*0.09)*sin(radians(90))*0.5);
  line(0,0,(width-width*0.09)*cos(radians(150))*0.5,(width-width*0.09)*sin(radians(150))*0.5);
  line(0,0,(width-width*0.09)*cos(radians(210))*0.5,(width-width*0.09)*sin(radians(210))*0.5);
  line(0,0,(width-width*0.09)*cos(radians(270))*0.5,(width-width*0.09)*sin(radians(270))*0.5);
  line(0,0,(width-width*0.09)*cos(radians(330))*0.5,(width-width*0.09)*sin(radians(330))*0.5); 
  popMatrix();
}
void drawObject() {
  pushMatrix();
  translate(width/2,height/2); // moves the starting coordinats to new location
  rotate(-PI/2);
  strokeWeight(4);
  stroke(255,10,10); // red color
  pixsDistance = iDistance*((height-height*0.09)*0.01); // covers the distance from the sensor from cm to pixels

     // draws the object according to the angle and the distanc4
  line(0,0,pixsDistance*cos(radians((6-iAngle)*60)),pixsDistance*sin(radians((6-iAngle)*60)));
  
  popMatrix();
}

void drawText() { // draws the texts on the screen
  
  pushMatrix();
  noStroke();
  fill(0,0,0);
  rect(0,width-width*0.0340,width,height);
  fill(98,245,31);
  textSize(20);
  text("Distance: ", width-width*0.4, height-height*0.01);
  if(iDistance<40) {
  text("        " + iDistance +" cm", width-width*0.3, height-height*0.01);
  }
  popMatrix(); 
}