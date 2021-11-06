import java.util.HashMap;
BufferedReader reader;
String line;

int page = 1;    // Tracks screen

// BUTTON DECLERATIONS
Button playBtn;
Button learnMoreBtn;
Button startBtn;
Button backToLevelsBtn;
Button[] stateLevels = new Button[49];

String[] states = new String[49];   // 49 U.S. states available on the KFF Dataset (no data for Vermont)
Float[] unmet = new Float[49];      // 100 - Percent of Need Met 

int[] barriers;                     // Stores the INDEXES of each barrier square
HashMap<Float, Integer> barriersData = new HashMap<Float, Integer>();    // Map {Barrier Index : Row It's In}
HashMap<Integer, String> rowDirection = new HashMap<Integer, String>();  // Map {Row Number : Random Direction, Left/ Right}
boolean gameOn = true;              // Checks whether barriersData needs to be updated
String state;                       // Stores the current state that the user is playing on
int numBarriers;

Square[] mySquare;
int gridLength = 10;
int gridWidth = 10;
int squareSize = (int) 400/gridLength - 10; 

int start = gridLength * (gridWidth - 1);          // Tracks the starting position -> a barrier can NOT be placed here
int currentIndex = gridLength * (gridWidth - 1);   // The square that the box (moved by the user) is located
int endIndex = gridLength - 1;                     // Track where the box must always move to

void setup() {
  size(400, 400); 
  frameRate(30);      // Slow down the game speed
  reader = createReader("/Users/sophiapeckner/Downloads/percentage1.csv");    // Loads the file. File is downloaded from: https://www.kff.org/other/state-indicator/mental-health-care-health-professional-shortage-areas-hpsas/?currentTimeframe=0&sortModel=%7B%22colId%22:%22Location%22,%22sort%22:%22asc%22%7D
  getData();
  populateStateLevels();
  playBtn = new Button(40, 170, 100, 25, "Play Game", 2);
  learnMoreBtn = new Button(40, 205, 100, 25, "Learn More", 2);
  startBtn = new Button(180, 365, 100, 25, "Start", 3);
  backToLevelsBtn = new Button(180, 365, 100, 25, "Back To Levels", 3);
}

