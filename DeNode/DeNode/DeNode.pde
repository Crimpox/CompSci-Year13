/*
----------<TODO>-----------
Reverse mouse check loop so it searches backwards in order to allow selection of toplayer. (The search loops have been reversed but making the loop stop calling pressed() is looking to be complicated)   
Replace node value in plug to parent
Use a cut off mask for the canvas
Canvas movements
Change the drawing of the connections so they're not drawn on top of everything
Debating whether or not to have an alphabet data type for substitution or have the plugs built into the node
Make it so when drawing from a output node you can only finish on an input node and vice versa 

*/
/*
---------<DONE>-----------
[Issue (SOLVED)] mousechecks not working on sub node GUI elements. mousechecks is being called but not returning correct result. possibly due to screen coords being used for the x and y of the sub node elements
Add default values for plugs based on their dimensions [Done]
Rewrite mouse checks to implement layey checking and so that a simple hover(),
released()or pressed()is sent to the GUI element and the specifics are handled GUI side [Done]
Canvas to Screen for GUI node elements
ADD FUNCTIONALITYY OF LIMITING CHARACTER INPUT ON TEXT INPUT BOXES Also maybe redo alot the entire things.
UI elements and inputs should simply be structured like a list and output should be on the right.
Simplify sub node elements so that height and width of the node is calculated by the size of the elements inside it
*/
boolean debug = false;
Toggle debugToggle = new Toggle(925, 60, 50, 50, color(200)){
  @Override
  public void toggle(){
    debug = !debug;
  }
};
Button clearCanvas = new Button(600, 100, 300, 100, color(100)){
  @Override
  void onPress(){
    connections.clear();
    nodes.Elements.clear();
    
  }
};
Label debugLabel = new Label(800, 0, 300, 60, color(100));
Button button = new Button(1700, 0, 300, 100, color(100)){
  @Override
  public void onPress(){
    instantiateCaesar(0, 0);
    instantiateStringIN(-7, -3);
    instantiateCounter(-6, 3);
    instantiateStringOUT(6, -2);
  }
};
Button centerCanvas = new Button(0, 100, 300, 100, color(100)){
  @Override
  public void onPress(){
    _canvas.xoffset = 0;
    _canvas.yoffset = 0;
  }
}; 

Button counterButton = new Button(300, 100, 300, 100, color(100)){
  @Override
  public void onPress(){
    instantiateCounter(0, 0);
  }
};
TextInput intIn = new TextInput(900, 100, 100, 100, color(100));

Button saveButton = new Button(500, 0, 300, 100, color(100));

TextInput textIn = new TextInput(0, 0, 500, 100, color(100));
Listbox listBox = new Listbox(1700, 300, 300, color(100), 50, 2){
  @Override
  public void returnSelected(int index){
    switch(index){
      case 0:  index = 0;
        //caesar
        instantiateCaesar(0, 0);
        break;
      case 1:  index = 1;
        //substitution
        instantiateSubstitution(0, 0);
        break;
      case 2:  index = 2;
        //String IN
        instantiateStringIN(0, 0);
        break;
      case 3:  index = 3;
        //String OUT
        instantiateStringOUT(0, 0);
        break;
      case 4:  index = 4;
        //Int IN
        instnatiateIntIN(0, 0);
        break;
      case 5: index = 5;
        //Char IN
        instantiateCharIN(0, 0);
        break;
      case 6: index = 6;
        instantiateAlphabet(0, 0);
        break;
    }
  }
};      
Button up = new Button(1650, 300, 50, 50, color(200)){@Override public void onPress(){listBox.scrollUp();}};
Button down = new Button(1650, 350, 50, 50, color(200)){@Override public void onPress(){listBox.scrollDown();}};
Canvas _canvas = new Canvas(0, 200, 1650, 800, color(52), color(197));
Label nodeLabel = new Label(1650, 200, 350, 100, color(100));
PFont futura;
TextInput paraTest = new TextInput(1650, 600, 350, 300, color(100));
void setup(){
  //Creates the window
  size(2000, 1000);
  //Sets font to futura
  futura = loadFont("futura-heavy.vlw");
  textFont(futura, 48);
  
  //TEST UI ELEMENTS
  Elements.add(button);

  Elements.add(listBox);
  Elements.add(up);
  Elements.add(down);
  Elements.add(_canvas);
  Elements.add(saveButton);
  Elements.add(nodeLabel);
  Elements.add(centerCanvas);
  Elements.add(nodes);
  Elements.add(counterButton);
  Elements.add(debugToggle);
  Elements.add(debugLabel);
  Elements.add(clearCanvas);
  Elements.add(intIn);
  Elements.add(textIn);
  Elements.add(paraTest);
  paraTest.setTextMode("PARAGRAPH");
  intIn.setCharacterSet(new String[]{"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"});
  debugLabel.text = "Debug";
  centerCanvas.Text = "Center";
  clearCanvas.Text = "Clear";
  nodeLabel.text = "Nodes";
  saveButton.Text = "Save"; 
  button.Text = "Caesar";
  button.HighlightColor = color(120);
  button.PressColor = color(200);
  listBox.options.add("Caesar");
  listBox.options.add("Substitution");
  listBox.options.add("String IN");
  listBox.options.add("String OUT");
  listBox.options.add("Int IN");
  listBox.options.add("Char IN");
  listBox.options.add("Alphabet");
  counterButton.Text = "Counter";
}

