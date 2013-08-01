// This code uses the Processing language (http://processing.org/)
// This is a prototype of one possible interactive data display for the project I propose to develop at Hacker School.  
// The user is supposed to type in new definitions of the word 'creativity' then observe how each new definition relates to previous definitions.
// A tree structure shows that some definitiions begin in similar ways.  Multiple definitions become illustrated as branches of a tree.
// This prototype still needs some work but it seemed to be an appropriate illustration of my programming skills and something I am proud of.
// One reason chose to share this code because it was one of my first successful implementation of the concept of a class and I was proud of that.

// The class 'Unit' has parents and children
Unit u = new Unit("");
String inputWord;
PFont f;

// Variable to store text currently being typed
String typing = "";

// Variable to store saved text when return is pressed.
String saved = "";
String currentWord = "";

void setup() {
  size(1500,900);
  f = createFont("Arial",16,true);
  u.addChild("creativity");
}

void draw() {
  
  background(255);
  int indent = 25; 
  // Set the font and fill for text
  textFont(f);
  fill(0);  
  text("Click in this applet and type a one-sentence definition of creativity starting with the words 'creativity is.' \nPress return where you would normally end with a period.   \nAdd new definitions that start with the words 'creativity is' in the same manner.  \nIf you add definitions with beginnings similar to previous ones you will see an interesting tree structure develop.", indent, 40);
  text("Type and your current definition will appear below:", indent, 226);
  text(typing, indent, 250);  
  Unit X;
  for (int i = 0; i<u.currentNode.children.size();i++){
    X = (Unit) u.currentNode.children.get(i);
  }    
  pushMatrix();
  translate(100, height/2);
  u.display();
  popMatrix();
  
}

void keyPressed() {

  if (key == '\n' ) {
    currentWord = saved;
    u.integrateWord(currentWord);
    u.reset();
   typing = "";
   saved = "";
   currentWord = "";
    
  } 
  if (key == ' '){
    currentWord = saved;
    typing = typing+' ';
    inputWord = typing;
    u.integrateWord(currentWord);

    saved = "";
  } else if (key == '\b'){
    if (saved.length()>=1){
      typing = typing.substring(0, typing.length()-1);
      saved = saved.substring(0, saved.length()-1);
    }
  }
  else if (key != '\n') {
    if (key==CODED){}else{
    // 'coded' keys are ignored for now, but for any other key concatenate the String.
    // Each character typed by the user is added to the end of the String variable.
    typing = typing + key;
    saved = saved + key; 
    }
  }
}

class Unit {
  String self; ArrayList children; Unit currentNode;
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
    
    text(self, 0, 0);  
    int numSiblings = children.size();
    translate(textWidth(self),0);
    // This allows the branches to rotate to add interest to the display.
    rotate(sin(this.rand+.003*millis())*(PI/128)+(-PI/4));
    rotate((PI/4)/(numSiblings));
    for (int i = 0; i< numSiblings; i++){
      Unit C = (Unit) children.get(i);          
      pushMatrix();
       line(0,0,100,0);
       translate(100,0);
       C.display();
      popMatrix();
      rotate((PI/2)/(numSiblings));
    }  
  }

  void integrateWord(String inputWord){

    // Find out how many children the current unit has (numSiblings).  
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
        // if there is a match you can branch off off it with the next word.
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

