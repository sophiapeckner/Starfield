import java.util.HashMap;

int[] barriers;
HashMap<Integer, Integer> barriersData = new HashMap<Integer, Integer>();
HashMap<Integer, String> rowDirection = new HashMap<Integer, String>();
int numBarriers = (int) (49 * 0.29);    // Length of barriers[]

Square[] mySquare;
int squareSize = (int) 400/7 - 10;

int currentIndex = 42;
int endIndex = 6;

void setup() {
  size(400,400); 
  // Populate with random indexes
  populateBarrier(numBarriers);
  // Getting the barrier indexes row number
  splitBarrierIntoRows();
  determineRowDirection();
  //noLoop();
}

void draw() {
  updateGrid();
  updateBarrier();
}

// Populating an array of indexes
void populateBarrier(int myCount) {
  barriers = new int[myCount];
  int i = 0;
  while (i < myCount) {
    int randomPos = (int) (Math.random() * 49);
    if (randomPos != currentIndex && randomPos != endIndex && !inBarrier(randomPos)) {
      barriers[i] = randomPos;
      i++;
    }
  }
  for (int j = 0; j < barriers.length; j++) print(barriers[j] + ", ");
}

void splitBarrierIntoRows() {
  for (int i = 0; i < barriers.length; i++) {
    int rowNum;
    if (barriers[i] <= 6)          rowNum = 1;
    else if (barriers[i] <= 13)    rowNum = 2;
    else if (barriers[i] <= 20)    rowNum = 3;
    else if (barriers[i] <= 27)    rowNum = 4;
    else if (barriers[i] <= 34)    rowNum = 5;
    else if (barriers[i] <= 41)    rowNum = 6;
    else                           rowNum = 7;
    barriersData.put(barriers[i], rowNum);
  }
  println();
  print(barriersData);
}

void determineRowDirection() {
  for (int i = 1; i < 8; i++) {
    if (Math.random() < 0.5)  rowDirection.put(i, "left");
    else                      rowDirection.put(i, "right");
  }
  println();
  print(rowDirection);
}

void updateBarrier() {
  barriers = new int[numBarriers];
  HashMap<Integer, Integer> updatedBarrier = new HashMap<Integer, Integer>();
  int i = 0;
  for (int barrierIndex : barriersData.keySet()) {
    int rowNum = barriersData.get(barrierIndex);
    String direction = rowDirection.get(rowNum);
    
    //if (direction == "left") barriers[i] = barrierIndex - 1;
    //else                     barriers[i] = barrierIndex + 1;
    
    int newPos = newBarrierPos(direction, barrierIndex);
    barriers[i] = newPos;
    updatedBarrier.put(newPos, rowNum);
    i++;
  }
  barriersData = updatedBarrier;
  updateGrid();
  println();
  for (int j = 0; j < barriers.length; j++) print(barriers[j] + ", ");
}

public int newBarrierPos(String direction, int currentPos) {
  if (direction == "left") {
    if (currentPos % 7 == 0) return currentPos + 6;
    else                     return currentPos - 1;
  }
  else {
    if (currentIndex == 6 || currentIndex == 13 || currentIndex == 20 || currentIndex == 27 || currentIndex == 34 || currentIndex == 41 || currentIndex == 48) return currentPos - 6;
    else                     return currentPos + 1;
  }
  //else                     barriers[i] = barrierIndex + 1;
}  
// Check to see if that index is in barriers[]
public boolean inBarrier(int index) {
    for (int i = 0; i < barriers.length; i++)
      if (index == barriers[i]) return true;
    return false;
}

void updateGrid() {
  int myIndex = 0;    // Count the index of squares (0 - 48)
  mySquare = new Square[49];
  
  for (int y = 0; y < 7; y++){
    for (int x = 0; x < 7; x++){
      String myColor;
      
      if (myIndex == currentIndex)       myColor = "green";
      else if (myIndex == endIndex)      myColor = "black";
      else if (inBarrier(myIndex))       myColor = "red";
      else                               myColor = "white";
      
      mySquare[myIndex] = new Square(x*squareSize + 35, 
                                     y*squareSize + 35,
                                     myColor);
     myIndex++;
    }
  }
  showGrid();
}

void showGrid() {
  for (int i = 0; i < mySquare.length; i++) mySquare[i].show();
}

void keyPressed() {
  if (keyCode == RIGHT){
    if (currentIndex != 6 && currentIndex != 13 && currentIndex != 20 && currentIndex != 27 && currentIndex != 34 && currentIndex != 41 && currentIndex != 48) currentIndex += 1;
  }
  else if (keyCode == LEFT){
    if (currentIndex % 7 != 0) currentIndex -= 1;
  }
  else if (keyCode == UP){
    if (currentIndex > 6) currentIndex -= 7;
  }
  else if (keyCode == DOWN){
    if (currentIndex < 42)  currentIndex += 7;
  }
  redraw();
}

class Square {
  int myX, myY;
  String myColor;
  
  Square(int x, int y, String paint){
    myX = x;
    myY = y;
    myColor = paint;
  }
  
  void show(){
    if (myColor == "green") fill(0, 255, 0);
    if (myColor == "black") fill(0);
    if (myColor == "red")   fill(255, 0, 0);
    if (myColor == "white") fill(255);
    
    rect(myX, myY, squareSize, squareSize);
  }
}

/*
class Barrier {
  int myX, myY, myNum, mySize, myIndex;
  Barrier(int x, int y, int size, int index) {
    myX = x;
    myY = y;
    mySize = size;
    myIndex = index;
  }
  
  void show(){
    fill(255, 0, 0);
    rect(myX, myY, mySize, mySize);
  }
  
  // ~ Populate barrier[] with random-positioned blocks
  /*
  void populateBarrier() {
    barriers = new int[myCount];
    int i = 0;
    while (i < myCount) {
      int randomPos = (int) (Math.random() * 49);
      if (randomPos != currentIndex && randomPos != endIndex && !catchDuplicates(randomPos)) {
        barriers[i] = randomPos;
        i++;
      }
    }
  }
  
  boolean catchDuplicates(int index) {
    for (int i = 0; i < barriers.length; i++)
      if (index == barriers[i]) return true;
    return false;
  }
  
}
*/
