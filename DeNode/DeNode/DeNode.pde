Button button = new Button(1700, 0, 300, 100, color(100)){
  @Override
  public void onPress(){
    print("Overriden");
  }
};

Button saveButton = new Button(500, 0, 300, 100, color(100));

TextInput textIn = new TextInput(0, 0, 500, 100, color(100));
//Caeser caeser = new Caeser();
Listbox listBox = new Listbox(1700, 300, 300, color(100), 50, 2){
  @Override
  public void returnSelected(int index){
    switch(index){
      case 0:
        //caesar
      case 1:
        //substitution
      case 3:
        //String IN
      case 4:
        //String OUT
      case 5:
        //Int IN
    }
  }
};      
Button up = new Button(1650, 300, 50, 50, color(200)){@Override public void onPress(){listBox.scrollUp();}};
Button down = new Button(1650, 350, 50, 50, color(200)){@Override public void onPress(){listBox.scrollDown();}};
Canvas canvas = new Canvas(0, 200, 1650, 800, color(52), color(197));
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
  Elements.add(canvas);
  Elements.add(saveButton);
  Elements.add(nodeLabel);
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
    if(_element.WithinBounds(mouseX, mouseY)){
      _element.released();
    }
  }
}

void draw(){
  background(255);
  MouseChecks();
  for (int i = 0; i < Elements.size(); i++){
    Elements.get(i).update();
  }
  charBuffer.clear();
}

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
  }
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