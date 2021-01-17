import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;
Serial myPort;
String data="";

float roll, pitch; // angles (in radians) by which the controller was moved
float ballX, speedX; // ballX & Y -> x,y coordinates, position of a ball

float ballY, speedY; // speed -> how fast a ball should move from point A to B, calculated with data from accelerometer

final int boardX = 960; // board size
final int boardY = 640;

boolean touched = false; // flag to sign if anything was touched (obstacle / star), a signal to generate new points on the board

float starX, starY; // position of star that gives points

float obsx[] = {1, 2, 3, 4, 5, 6}; // arrays of x,y coordinates of obstacles 
float obsy[]= {1, 2, 3, 4, 5, 6};

int score;

void setup() {
  size (960, 640, P3D);
  myPort = new Serial(this, Serial.list()[0], 115200); // starts the serial communication with the first port on the list -the one arduino is using
  myPort.bufferUntil('\n'); // read data until end of line 
  
  // set initial values ball, at the start ball appers at the top, not moving
  ballX = 16;
  ballY = 16;
  speedX = 1;
  speedY = 1;
  
  
}

void draw() {
  background(80);
  background(33);
  
  ellipse(ballX, ballY, 32, 32); // draw ball
  speedX = (roll)/8;
  speedY = (pitch)/8;
  ballX += speedX;
  ballY += speedY;
  
  //if a ball hits board boundaries stop it, dont let it move past boundaries
  if (ballX <= 16){
    ballX = 16;
  }
  
  else if(ballX >= boardX - 16){
    ballX = boardX-16;
  }  
  
  if(ballY <= 16){
    ballY = 16;
  }
  
  else if(ballY >= boardY - 16){
    ballY = boardY-16;
  }
  
  if (touched){ // if any point is touched, generate new cooridnates for a star
    starX = random(50, boardX-50);
    starY = random(50, boardY-50);
    for (int i=0; i <= 5; i++){ // do the same for 6 obstacles
      obsx[i] = random(50, boardX-50);
      obsy[i] = random(50, boardY-50);
    }
    touched = false; 
  }
  
  star(starX, starY, 40, 50, 40); // create a star
  
  for (int i=0; i <= 5; i++){ // create obstacles 
      star(obsx[i], obsy[i], 40, 40, 5);
  }
  
  // if the ball touches the star, calculated with distance formula
  if(pow(pow((ballX - starX), 2) + pow((ballY - starY), 2), 0.5) <= 50+25){
    touched = true;
    score += 3;
    //println(score);
  }
  
  // if the ball touches the obstacle
  for (int i=0; i <= 5; i++){
    if(pow(pow((ballX - obsx[i]), 2) + pow((ballY - obsy[i]), 2), 0.5) <= 32+25){
    touched = true;
    score -= 1;
    println(score);
    }
  // display score
    fill(255,0,0);
    textSize(22);
    text("SCORE: " + int(score), (boardX/2)-50, boardY-50);

    fill(255);
  }
  
}

// get data from serial port
void serialEvent (Serial myPort) { 
  data = myPort.readStringUntil('\n');
  // if you got any bytes other than the linefeed:
  if (data != null) {
    data = trim(data);
    // split the string at "/"
    String items[] = split(data, '/');
    if (items.length > 1) {
      //--- Roll,Pitch in degrees
      roll = float(items[0]);
      pitch = float(items[1]);
    }
  }
}

// draw shape function
void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