void draw() { 
  background(#F2F3AE);
  
  if (page == 1)        page1();
  else if (page == 2)   page2();
  else if (page == 3)   page3();
  else if (page == 4)   page4();
  else if (page == 5)   page5();
}

// PAGES //
void page1() {      // Home Page
  prettyText("APP NAME", 40, 130, "title");
  // Shows both buttons
  playBtn.display();
  learnMoreBtn.display();
}

void page2() {      // Instructions Page
  prettyText("ABOUT", 40, 60, "title");
  // Array holding each sentence in the ABOUT section
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
  startBtn.display();
}

void page3() {          // Levels Page (Menu Of All Possible States)
  // Show 49 buttons, each corresponding to one state
  for (int i = 0; i < stateLevels.length; i++){
    stateLevels[i].display();
  }
}

void page4() {          // Play Game
  if (gameOn) {      // Checks whether or not barriersData has already been updated
    currentIndex = start;    // Reset boxes position
    barriersData = new HashMap<Float, Integer>();    // Reset barriersData
    populateBarrier(numBarriers);  // Populate barriersData with numBarriers number of random indexes
    splitBarrierIntoRows();        // Getting the barrier indexes row number
    determineRowDirection();       // Use barriersData to determine a random row direction
    gameOn = false;                // This way the barrier indexes aren't constantly changing
  }
  updateBarrier();
}

void page5() {         // After Lose/ Win Page
  prettyText("GOOD GAME", 40, 280, "title");
  int needMet = 100 - numBarriers; 
  prettyText("In " + state + ", " + needMet + "% of need is met", 20, 90, "text");
  prettyText("The barriers in the game represent the % of need that is NOT met", 20, 110, "text");
  backToLevelsBtn.display();
}

// BARRIERS //
// Populating an array of random indexe between 0 and total length of the grid (gridLength * gridLength)
void populateBarrier(int myCount) {
  barriers = new int[myCount];
  int i = 0;
  while (i < myCount) {
    int randomPos = (int) (Math.random() * (gridLength*gridLength));
    if (randomPos != gridLength * (gridWidth - 1) && randomPos != endIndex && !inBarrier(randomPos)) {    // Checks whether barrier is already in the array + whether it's on end/ start position
      barriers[i] = randomPos;      // Puts that index into barriers array
      i++;                          // Repeats the cycle -> Gets another index, check whether it meets the criteria, append to array
    }
  }
}

// Determine the row that each index is located in (ex. index 0 is ALWAYS in the 0th row)
void splitBarrierIntoRows() {
  for (int i = 0; i < barriers.length; i++) {
    int rowNum = int(barriers[i]/gridLength);
    barriersData.put(float(barriers[i]), rowNum);      // => {barrierIndex : Corresponding Row} => Ex. {0 : 0}
  }
}

void determineRowDirection() {
  for (int i = 0; i < gridLength; i++) {
    // Equal probability to have a row go left or right
    if (Math.random() < 0.5)      rowDirection.put(i, "left");
    else                          rowDirection.put(i, "right");
  }
}

// Update the barrier's index to the left or right
void updateBarrier() {
  barriers = new int[numBarriers];      // Reset barriers array because new indexes will be added to it
  HashMap<Float, Integer> updatedBarrier = new HashMap<Float, Integer>();
  int i = 0;
  // Loop through every existing barrier and see it's row num and index (aka. position in the grid)
  for (float barrierIndex : barriersData.keySet()) {
    int rowNum = barriersData.get(barrierIndex);
    String direction = rowDirection.get(rowNum);
    float newPos = newBarrierPos(direction, barrierIndex);
    
    if (barrierIndex == gridLength * (gridWidth - 1))  barriers[i] = (gridLength * gridWidth) - 1;    // Ensures that no barriers will be moved to the start index
    // Changes the index of the barrier element depending on its direction
    else if (direction == "left")    barriers[i] = (int) Math.ceil(newPos);
    else if (direction == "right")   barriers[i] = (int) Math.floor(newPos);
    updatedBarrier.put(newPos, rowNum);
    i++;
  }
  barriersData = updatedBarrier;    // Updates barriersData to hold new positions
  updateGrid();
}

public float newBarrierPos(String direction, float currentPos) {
  if (direction == "left") {
    if (Math.ceil(currentPos + 0.5) % gridLength == 0) return currentPos + (gridLength-1);
    else return currentPos - 0.02;    // -0.02 to slow down the barrier's seed
  }
  else {
    if (int(currentPos + 1) % gridLength == 0) return currentPos - (gridLength-1);
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
// Populate states and unmet arrays with data in CSV file
void getData() {
  for (int i = 0; i < states.length; i++) {
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    if (line != null) {
      String[] pieces = split(line, ",");
      states[i] = (String) pieces[0];
      unmet[i] = Float.parseFloat(pieces[2]);
    }
  }
} 

// Create instances of the button class that show all of the state levels
void populateStateLevels() {
  int t = 0;
  for (int i = 0; i < 13; i++){    // ~ 12 Row x 4 Columns -> Personal visual preference
    for (int j = 0; j < 4; j++){
      if (t < 49) {
        //int percent = (int) (unmet[t] * 100);
        stateLevels[t] = new Button(j*95+8, i*25 + 40, 95, 25, states[t], 4);
        stateLevels[t].stateBarrierPercent = unmet[t];
        t++;
      }
    }
  }
}

// GAME GRID //
// Draws the game board
void updateGrid() {
  int myIndex = 0;
  mySquare = new Square[gridLength*gridLength];
  
  for (int y = 0; y < gridLength; y++){
    for (int x = 0; x < gridWidth; x++){
      String myColor;
      
      // Fill the squares depending on it's 'purpose' (Red => Barrier, Green => Start, Black => End)
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
  // Checks whether reached the end or collided with a barrier
  if ((inBarrier(currentIndex) || currentIndex == endIndex) && currentIndex != start) {
    gameOn = true;
    page = 5;
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
  }
  else if (keyCode == LEFT){
    if (currentIndex % gridLength != 0) currentIndex -= 1;
  }
  else if (keyCode == UP){
    if (currentIndex > gridLength - 1) currentIndex -= gridLength;
  }
  else if (keyCode == DOWN){
    if (currentIndex < gridLength * (gridWidth - 1))  currentIndex += gridLength;
  }
  //redraw();
}  

void mousePressed() {
  playBtn.clicked(mouseX, mouseY);
  startBtn.clicked(mouseX, mouseY);
  backToLevelsBtn.clicked(mouseX, mouseY);
  if (page == 3) {
    for (int i = 0; i < stateLevels.length; i++){
      stateLevels[i].clicked(mouseX, mouseY);
    }
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

class Button{
  // Member Variables
  float x,y; //position
  float w,h; //size
  String label;
  float stateBarrierPercent;  // Only set in buttons in Page 3
  int nextPage;
  
  // Constructor
  Button(float myX, float myY, float myW, float myH, String myL, int next){
    x = myX;
    y = myY;
    w = myW;
    h = myH;
    label = myL;
    nextPage = next;
  }
  
  // Member Functions
  void display(){
    fill(255);
    rect(x, y, w, h);
    fill(0);
    textAlign(CENTER);
    textSize(14);
    text(label, x + w/2, y + (h/2));
    textAlign(LEFT);
  }

  void clicked(int mx, int my){
    if( mx > x && mx < x + w  && my > y && my < y+h){ 
      if (stateBarrierPercent != 0.0) {  // stateBarrierPercent == 0.0 for any button not associated with a state
        numBarriers = (int) (stateBarrierPercent * (gridLength*gridLength));
        state = label;
        print(numBarriers);
      }
      page = nextPage;
    }
  }
}