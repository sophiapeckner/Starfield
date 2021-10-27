Square[] mySquare;
int squareSize = (int)400/7 - 10;
int currentIndex = 6;

int[] barriers = {20};
// ^ save the {i} of those that will be saved 

void setup() {
  size(400,400);
  noLoop();
}

void draw() {
  int c = 0;
  mySquare = new Square[49];
  
  for (int i = 0; i < 7; i++){
    for (int j = 0; j < 7; j++){
      // check if {count} is a certain num and if is then color it, change {count} when keypressed
      mySquare[c] = new Square(i*squareSize + 35, 
                               j*squareSize + 35,
                               squareSize,
                               c);
     drawCurrentPos(c, i, j);
     drawBarrier(c, i, j);
      c++;
    }
  }
  
  for (int i = 0; i < mySquare.length; i++){
    mySquare[i].show();
  }
}

void drawCurrentPos(int index, int i, int j) {
  if (index == currentIndex) {
    mySquare[index] = new Square(i*squareSize + 35, 
                                 j*squareSize + 35,
                                 squareSize,
                                 100);
  }
}

void drawBarrier(int index, int i, int j) {
  if (index == barriers[0]){
    mySquare[index] = new Square(i*squareSize + 35, 
                                 j*squareSize + 35,
                                 squareSize,
                                 200);
  }
}

void keyPressed() {
  if (keyCode == RIGHT){
    if (currentIndex < 42)  currentIndex += 7;
    if (currentIndex == barriers[0]) print("barrier");
  }
  else if (keyCode == LEFT){
    if (currentIndex > 6)  currentIndex -= 7;
    if (currentIndex == barriers[0]) print("barrier");
  }
  else if (keyCode == UP){
    if (currentIndex % 7 != 0) currentIndex -= 1;
    if (currentIndex == barriers[0]) print("barrier");
  }
  else if (keyCode == DOWN){
    if (currentIndex != 6 && currentIndex != 13 && currentIndex != 20 && currentIndex != 27 && currentIndex != 34 && currentIndex != 41 && currentIndex != 48)  currentIndex += 1;
    if (currentIndex == barriers[0]) print("barrier");
  }
  redraw();
}

class Square {
  int myX, myY, myNum, mySize;
  Square(int x, int y, int size, int num){
    myX = x;
    myY = y;
    mySize = size;
    myNum = num;
  }
  
  void show(){
    fill(255);
    if (myNum == 200) fill(255,0,0);
    if (myNum == 100) fill(0);
    rect(myX, myY, mySize, mySize);
  }
}
