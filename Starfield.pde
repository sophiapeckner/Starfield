Particle[] p;

void setup(){
  size(300,300);
  p = new Particle[500];
  
  for (int i = 0; i < p.length; i++){
    p[i] = new Particle(((2 * PI) / 500) * i);
  }
}

void draw(){
  background(255, 230, 150);
  for (int i = 0; i < p.length; i++){
    p[i].show();
    p[i].move();
  }
}

class Particle{
  double myX, myY, myAngle, mySpeed;
  int myColor;
  
  Particle(double angle){
    myColor = (int) (Math.random() * 255);
    myX = 150;
    myY = 150;
    mySpeed = (int)(Math.random() * 50) + 1;
    myAngle = angle;
  }
  
  void move(){
    myX += Math.cos(myAngle) * mySpeed;
    myY += Math.sin(myAngle) * mySpeed;
  }
  
  void show(){
    fill(myColor);
    ellipse((float)myX, (float)myY, 15, 15);
  }
}

class OddballParticle{
  //your code here
}