//Manages the key presses from the keyboard
//The character buffer stores all the key presses within a frame.
ArrayList<String> charBuffer = new ArrayList<String>();
void keyPressed(){
  if (keyCode == BACKSPACE){
    charBuffer.add("BACK");
  }else if(keyCode == ENTER){
    //do nothing atm
  }else{
    if(key != CODED){
      charBuffer.add(Character.toString(key).toUpperCase()); 
    }
  }
  println(charBuffer);
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
    }
  }
}

//these to variables are how much the mouse has moved between the current frame and the last two frames
float xdisplacement;
float ydisplacement;

//This function is called each time a frame is drawn
void draw(){
  //Resets the background so the previous frame is cleared
  background(255);
  //Begins the mouseChecks.
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
  
  //Draws the connections seperately from 
  for (int i = 0; i < connections.size(); i++){
    connections.get(i).update();
  }
  
}
//this boolean manages whether or not the mouse was down in the previous frame, this is so the function mousedown is only called on the first frame that the mouse has been pressed down
boolean mouseDown = false;
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
    if(elements.get(i).WithinBounds(mouseX, mouseY)){
      if (mousePressed == true){
        elements.get(i).pressed();
        if (!mouseDown){

          elements.get(i).mouseDown();
          mouseDown = true;
        }
      }else{
        elements.get(i).hover();
      }
    }else if (mousePressed == true){
      elements.get(i).deactivate();
    } 
  }
}

// Keeps all the nodes in a gui group so that the nodes can be created and removed without disrupting the order of the other GUI elements
GUIGroup nodes = new GUIGroup();

// Creates a caesar cipher node
void instantiateCaesar(float x, float y){
  Caesar caesar = new Caesar(_canvas, x, y);
  nodes.Elements.add(caesar);
}

// Creates a String In node
void instantiateStringIN(float x, float y){
  StringIN stringIN = new StringIN(_canvas, x, y);
  nodes.Elements.add(stringIN);
}

// Creates a String Out node
void instantiateStringOUT(float x, float y){
  StringOUT stringOUT = new StringOUT(_canvas, x, y);
  nodes.Elements.add(stringOUT);
}

// Creates an Int In node
void instnatiateIntIN(float x, float y){
  IntIN intIN = new IntIN(_canvas, x ,y);
  nodes.Elements.add(intIN);
}

// Creates a counter node
void instantiateCounter(float x, float y){
  Counter counter = new Counter(_canvas, x, y);
  nodes.Elements.add(counter);
}

//creates Character Input node
void instantiateCharIN(float x, float y){
  CharIn charIN = new CharIn(_canvas, x, y);
  nodes.Elements.add(charIN);
}

void instantiateAlphabet(float x, float y){
  AlphabetBuilder alphabetBuilder = new AlphabetBuilder(_canvas, x, y);
  nodes.Elements.add(alphabetBuilder);
}

void instantiateSubstitution(float x, float y){
  Substitution substitution = new Substitution(_canvas, x, y);
  nodes.Elements.add(substitution);
}

// Caclulates the distance between two vectors
public static float distance(float[] vector1, float[] vector2){
  float xdelta = abs(vector1[0] - vector2[0]);
  float ydelta = abs(vector1[1] - vector2[1]);
  return sqrt((xdelta*xdelta) + (ydelta*ydelta));
  
}

//Stores all the connections so they're grouped together
ArrayList<Connection> connections = new ArrayList<Connection>();