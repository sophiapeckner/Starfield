Particle[] p;
long startTime = millis();

void setup() {
  size(350,350);
  p = new Particle[500];
  
  for (int i = 0; i < 400; i++) {
    p[i] = new Particle();
    p[i].myAngle = ((2 * 3.14) / 500) * i;
  }
  
  for (int j = 400; j < p.length; j++) {
    p[j] = new OddballParticle();
    p[j].myAngle = j;
  }
}

void draw() {
  //background(255, 230, 150);
  background(0);
  long endTime = millis();
  if (endTime - startTime <= 3000) {
    prettyText("IM", 20, 80);
    prettyText("GOING", 20, 160);
    prettyText("TO", 20, 240);
  }
  
  else if (endTime - startTime <= 5000) {
    prettyText("CH", 30, 80);
    prettyText("CH", 80, 160);
    prettyText("CH", 130, 240);
  }
  
  else if (endTime - startTime >= 5000) {
    prettyText("CHERRY", 20, 130);
    prettyText("BOMB", 50, 210);
    for (int i = 0; i < p.length; i++){
      p[i].show();
      p[i].move(p[i].myAngle);
    }
  }
}

void prettyText(String content, int x, int y) {
  textSize(80);
  fill(#d00000);
  text(content, x, y);
  fill(#e85d04);
  text(content, x-5, y-5);
}

class Particle {
  double myX, myY, myAngle, mySpeed;
  int myColor;
  
  Particle() {  //double angle
    myColor = (int) (Math.random() * 255);
    myX = 150;
    myY = 150;
    mySpeed = (int)(Math.random() * 50) + 1;
    myAngle = 0;  //angle
  }
  
  void move(double angle) {
    myX += Math.cos(angle) * mySpeed;
    myY += Math.sin(angle) * mySpeed;
  }
  
  void show() {
    fill(myColor);
    //ellipse((float)myX, (float)myY, 10, 10);
    pushMatrix();
    pushStyle();
    translate((int) (myX-73), (int) (myY-120));
    scale(0.5, 0.5);
    noFill();
    stroke(0, 255, 0);
    beginShape();
    bezier(138, 256, 132, 231, 154, 207, 166, 195);
    popStyle();
    popMatrix();
    
    pushMatrix();
    pushStyle();
    translate((int)myX, (int)myY);
    scale(0.3, 0.3);
    rotate(0);
    fill(255,0,0);
    stroke(0);
    beginShape();
    curveVertex(-42,34); curveVertex(-26,24); curveVertex(-6,26); curveVertex(9,19); curveVertex(32,24); curveVertex(35,61); curveVertex(4,85); curveVertex(-34,72); curveVertex(-42,34); curveVertex(-26,24); curveVertex(-6,26);
    endShape();
    popStyle();
    popMatrix();
  }
}

class OddballParticle extends Particle {
  //your code here
  OddballParticle() {
    myColor = (int) (Math.random() * 255);
    myX = 150;
    myY = 150;
    mySpeed = (int)(Math.random() * 50) + 1;
    myAngle = 6.3;
  }
  
  void show() {
    pushMatrix();
    pushStyle();
    translate((int)myX, (int)myY);
    scale(0.3,0.3);
    rotate(0);
    fill(#e85d04);
    stroke(#d00000);
    strokeWeight(4);
    beginShape();
    curveVertex(3,-77); curveVertex(13,-48); curveVertex(4,-5); curveVertex(-5,-47); curveVertex(3,-77); curveVertex(13,-48); curveVertex(4,-5); /**/
    endShape();
    popStyle();
    popMatrix();
  }
}
