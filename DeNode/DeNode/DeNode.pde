Button button = new Button(1700, 0, 300, 100, color(100)){
  @Override
  public void onPress(){
    print("Overriden");
  }
};
Button centerCanvas = new Button(0, 100, 300, 100, color(100)){
  @Override
  public void onPress(){
    _canvas.xoffset = 0;
    _canvas.yoffset = 0;
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
        break;
      case 1:  index = 1;
        //substitution
        break;
      case 2:  index = 2;
        //String IN
        instantiateStringIN();
        break;
      case 3:  index = 3;
        //String OUT
        break;
      case 4:  index = 4;
        //Int IN
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
  centerCanvas.Text = "Center";
  nodeLabel.text = "Nodes";
  saveButton.Text = "Save"; 
  button.Text = "Clear";
  button.HighlightColor = color(120);
  button.PressColor = color(200);
  listBox.options.add("Caesar");
  listBox.options.add("Substitution");
  listBox.options.add("String IN");
  listBox.options.add("String OUT");
  listBox.options.add("Int IN");
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
  for (int i =0; i < Elements.size(); i++){
    GUI _element = (GUI)Elements.get(i);
    if (_element instanceof GUIGroup){
      GUIGroup _Group = (GUIGroup)_element; 
      for(int j= 0; j < _Group.Elements.size(); j++){
        if(_Group.Elements.get(j).WithinBounds(mouseX, mouseY)){
          _Group.Elements.get(j).released();
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
  MouseChecks();
  for (int i = 0; i < Elements.size(); i++){
    Elements.get(i).update();
  }
  charBuffer.clear();
  xdisplacement = mouseX - pmouseX;
  ydisplacement = mouseY - pmouseY;
}

/**
void mouseClicked(){
  print("Canvas: ");
  print(canvas.screenToCanvas(mouseX, mouseY)[0]);
  print(", ");
  print(canvas.screenToCanvas(mouseX, mouseY)[1]);
  print("\n");
  print("Screen: ");
  print(mouseX);
  print(", ");
  print(mouseY);
  print("\n");
  print("CanvasToScreen: ");
  print(canvas.canvasToScreen(canvas.screenToCanvas(mouseX, mouseY)[0],canvas.screenToCanvas(mouseX, mouseY)[1])[0]);
  print(", ");
  print(canvas.canvasToScreen(canvas.screenToCanvas(mouseX, mouseY)[0],canvas.screenToCanvas(mouseX, mouseY)[1])[1]);
  print("\n");
}
**/
void MouseChecks(){
  for (int i = 0; i < Elements.size(); i++){
    GUI _element = (GUI)Elements.get(i);
    if (_element.WithinBounds(mouseX, mouseY)){
      if (mousePressed == true){
        _element.pressed();
      }else{
        _element.hover();
      }
    }else{
      if (mousePressed == true){
        _element.deactivate();      
      }
    }
    if (_element instanceof GUIGroup){
      GUIGroup _Group = (GUIGroup)_element; 
      for(int j= 0; j < _Group.Elements.size(); j++){
        if(_Group.Elements.get(j).WithinBounds(mouseX, mouseY)){
          
          if (mousePressed == true){
            _Group.Elements.get(j).pressed();
          }else{
            _Group.Elements.get(j).hover();
          }
        }else{
          _Group.Elements.get(j).deactivate();
        }
      }
    }
  }
}


GUIGroup nodes = new GUIGroup();

void instantiateCaesar(){

}

void instantiateStringIN(){
  StringIN stringIN = new StringIN(_canvas, 0, 0);
  nodes.Elements.add(stringIN);
}

void instantiateStringOUT(){

}

void instnatiateIntIN(){
  
}


/**
PROTOTYPE 1
Working Static UI
  >Basic UI elements [Check]
  >Advanced UI elements [Ongoing]
Demonstrational Caesar node
  >Cipher logic [Check]
  >Node binding [Not done]
Instantiation of nodes
  >UI abstractions [Not done]
  >Basic Node [Not done]
Wiring between nodes
  >Bezier drawing [Not done]
  >Variable connections [Not done]
Copy and Paste functionality

**/