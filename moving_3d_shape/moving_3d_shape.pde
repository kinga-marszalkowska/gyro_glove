import processing.serial.*;
import java.awt.event.KeyEvent;
import java.io.IOException;
Serial myPort;
String data="";
float roll, pitch;
void setup() {
  size (960, 640, P3D);
  myPort = new Serial(this, Serial.list()[0], 115200); // starts the serial communication with the first port on the list -the one arduino is using
  myPort.bufferUntil('\n');
}
void draw() {
  translate(width/2, height/2, 0);
  background(33);
  textSize(22);
  text("Roll: " + int(roll) + "     Pitch: " + int(pitch), -100, 265);
  // Rotate the object
  rotateX(radians(-pitch));
  rotateZ(radians(roll));
  
  // 3D 0bject
  textSize(30);  
  fill(0, 76, 153);
  box (200, 40, 380); // Draw box
  textSize(25);
  fill(255, 255, 255);
 
}
// Read data from the Serial Port
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
