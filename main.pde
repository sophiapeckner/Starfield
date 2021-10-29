import java.util.Arrays;

Square[] mySquare;
int squareSize = (int)400/7 - 10;
int currentIndex = 6;
int endIndex = 42;

int myCount = (int) (49 * 0.29);
int[] barriers; 

void setup() {
  size(400,400);
  populateBarrier(myCount);
  noLoop();
}

void draw() {
  // Keeps track of squares drawn
  int c = 0;
  mySquare = new Square[49]; 
  for (int i = 0; i < 7; i++){
    for (int j = 0; j < 7; j++){
      // Draw grid's squares
      mySquare[c] = new Square(i*squareSize + 35, 
                               j*squareSize + 35,
                               squareSize,
                               "");
     
     if (drawBarrier(c)) {
       mySquare[c] = new Square(i*squareSize + 35, 
                               j*squareSize + 35,
                               squareSize,
                               "red");
     }
     
     drawCurrentPos(c, i, j);
     drawEndPos(c, i, j);
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
                                 "black");
  }
}

void drawEndPos(int index, int i, int j) {
  if (index == endIndex) {
    mySquare[index] = new Square(i*squareSize + 35, 
                                 j*squareSize + 35,
                                 squareSize,
                                 "black");
  }
}

// ~ Populate barrier[] with random-positioned blocks
void populateBarrier(int count) {
  barriers = new int[count];
  int i = 0;
  while (i < count) {
    int randomPos = (int) (Math.random() * 49);
    if (randomPos != currentIndex && randomPos != endIndex && !drawBarrier(randomPos)) {
      barriers[i] = randomPos;
      i++;
    }
  }
}

public boolean drawBarrier(int index) {
  for (int i = 0; i < barriers.length; i++){
    if (index == barriers[i]) return true;
  }
  return false;
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
  String myColor;
  Square(int x, int y, int size, String paint){
    myX = x;
    myY = y;
    mySize = size;
    myColor = paint;
  }
  
  void show(){
    fill(255);
    if (myColor == "red") fill(255,0,0);
    if (myColor == "black") fill(0);
    rect(myX, myY, mySize, mySize);
  }
}

class Barrier {
  int myX, myY;
  
  Barrier(int x, int y) {
    myX = x;
    myY = y;
  }
  
  void show(){
    fill(255,0,0);
    rect(myX, myY, squareSize, squareSize);
  }
}
