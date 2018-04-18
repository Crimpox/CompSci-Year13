/**
----------<BUGS>-----------
----------<TODO>-----------
Write-up
[↓ Maybes ↓]
Maybe add a save funcion. Serializables should get me some marks
---------<DONE>-----------
[Issue (SOLVED)] mousechecks not working on sub node GUI elements. mousechecks is being called but not returning correct result. possibly due to screen coords being used for the x and y of the sub node elements
Add default values for plugs based on their dimensions [Done]
Rewrite mouse checks to implement layey checking and so that a simple hover(),
released()or pressed()is sent to the GUI element and the specifics are handled GUI side [Done]
Canvas to Screen for GUI node elements
ADD FUNCTIONALITYY OF LIMITING CHARACTER INPUT ON TEXT INPUT BOXES Also maybe redo alot the entire things.
UI elements and inputs should simply be structured like a list and output should be on the right.
Simplify sub node elements so that height and width of the node is calculated by the size of the elements inside it
Make it so when drawing from a output node you can only finish on an input node and vice versa 
When nodes are selected they get moved to the top layer. (By doing this it stops the multiple node dragging)
Improve plugs so that connections can be broken
Reverse mouse check loop so it searches backwards in order to allow selection of toplayer. (The search loops have been reversed but making the loop stop calling pressed() is looking to be complicated)
Find a way to delete nodes
Nodes that are not within the canvas view are not drawn
Use a cut off mask for the canvas
Canvas movements 
New nodes are placed in the center of the canvas view. Not at [0, 0]
Connections are not deleted when nodes are
Multiple textInputs can be active at the same time
Nodes are being created odd sizes when being made at high zooms (Weirdly it's only the first node being created within that update. For some reason the rest are normal)
Fix line overflow on text Input
Add textwrap to label
Implement conditioning for connections
Encrypt and Decrypt toggle
draw Nodes on top of connections
Copy and paste
Changed bezier formula
Layout final UI
Char to value node
*/

Label banner = new Label (1250, 0, 250, 100, color(95, 39, 205));
Label credits = new Label (1250, 100, 250, 50, color(134, 96, 205));

// ------------------------------------ CIPHER --------------------------------------------
Listbox cipherBox = new Listbox(800, 50, 200, color(254, 237, 201), 50, 3){
  @Override
  public void indexSelected(int index){
    float xCenter = mainCanvas.screenToCanvas(mainCanvas.Width/2 + mainCanvas.x, 0)[0];
    float yCenter = mainCanvas.screenToCanvas(0, mainCanvas.Height/2 + mainCanvas.y)[1];
    switch(index){
      case 0:
        //Caesar
        instantiateCaesar(xCenter, yCenter);
        break;
      case 1:
        //Substitutions
        instantiateSubstitution(xCenter, yCenter);
        break;
      case 2:
        //Transposition
        instantiateTransposition(xCenter, yCenter);
        break;
      case 3:
        //Railfence
        instantiateRailfence(xCenter, yCenter);
        break;
      case 4:
        //Polybius
        instantiatePolybius(xCenter, yCenter);
        break;
      case 5:
        //Vigenere
        instantiateVigenere(xCenter, yCenter);
        break;
    }
  }
};
Label cipherLabel = new Label(750, 0, 250, 50, color(254, 202, 87));
Button cipherUp = new Button(750, 50, 50, 75, color(254, 202, 87)){
  @Override
  void onPress(){
    cipherBox.scrollUp();
  }
};
Button cipherDown = new Button(750, 125, 50, 75, color(254, 202, 87)){
  @Override
  void onPress(){
    cipherBox.scrollDown();
  }
};

// -------------------------------------- I/O ---------------------------------------------
Listbox ioBox = new Listbox(550, 50, 200, color(170, 209, 184), 50, 3){
  @Override
  public void indexSelected(int index){
    float xCenter = mainCanvas.screenToCanvas(mainCanvas.Width/2 + mainCanvas.x, 0)[0];
    float yCenter = mainCanvas.screenToCanvas(0, mainCanvas.Height/2 + mainCanvas.y)[1];
    switch(index){
      case 0:
        //Text in
        instantiateStringIN(xCenter, yCenter);
        break;
      case 1:
        //Int in
        instantiateIntIN(xCenter, yCenter);
        break;
      case 2:
        //Char in
        instantiateCharIN(xCenter, yCenter);
        break;
      case 3:
        //Alphabet in
        instantiateAlphabet(xCenter, yCenter);
        break;
      case 4:
        //Random
        instantiateRandomGenerator(xCenter, yCenter);
        break;
      case 5:
        //Text out
        instantiateStringOUT(xCenter, yCenter);
        break;
    }
  }
};
Label ioLabel = new Label(500, 0, 250, 50, color(29, 209, 161));
Button ioUp = new Button(500, 50, 50, 75, color(29, 209, 161)){
  @Override
  void onPress(){
    ioBox.scrollUp();
  }
};
Button ioDown = new Button(500, 125, 50, 75, color(29, 209, 161)){
  @Override
  void onPress(){
    ioBox.scrollDown();
  }
};

