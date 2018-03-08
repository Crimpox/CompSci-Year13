/*
----------<TODO>-----------
Reverse mouse check loop so it searches backwards in order to allow selection of toplayer.
Canvas to Screen for GUI node elements
ADD FUNCTIONALITYY OF LIMITING CHARACTER INPUT ON TEXT INPUT BOXES Also maybe redo alot the entire things.
[Issue (SOLVED)] mousechecks not working on sub node GUI elements. mousechecks is being called but not returning correct result. possibly due to screen coords being used for the x and y of the sub node elements
Add default values for plugs based on their dimensions [Done]
Replace node value in plug to parent
*/
boolean debug = true;
Toggle debugToggle = new Toggle(900, 60, 50, 50, color(200)){
  @Override
  public void toggle(){
    debug = !debug;
  }
};
Label debugLabel = new Label(800, 0, 300, 60, color(100));
Button button = new Button(1700, 0, 300, 100, color(100)){
  @Override
  public void onPress(){
    instantiateCaesar(0, 0);
    instantiateStringIN(-7, -3);
    instantiateTest(-6, 3);
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

Button test = new Button(300, 100, 300, 100, color(100)){
  @Override
  public void onPress(){
    instantiateTest(0, 0);
  }
};


Button saveButton = new Button(500, 0, 300, 100, color(100));

TextInput textIn = new TextInput(0, 0, 500, 100, color(100));
//Caeser caeser = new Caeser();
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
    }
  }
};      
Button up = new Button(1650, 300, 50, 50, color(200)){@Override public void onPress(){listBox.scrollUp();}};
Button down = new Button(1650, 350, 50, 50, color(200)){@Override public void onPress(){listBox.scrollDown();}};
Canvas _canvas = new Canvas(0, 200, 1650, 800, color(52), color(197));
Label nodeLabel = new Label(1650, 200, 350, 100, color(100));
PFont futura;

void setup(){
  //Creates the window
  size(2000, 1000);
  //Sets font to futura
  futura = loadFont("futura-heavy.vlw");
  textFont(futura, 48);
  
  
  //TEST UI ELEMENTS
  Elements.add(button);
  Elements.add(textIn);
  Elements.add(listBox);
  Elements.add(up);
  Elements.add(down);
  Elements.add(_canvas);
  Elements.add(saveButton);
  Elements.add(nodeLabel);
  Elements.add(centerCanvas);
  Elements.add(nodes);
  Elements.add(test);
  Elements.add(debugToggle);
  Elements.add(debugLabel);
  debugLabel.text = "Debug";
  centerCanvas.Text = "Center";
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
  test.Text = "Test";
  test.HighlightColor = color(11, 55, 80);
}

ArrayList<String> charBuffer = new ArrayList<String>();
void keyPressed(){
  if (keyCode == BACKSPACE){
    charBuffer.add("BACK");
  }else{
    if(key != CODED){
      charBuffer.add(Character.toString(key)); 
    }
  }
  println(charBuffer);
}

/** 
[DONE]
Rewrite mouse checks to implement layey checking and so that a simple hover(),
released()or pressed()is sent to the GUI element and the specifics are handled GUI side
**/
void mouseReleased(){
  mouseDown = false;
  for (int i =0; i < Elements.size(); i++){
    GUI _element = (GUI)Elements.get(i);
    if (_element instanceof GUIGroup){
      GUIGroup _Group = (GUIGroup)_element; 
      for(int j= 0; j < _Group.Elements.size(); j++){
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


float xdisplacement;
float ydisplacement;
void draw(){
  background(255);
  MouseChecks(Elements);
  for (int i = 0; i < Elements.size(); i++){
    Elements.get(i).update();
  }
  charBuffer.clear();
  xdisplacement = mouseX - pmouseX;
  ydisplacement = mouseY - pmouseY;
  for (int i = 0; i < connections.size(); i++){
    connections.get(i).update();
  }
  
}

boolean mouseDown = false;

void MouseChecks(ArrayList<GUI> elements){
  for(int i = elements.size() - 1; i >= 0; i--){
    if (elements.get(i) instanceof GUIGroup){
      GUIGroup group = (GUIGroup)elements.get(i);
      MouseChecks(group.Elements);
    }
    if (elements.get(i) instanceof Node){
      Node node = (Node)elements.get(i);
      MouseChecks(node.elements);
    }
    if(elements.get(i).WithinBounds(mouseX, mouseY)){
      if (mousePressed == true){
        elements.get(i).pressed();
        //if (elements.get(i) instanceof TestNode){print("333\n");print(mouseDown+"\n");}
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


GUIGroup nodes = new GUIGroup();

void instantiateCaesar(float x, float y){
  Caesar caesar = new Caesar(_canvas, x, y);
  nodes.Elements.add(caesar);
}

void instantiateStringIN(float x, float y){
  StringIN stringIN = new StringIN(_canvas, x, y);
  nodes.Elements.add(stringIN);
}

void instantiateStringOUT(float x, float y){
  StringOUT stringOUT = new StringOUT(_canvas, x, y);
  nodes.Elements.add(stringOUT);
}

void instnatiateIntIN(float x, float y){
  IntIN intIN = new IntIN(_canvas, x ,y);
  nodes.Elements.add(intIN);
}

void instantiateTest(float x, float y){
  TestNode test = new TestNode(_canvas, x, y);
  nodes.Elements.add(test);
}

public static float distance(float[] vector1, float[] vector2){
  float xdelta = abs(vector1[0] - vector2[0]);
  float ydelta = abs(vector1[1] - vector2[1]);
  return sqrt((xdelta*xdelta) + (ydelta*ydelta));
  
}

ArrayList<Connection> connections = new ArrayList<Connection>();

/**
PROTOTYPE 1
Working Static UI
  >Basic UI elements [Check]
  >Advanced UI elements [Ongoing]
  >Improve text input [not done]
Demonstrational Caesar node
  >Cipher logic [Check]
  >Node binding [ongoing]
Instantiation of nodes
  >UI abstractions [ongoing]
  >Basic Node [done]
Wiring between nodes
  >Bezier drawing [done]
  >Variable connections [ongoing]
Copy and Paste functionality

**/