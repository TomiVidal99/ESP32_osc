import com.krab.lazy.*;
import processing.serial.*;

int BAUD_RATE = 115200;

LazyGui gui;
Serial myPort;

int timeInterval = 10;
int totalSamples = 200*timeInterval;
int refreshBgCounter = 0;
int index = 0;
int prevIndex = 0;
int val = 0;
int prevVal = 0;
String temp;
int screenMode = 0;

void setup() {
  size(800, 400, P2D);
  // println(Serial.list());
  // String portName = Serial.list()[1];
  // myPort = new Serial(this, portName, BAUD_RATE);
  gui = new LazyGui(this);
  createPortPickerMenu();
  // background(0);
  // colorMode(RGB, 400);
}
// 
void draw() {
  if (screenMode == 0) {
    createPortPickerMenu();
  } else {
    while(myPort.available() > 0) {
      temp = myPort.readStringUntil('\n');
      println(temp);
      prevVal = val;
      if (temp != null) {
        temp = trim(temp);
        val = int(temp);
      } else {
        val = 0;
      }
      strokeWeight(10);
      stroke(0, 255, 0);
      line(width*index/totalSamples, height*0.9-(height*0.8)*val/5000, width*prevIndex/totalSamples, height*0.9-(height*0.8)*prevVal/5000);
      prevIndex = index;
      index++;
      if (index >= totalSamples) {
        prevIndex = 0;
        index = 0;
      }
      stroke(0);
      line(width*index/totalSamples, 0, width*index/totalSamples, height);
      delay(2);
    }
  }
}

void createPortPickerMenu()
{
  background(120);
  for (int i = 0; i < Serial.list().length; i++) {
    String portName = Serial.list()[i]; 
    boolean btn = gui.button(portName);
    if (btn) {
      screenMode = 1;
      myPort = new Serial(this, portName, BAUD_RATE);
      if  (myPort.available() > 0){
        screenMode = 1;
      }
    }
  }
}

//void createOsciloscopeWindow()
//{

//}
