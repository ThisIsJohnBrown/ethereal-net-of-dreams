import vialab.SMT.event.*;
import vialab.SMT.util.*;
import vialab.SMT.*;
import vialab.SMT.renderer.*;
import vialab.SMT.swipekeyboard.*;

import vialab.SMT.*;

int num = 20;
float step, sz, offSet, theta, angle;
float[] thetas;
float[] heights;
boolean[] active;
float speed;
 
void setup() {
  size( displayWidth, displayHeight, SMT.RENDERER );
  SMT.init( this, TouchSource.AUTOMATIC);
  strokeWeight(5 * (displayWidth / 600));
  step = displayWidth / 20;
  
  speed = .1;

  Zone zone = new Zone( "MyZone");
  SMT.add( zone);
  
  SMT.setTouchDraw(TouchDraw.NONE);
  
  thetas = new float[num * 2];
  heights = new float[num * 2];
  active = new boolean[num * 2];
  for (int i = 0; i < num; i++) {
    thetas[i] = -1;
  }
  for (int i = num; i < num * 2; i++) {
    thetas[i] = 1;
  }
  for (int i = 0; i < num * 2; i++) {
    heights[i] = 0;
  }
  for (int i = 0; i < num * 2; i++) {
    active[i] = false;
  }
}

void drawMyZone( Zone zone){
  fill(0, 0, 0, 25);
  rect(0, 0, width, height);
  translate(width/2, height);
  angle=0; 
  for (int i=0; i<num; i++) {
    colorMode(HSB,255,100,100);
    stroke(255 - heights[i] * 255, 255, 255);
    noFill();
    sz = i*step;
    float offSet = TWO_PI/num*i;
    float arcEnd = map(thetas[i],-1,1, PI, TWO_PI);
    arc(0, 0, sz, sz, PI, arcEnd);
  }
  
  for (int i=num; i<num * 2; i++) {
    colorMode(HSB,255,100,100);
    stroke(255 - heights[i] * 255, 90, 90);
    noFill();
    sz = (i - 20)*step + step / 2;
    float offSet = TWO_PI/num*i;
    float arcEnd = map(thetas[i],-1,1, PI, TWO_PI);
    arc(0, 0, sz, sz, arcEnd, TWO_PI);
  }
  colorMode(RGB);
  resetMatrix();
}

void pickDrawMyZone( Zone zone){
  rect( 0, 0, width, height);
}

void draw() {
  for (int i = 0; i < num; i++) {
    thetas[i] -= speed / 4;
    if (thetas[i] < -1) {
      thetas[i] = -1;
    }
  }
  for (int i = num; i < num * 2; i++) {
    thetas[i] += speed / 4;
    if (thetas[i] > 1) {
      thetas[i] = 1;
    }
  }
  for (int i = 0; i < num * 2; i++) {
    active[i] = false;
  }
}

void touchMyZone( Zone zone){
  for (int i = 0; i < zone.getTouches().length; i++) {
    if (zone.getTouches()[i].getX() < (width / 2)) {
      int slice = floor(zone.getTouches()[i].getX() / ((width / 2) / 20));
      thetas[num - slice] += speed * 2;
      active[num - slice] = true;
      heights[num - slice] = zone.getTouches()[i].getY() / height;
      if (thetas[num - slice] > 1 + speed / 4) {
        thetas[num - slice] = 1 + speed / 4;
      }
    } else {
      int slice = floor(zone.getTouches()[i].getX() / ((width / 2) / 20));
      println(slice);
      thetas[slice] -= speed * 2;
      heights[slice] = zone.getTouches()[i].getY() / height;
      active[slice] = true;
      if (thetas[slice] < -1 - speed / 4) {
        thetas[slice] = -1 - speed / 4;
      }
    }
  }
}

boolean sketchFullScreen() {
  return true;
}