// ---------------------------------- Analysis --------------------------------------------
Listbox analysisBox = new Listbox(1050, 50, 200, color(255, 214, 214), 50, 3){

  @Override
  void indexSelected(int index){
    float xCenter = mainCanvas.screenToCanvas(mainCanvas.Width/2 + mainCanvas.x, 0)[0];
    float yCenter = mainCanvas.screenToCanvas(0, mainCanvas.Height/2 + mainCanvas.y)[1];
    switch(index){
      case 0:
        //Frequency
        instantiateFreqAnalysis(xCenter, yCenter);
        break;
      case 1:
        //Char value
        instantiateCharValue(xCenter, yCenter);
        break;
      case 2:
        //Counter
        instantiateCounter(xCenter, yCenter);
        break;
    }
  }
};
Label analysisLabel = new Label(1000, 0, 250, 50, color(255, 107, 107));
Panel analysisPanel = new Panel(1000, 50, 50, 150, color(255, 107, 107));


// --------------------------------- CANVAS CONTROLS --------------------------------------
Button clearCanvas = new Button(300, 100, 200, 100, color(84, 160, 255)){
  @Override
  void onPress(){
    connections.clear();
    nodes.Elements.clear(); 
  }
};
Button centerCanvas = new Button(300, 0, 200, 100, color(84, 160, 255)){
  @Override
  public void onPress(){
    mainCanvas.xoffset = 0;
    mainCanvas.yoffset = 0;
  }
};
Button Up = new Button(100, 0, 100, 100, color(198, 228, 255)){
  @Override
  public void onPress(){
    mainCanvas.yoffset += mainCanvas.scale;
  }
};
Button Down = new Button(100, 100, 100, 100, color(198, 228, 255)){
  @Override
  public void onPress(){
    mainCanvas.yoffset -= mainCanvas.scale;
  }
};
Button Left = new Button(0, 100, 100, 100, color(198, 228, 255)){
  @Override
  public void onPress(){
    mainCanvas.xoffset += mainCanvas.scale;
  }
};
Button Right = new Button(200, 100, 100, 100, color(198, 228, 255)){
  @Override
  public void onPress(){
    mainCanvas.xoffset -= mainCanvas.scale;
  }
};
Button Plus = new Button(0, 0, 100, 100, color(84, 160, 255)){
  @Override
  public void onPress(){
    mainCanvas.scale += 5;
  }
};
Button Minus = new Button(200, 0, 100, 100, color(84, 160, 255)){
  @Override
  public void onPress(){
    mainCanvas.scale -= 5;
  }
};

