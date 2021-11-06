import java.util.HashMap;
import java.util.Random;

int page = 1;

// Button Coord.
int startGameRectX = 35;
int startGameRectY = 150;
int learnMoreRectY = 185;
int startRectX = 150;
int startRectY = 365;

HashMap<String, Float> levels = new HashMap<String, Float>();

int[] barriers;
HashMap<Float, Integer> barriersData = new HashMap<Float, Integer>();
HashMap<Integer, String> rowDirection = new HashMap<Integer, String>();
boolean stateEmpty = true;
String state;
int numBarriers;    // Length of barriers[]

Square[] mySquare;
int gridLength = 7;
int gridWidth = 7;
int squareSize = (int) 400/gridLength - 10; 

int start = gridLength * (gridWidth - 1); // 42
int end = 6;
int currentIndex = gridLength * (gridWidth - 1);
int endIndex = 6;

void setup() {
  size(400,400); 
  frameRate(30);                  // Slow down the game speed
  populateLevels();
  //noLoop();
}

void draw() { 
  background(#F2F3AE);
  if (page == 1)        page1();
  else if (page == 2)   page2();
  else if (page == 3)   page3();
  else if (page == 4)   page4();
}

// PAGES //
void page1() {
  prettyText("APP NAME", 40, 130, "title");
  prettyText("Play Game", 40, 170, "button");
  noFill();
  rect(startGameRectX, startGameRectY, 100, 25);
  prettyText("Learn More", 40, 205, "button");
  noFill();
  rect(startGameRectX, learnMoreRectY, 100, 25);
}

void page2() {
  prettyText("ABOUT", 40, 60, "title");
  String[] about = {
    "This game will visually demonstrate the barriers people face",
    "when seeking out mental health services. The number of",
    "barriers is based off of a KFF.org dataset comparing the",
    "Percent of Need Met in U.S. states. This is defined as the",
    "number of psychiatrists available divided by the number of",
    "psychiatrists needed to eliminate the mental health",
    "professional shortage."};
  
  for (int i = 0; i < about.length; i ++) {
    prettyText(about[i], 20, 90 + (20 * i), "text");
  }
  
  prettyText("GAMEPLAY", 40, 280, "title");
  
  String[] gamePlay = {
    "(1) Use arrow keys to change your current position",
    "(2) Don't hit the MOVING red blocks",
    "(3) Navigate to the finish line!"};
  
  for (int i = 0; i < gamePlay.length; i ++) {
    prettyText(gamePlay[i], 20, 310 + (20 * i), "text");
  }
  
  prettyText("Start", 180, 385, "button");
  noFill();
  rect(startRectX, startRectY, 100, 25);
}

void page3() {
  if (stateEmpty) {
    currentIndex = start;
    barriersData = new HashMap<Float, Integer>();
    state = chooseRandomState(); 
    if (state != "Done") {
      numBarriers = (int) (49 * levels.get(state));
      levels.remove(state);
      populateBarrier(numBarriers);  // Populate with random indexes
      splitBarrierIntoRows();        // Getting the barrier indexes row number
      determineRowDirection();       // Use barriersData to determine a random row direction
      stateEmpty = false;
    }
  }
  prettyText(state, 10, 30, "button");
  updateBarrier();
}

void page4() {
  prettyText("DONE", 40, 60, "title");
}

// BARRIERS //
// Populating an array of indexes
void populateBarrier(int myCount) {
  barriers = new int[myCount];
  int i = 0;
  while (i < myCount) {
    int randomPos = (int) (Math.random() * 49);
    if (randomPos != gridLength * (gridWidth - 1) && randomPos != endIndex && !inBarrier(randomPos)) {
      barriers[i] = randomPos;
      i++;
    }
  }
}

void splitBarrierIntoRows() {
  for (int i = 0; i < barriers.length; i++) {
    int rowNum = int(barriers[i]/gridLength);
    barriersData.put(float(barriers[i]), rowNum);
  }
}

void determineRowDirection() {
  for (int i = 0; i < 7; i++) {
    if (Math.random() < 0.5)  rowDirection.put(i, "left");
    else                      rowDirection.put(i, "right");
  }
}

void updateBarrier() {
  barriers = new int[numBarriers];
  HashMap<Float, Integer> updatedBarrier = new HashMap<Float, Integer>();
  int i = 0;
  for (float barrierIndex : barriersData.keySet()) {
    int rowNum = barriersData.get(barrierIndex);
    String direction = rowDirection.get(rowNum);
    
    //if (direction == "left") barriers[i] = barrierIndex - 1;
    //else                     barriers[i] = barrierIndex + 1;
    
    float newPos = newBarrierPos(direction, barrierIndex);
    
    if (barrierIndex == gridLength * (gridWidth - 1))  barriers[i] = (gridLength * gridWidth) - 1;
    else if (direction == "left")    barriers[i] = (int) Math.ceil(newPos);
    else if (direction == "right")   barriers[i] = (int) Math.floor(newPos);
    updatedBarrier.put(newPos, rowNum);
    i++;
  }
  barriersData = updatedBarrier;
  updateGrid();
}

public float newBarrierPos(String direction, float currentPos) {
  if (direction == "left") {
    if (Math.ceil(currentPos + 0.5) % gridLength == 0) return currentPos + 6;
    else return currentPos - 0.02;
  }
  else {
    if (int(currentPos + 1) % gridLength == 0) return currentPos - 6;
    else return currentPos + 0.02;
  }
}

// Check to see if that index is in barriers[]
public boolean inBarrier(int index) {
    for (int i = 0; i < barriers.length; i++)
      if (index == barriers[i]) return true;
    return false;
}

// LEVEL DATA //
void populateLevels() {
  levels.put("Alabama", 0.759);
  levels.put("Colorado", 0.659);
  levels.put("New Jersey", 0.302);
  levels.put("Arizona", 0.889);
  //levels.put("Arizona", 0.089);
}

public String chooseRandomState() {
  Object[] crunchifyKeys = levels.keySet().toArray();
  println(crunchifyKeys);
  if (crunchifyKeys.length > 0) {
    int index = (int)(Math.random() * (crunchifyKeys.length-1));
    Object key = crunchifyKeys[index];
    return (String) key;
  }
  else { 
    page = 4;
    return "Done";
  }
}

// GAME GRID //
void updateGrid() {
  int myIndex = 0;    // Count the index of squares (0 - 48)
  mySquare = new Square[49];
  
  for (int y = 0; y < gridLength; y++){
    for (int x = 0; x < gridWidth; x++){
      String myColor;
      
      // Fill the squares depending on it's 'purpose'
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
  if (inBarrier(currentIndex) || currentIndex == endIndex) {
    textSize(128);
    fill(0);
    text("GAME OVER", 0, 150);
    stateEmpty = true;
    print("game over!");
    page3();
  }
}

void showGrid() {
  for (int i = 0; i < mySquare.length; i++) mySquare[i].show();
}

// DESIGN //
void prettyText( String word, int x, int y, String type) {
  if (type == "title") {
    textSize(60);
    fill(#FF521B);
    text(word, x, y);
    fill(#FC9E4F);
    text(word, x-2, y-2);
  }
  else if (type == "button") {
    fill(#020122);
    textSize(20);
    text(word, x, y);
  }
  else if (type == "text") {
    fill(#020122);
    textSize(15);
    text(word, x, y);
  }
}
  
// USER INTERACTION //
void keyPressed() {
  if (keyCode == RIGHT){
    if ((currentIndex + 1) % gridLength != 0) currentIndex += 1;
    //currentIndex!= 6 && currentIndex != 13 && currentIndex != 20 && currentIndex != 27 && currentIndex != 34 && currentIndex != 41 && currentIndex != 48
  }
  else if (keyCode == LEFT){
    if (currentIndex % gridLength != 0) currentIndex -= 1;
  }
  else if (keyCode == UP){
    if (currentIndex > 6) currentIndex -= gridLength;
  }
  else if (keyCode == DOWN){
    if (currentIndex < 42)  currentIndex += gridLength;
  }
  redraw();
}  

void mousePressed() {
  if (mouseX > startGameRectX && mouseX < startGameRectX + 100 && mouseY > startGameRectY && mouseY < startGameRectY + 25) {
    // Pressed Play Game
    page = 2;
  } 
  else if (mouseX > startGameRectX && mouseX < startGameRectX + 100 && mouseY > learnMoreRectY && mouseY < learnMoreRectY + 25){
    // Pressed Learn More
  }
  else if (mouseX > startRectX && mouseX < startRectX + 100 && mouseY > startRectY && mouseY < startRectY + 25){
    // Pressed Start
    page = 3;
  }
}

class Square {
  float myX, myY;
  String myColor;
  
  Square(float x, float y, String paint){
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
