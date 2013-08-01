// This code uses the Processing language (http://processing.org/)
// This is a prototype of one possible interactive data display for the project I propose to develop at Hacker School.  
// The user is supposed to type in new definitions of the word 'creativity' then observe how each new definition relates to previous definitions.
// A tree structure shows that some definitiions begin in similar ways.  Multiple definitions become illustrated as branches of a tree.
// This prototype still needs some work but it seemed to be an appropriate illustration of my programming skills and something I am proud of.
// One reason chose to share this code because it was one of my first successful implementation of the concept of a Class and I was proud of that.

// 'u' contains the data of the branching tree structure that is displayed.
Unit u = new Unit("");
PFont f;

// Variable to store text currently being typed, character by character.
String typing = "";

// Variable to store most recent word when return or space is pressed.
String savedWord = "";

void setup() {
  size(1500,900);
  f = createFont("Arial", 16, true);
  // The tree reflects series of definitions that start with the word 'creativity.'
  u.addChild("creativity");
}

void draw() {
  
  background(255);
  // Use the same indent for all instructional text.
  int indent = 25; 
  // Set the font and fill for text
  textFont(f);
  fill(0);
  // Instructions for the user.  
  text("Click in this applet and type a one-sentence definition of creativity starting with the words 'creativity is.' \nPress return where you would normally end with a period.   \nAdd new definitions that start with the words 'creativity is' in the same manner.  \nIf you add definitions with beginnings similar to previous ones you will see an interesting tree structure develop.", indent, 40);
  text("Type and your current definition will appear below:", indent, 226);
  // Display what user is typing.
  text(typing, indent, 250);
  // Display the multiple definitions in a tree structure.
  translate(100, height/2);
  u.display();
  
}

void keyPressed() {

  if (key == '\n' ) {
    // If key is 'return' add the most recent word to the tree.
    u.integrateWord(savedWord); 
    // Start a new sentence. 
    u.reset();
    typing = "";
    savedWord = "";    
  }
  
  if (key == ' '){
    typing = typing+' ';
    u.integrateWord(savedWord);
    // Make way for the next word.
    savedWord = "";
    // Allow for the use of backspace key.
  } else if (key == '\b'){
    if (savedWord.length()>=1){
      typing = typing.substring(0, typing.length()-1);
      savedWord = savedWord.substring(0, savedWord.length()-1);
    }
  }
  else if (key != '\n') {
    if (key==CODED){}else{
    // 'coded' keys are ignored for now, but for any other key concatenate the String.
    // Each character typed by the user is added to the end of the String variable.
    typing = typing + key;
    savedWord = savedWord + key; 
    }
  }
}

class Unit {
  // Unit has a word called 'self' and 'children,' a list of words that follow it.
  // 'currentNode' is used to keep track of which branch of the tree the user's sentence has currently reached. 
  String self; ArrayList children; Unit currentNode; int parendId;
  // 'rand' ensures that all the branches do not sway in the same direction at the same time.
  float rand = random(0,2*PI);
  Unit (String self_in){
    self = self_in;
    children = new ArrayList();
    currentNode = this;
  }
  void addChild(String child_self) {
    children.add(new Unit(child_self));

  }

  void display() {
    // Display the initial word, in this case an empty string.
    text(self, 0, 0);
    // Now display children and children of children.  
    int numSiblings = children.size();
    translate(textWidth(self),0);
    // This allows the branches to rotate to add interest to the display.
    rotate(sin(this.rand+.002*millis())*(PI/128)+(-PI/4));
    // The fan of branches fits within angle of PI/2
    rotate((PI/4)/(numSiblings));
    for (int i = 0; i< numSiblings; i++){
      Unit C = (Unit) children.get(i);          
      pushMatrix();
       line(0,0,100,0);
       translate(100,0);
       // Because display calls itself the whole tree is diplayed by callin u.display() on the first Unit.
       C.display();
      popMatrix();
      rotate((PI/2)/(numSiblings));
    }  
  }
  // As each word is typed it can be displayed within the larger tree.
  void integrateWord(String inputWord){

    // Find out how many children the current Unit has (numSiblings).  
    int numSiblings = currentNode.children.size();
    // If there are no children, then the input word becomes a child of the current node.
    if (numSiblings==0) {
      currentNode.addChild(inputWord);
      // We added a child to the current node and now that child becomes the relevant node.      
      currentNode = (Unit) currentNode.children.get(0);      
    }
    // If there is already a child or a number of children, compare the input with them.
    else{
      int matchDetected = 0;
      Unit X;      
      for (int i = 0; i<currentNode.children.size();i++){
        // Check all the branches for a match.
        X = (Unit) currentNode.children.get(i);
        // if there is a match child you can branch off of it with the next word.
        if (inputWord.equalsIgnoreCase(X.self)) {        
          currentNode = (Unit) currentNode.children.get(i);
          matchDetected = 1;
        }
        // Otherwise you have a new branch of the previous word.
        else if (i==(numSiblings-1) & matchDetected==0) {
          currentNode.addChild(inputWord); 
        }
      }
    }
  }

  void reset(){
    currentNode = this;
  }  
}