boolean reveal = false;
Label revealLabel = new Label(1250, 150, 250, 50, #AF9ECD);
Toggle revealToggle = new Toggle(1450, 155, 40, 40, #C7C0DA){
  @Override
  public void toggle(){
    reveal = !reveal;
  }
};

Canvas mainCanvas = new Canvas(0, 200, 1500, 720, #B4BFD6, #949DB0);

PFont futura;
void setup(){
  //Creates the window
  size(1500, 920);
  //Sets font to futura
  futura = loadFont("futura-heavy.vlw");
  textFont(futura, 48);

  Elements.add(mainCanvas);
  Elements.add(nodes);
  
  //Cipher
  cipherBox.options.add("Caesar");
  cipherBox.options.add("Substitution");
  cipherBox.options.add("Transposition");
  cipherBox.options.add("Railfence");
  cipherBox.options.add("Polybius");
  cipherBox.options.add("Vigenere");
  cipherBox.TextColor = #B0ABA0;
  cipherBox.HighlightColor = #FEF6E7;
  Elements.add(cipherBox);
  
  cipherLabel.text = "Ciphers";
  cipherLabel.FontSize = 32;
  cipherLabel.setTextMode("CENTER");
  Elements.add(cipherLabel);
  
  cipherUp.Text = "▲";
  cipherUp.FontSize = 24;
  cipherUp.HighlightColor = color(254, 220, 144);
  cipherUp.TextHighlightColor = color(150, 125, 67);
  Elements.add(cipherUp);
  
  cipherDown.Text = "▼";
  cipherDown.FontSize = 24;
  cipherDown.HighlightColor = color(254, 220, 144);
  cipherDown.TextHighlightColor = color(150, 125, 67);
  Elements.add(cipherDown);
  
  //IO
  ioBox.options.add("Text in");
  ioBox.options.add("Int in");
  ioBox.options.add("Character in");
  ioBox.options.add("Alphabet in");
  ioBox.options.add("Random");
  ioBox.options.add("Text out");
  ioBox.TextColor = color(118, 145, 128);
  ioBox.HighlightColor = #C7D6C7;
  Elements.add(ioBox);
  
  ioLabel.text = "I/O";
  ioLabel.FontSize = 32;
  ioLabel.setTextMode("CENTER");
  Elements.add(ioLabel);
  
  ioUp.Text = "▲";
  ioUp.FontSize = 24;
  ioUp.HighlightColor = color (127, 255, 216);
  ioUp.TextHighlightColor = color(47, 150, 122);
  Elements.add(ioUp);
  
  ioDown.Text = "▼";
  ioDown.FontSize = 24;
  ioDown.HighlightColor = color(127, 255, 216);
  ioDown.TextHighlightColor = color (47, 150, 122);
  Elements.add(ioDown);
  
  //analysis
  analysisBox.options.add("Frequency");
  analysisBox.options.add("Char value");
  analysisBox.options.add("Counter");
  analysisBox.TextColor = #8D8282;
  analysisBox.HighlightColor = #FFECF2;
  Elements.add(analysisBox);
  
  analysisLabel.text = "Analysis";
  analysisLabel.FontSize = 32;
  analysisLabel.setTextMode("CENTER");
  Elements.add(analysisLabel);
  
  Elements.add(analysisPanel);
  
  //canvas controls
  Up.Text = "▲";
  Up.FontSize = 48;
  Up.TextColor = color(131, 149, 167);
  Up.HighlightColor = #DBF0FF;
  Up.TextHighlightColor = #A2B2BD;
  Elements.add(Up);
  
  Down.Text = "▼";
  Down.FontSize = 48;
  Down.TextColor = color(131, 149, 167);
  Down.HighlightColor = #DBF0FF;
  Down.TextHighlightColor = #A2B2BD;
  Elements.add(Down);
  
  Left.Text = "◀";
  Left.FontSize = 48;
  Left.TextColor = color(131, 149, 167);
  Left.HighlightColor = #DBF0FF;
  Left.TextHighlightColor = #A2B2BD;
  Elements.add(Left);
  
  Right.Text = "▶";
  Right.FontSize = 48;
  Right.TextColor = color(131, 149, 167);
  Right.HighlightColor = #DBF0FF;
  Right.TextHighlightColor = #A2B2BD;
  Elements.add(Right);
  
  Plus.Text = "+";
  Plus.FontSize = 48;
  Plus.HighlightColor = color (136, 190, 255);
  Plus.TextHighlightColor = color(80, 112, 150);
  Elements.add(Plus);
  
  Minus.Text = "−";
  Minus.FontSize = 48;
  Minus.HighlightColor = color (136, 190, 255);
  Minus.TextHighlightColor = color(80, 112, 150);
  Elements.add(Minus);
  
  centerCanvas.Text = "Center";
  centerCanvas.HighlightColor = color (136, 190, 255);
  centerCanvas.TextHighlightColor = color(80, 112, 150);
  Elements.add(centerCanvas);
  
  clearCanvas.Text = "Clear";
  clearCanvas.HighlightColor = color (136, 190, 255);
  clearCanvas.TextHighlightColor = color(80, 112, 150);
  Elements.add(clearCanvas);
  
  revealLabel.text = " Show values";
  revealLabel.FontSize = 36;
  Elements.add(revealLabel);
  
  revealToggle.HighlightColor = color(95, 39, 205);
  Elements.add(revealToggle);  
  
  banner.text = "DeNode";
  banner.FontSize = 52;
  banner.TextColor = color(255);
  banner.setTextMode("CENTER");
  Elements.add(banner);
  
  credits.text = "By Leon Cresdee";
  credits.FontSize = 28;
  credits.setTextMode("CENTER");
  Elements.add(credits);
}

//Manages the key presses from the keyboard
//The character buffer stores all the key presses within a frame.
ArrayList<String> charBuffer = new ArrayList<String>();
void keyPressed(){
  if (keyCode == BACKSPACE){
    charBuffer.add("BACK");
  }else if(keyCode == ENTER){
    //do nothing atm
    println("\n\n");
  }else if (keyCode == DELETE){
    charBuffer.add("DEL");
  }else if (int(key) == 3){
    //Copy label or textinput data to clipboard
    charBuffer.add("COPY");
  }else if (int(key) == 22){
    //Paste clipboard to textInput
    charBuffer.add("PASTE");
  }else if (keyCode == UP){
    Up.onPress();
  }else if (keyCode == DOWN){
    Down.onPress();
  }else if (keyCode == LEFT){
    Left.onPress();
  }else if (keyCode == RIGHT){
    Right.onPress();
  }else{
    if(key != CODED){
      charBuffer.add(Character.toString(key).toUpperCase()); 
    }
  }
}

void keyReleased(){
  if (keyCode == java.awt.event.KeyEvent.VK_F1){
    saveFrame("Screenshots/DeNode-####.png");
  }
}

//Manages the mousechecks for all the mouse releases which triggers buttons and connections
void mouseReleased(){
  mouseDown = false;
  for (int i = Elements.size() - 1; i >= 0; i--){
    GUI _element = (GUI)Elements.get(i);
    if (_element instanceof GUIGroup){
      GUIGroup _Group = (GUIGroup)_element; 
      for(int j = _Group.Elements.size() - 1; j >= 0; j--){
        if(_Group.Elements.get(j).WithinBounds(mouseX, mouseY)){
          _Group.Elements.get(j).released();
        }else{
          _Group.Elements.get(j).dragRelease();
        }
      }
    }
    if(_element.WithinBounds(mouseX, mouseY)){
      _element.released();
    }else{
      _element.dragRelease();
    }
  }
}

//these to variables are how much the mouse has moved between the current frame and the last two frames
float xdisplacement;
float ydisplacement;

//This function is called each time a frame is drawn
void draw(){
  //Resets the background so the previous frame is cleared
  background(120);
  //Begins the mouseChecks.
  found = false;
  MouseChecks(Elements);
  //Draws all the UI elements.
  for (int i = 0; i < Elements.size(); i++){
    Elements.get(i).update();
  }
  //Clears the character buffer so the keys from the previous frame are not read by any class that reads from it
  charBuffer.clear();
  //Sets the mouse displacements
  xdisplacement = mouseX - pmouseX;
  ydisplacement = mouseY - pmouseY;
  for (int i = 0; i < 5; i++){
    stroke(0, 0, 0, 120 - (i * 20));
    line(0, 200 + i, 1500, 200 + i);
  }
}

//this boolean manages whether or not the mouse was down in the previous frame, this is so the function mousedown is only called on the first frame that the mouse has been pressed down
boolean mouseDown = false;
boolean found = false;
//This checks the mouse position and state and calls functions on the UI elements respectedly 
void MouseChecks(ArrayList<GUI> elements){
  for(int i = elements.size() - 1; i >= 0; i--){
    // If its a GUI group then it will branch into a seperate mouseChecks for the GUI group 
    if (elements.get(i) instanceof GUIGroup){
      GUIGroup group = (GUIGroup)elements.get(i);
      MouseChecks(group.Elements);
    }
    // If its a node then it'll branch for all the sub node GUI elements
    if (elements.get(i) instanceof Node){
      Node node = (Node)elements.get(i);
      MouseChecks(node.elements);
    }
    
    
    if(elements.get(i).WithinBounds(mouseX, mouseY) && !found){
      found = true;
      if (mousePressed == true){
        elements.get(i).pressed();
        if (!mouseDown){
          elements.get(i).mouseDown();
          mouseDown = true;
          break;
        }
      }else{
        elements.get(i).hover();
      }
    }else if (mousePressed == true){
      elements.get(i).deactivate();

    } 
  }
}
void mouseWheel(MouseEvent event){
  float amount = event.getCount();
  if(mainCanvas.WithinBounds(mouseX, mouseY)){
    if ((mainCanvas.scale - amount) <= 60 && (mainCanvas.scale - amount) >= 10){
      mainCanvas.scale -= amount;
    }
  
  }
}


// Keeps all the nodes in a gui group so that the nodes can be created and removed without disrupting the order of the other GUI elements
GUIGroup nodes = new GUIGroup(){
  @Override
  void update(){
    
    //Draws the connections seperately from 
    for (int i = 0; i < connections.size(); i++){
      connections.get(i).update();
    }
    for(int i = 0; i < Elements.size(); i++){
      Elements.get(i).update();
    } 

  }
};

// Creates a caesar cipher node
void instantiateCaesar(float x, float y){
  Caesar caesar = new Caesar(mainCanvas, x, y);
  nodes.Elements.add(caesar);
}

// Creates a String In node
void instantiateStringIN(float x, float y){
  StringIN stringIN = new StringIN(mainCanvas, x, y);
  nodes.Elements.add(stringIN);
}

// Creates a String Out node
void instantiateStringOUT(float x, float y){
  StringOUT stringOUT = new StringOUT(mainCanvas, x, y);
  nodes.Elements.add(stringOUT);
}

// Creates an Int In node
void instantiateIntIN(float x, float y){
  IntIN intIN = new IntIN(mainCanvas, x ,y);
  nodes.Elements.add(intIN);
}

// Creates a counter node
void instantiateCounter(float x, float y){
  println(43);
  Counter counter = new Counter(mainCanvas, x, y);
  nodes.Elements.add(counter);
}

//creates Character Input node
void instantiateCharIN(float x, float y){
  CharIn charIN = new CharIn(mainCanvas, x, y);
  nodes.Elements.add(charIN);
}

void instantiateAlphabet(float x, float y){
  AlphabetBuilder alphabetBuilder = new AlphabetBuilder(mainCanvas, x, y);
  nodes.Elements.add(alphabetBuilder);
}

void instantiateSubstitution(float x, float y){
  Substitution substitution = new Substitution(mainCanvas, x, y);
  nodes.Elements.add(substitution);
}

void instantitateTransposition(float x, float y){
  Transposition transposition = new Transposition(mainCanvas, x, y);
  nodes.Elements.add(transposition);
}

void instantiateRailfence(float x, float y){
  RailFence railfence = new RailFence(mainCanvas, x, y);
  nodes.Elements.add(railfence);
}

void instantiateFreqAnalysis(float x, float y){
  FreqAnalysis freqAnalysis = new FreqAnalysis(mainCanvas, x, y);
  nodes.Elements.add(freqAnalysis);
}

void instantiateRandomGenerator(float x, float y){
  RandomGenerator randomGenerator = new RandomGenerator(mainCanvas, x, y);
  nodes.Elements.add(randomGenerator);
}

void instantiatePolybius(float x, float y){
  Polybius polybius = new Polybius(mainCanvas, x, y);
  nodes.Elements.add(polybius);
}

void instantiateVigenere(float x, float y){
  Vigenere vigenere = new Vigenere(mainCanvas, x, y);
  nodes.Elements.add(vigenere);
}

void instantiateCharValue(float x, float y){
  CharValue charValue = new CharValue(mainCanvas, x, y);
  nodes.Elements.add(charValue);
}

void instantiateTransposition(float x, float y){
  Transposition transposition = new Transposition(mainCanvas, x, y);
  nodes.Elements.add(transposition);
}

void instantiateRailFence(float x, float y){
  RailFence railFence = new RailFence(mainCanvas, x, y);
  nodes.Elements.add(railFence);
}

// Caclulates the distance between two vectors
public static float distance(float[] vector1, float[] vector2){
  float xdelta = abs(vector1[0] - vector2[0]);
  float ydelta = abs(vector1[1] - vector2[1]);
  return sqrt((xdelta*xdelta) + (ydelta*ydelta));
  
}

//Stores all the connections so they're grouped together
ArrayList<Connection> connections = new ArrayList<Connection>();

Connection[] findConnection(plug Plug){
  ArrayList<Connection> found = new ArrayList<Connection>();
  for (int i = 0; i < connections.size(); i++){
    if(connections.get(i).end == Plug){
      found.add(connections.get(i));
    }
    if (connections.get(i).start == Plug){
      found.add(connections.get(i));
    }
  }
  return found.toArray(new Connection[found.size()]);
}