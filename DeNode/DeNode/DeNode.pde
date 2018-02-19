Label label = new Label(100, 100, 300, 100, color(100));
Button button = new Button(100, 210, 300, 100, color(100)){
  @Override
  public void onPress(){
    print("Overriden");
  }
};

TextInput textIn = new TextInput(100, 320, 300, 100, color(100));
Toggle toggle = new Toggle(225, 430, 50, 50, color(20));
//Caeser caeser = new Caeser();
Listbox listBox = new Listbox(500, 500, 300, color(100), 50, 6);
Dropdown dropdown = new Dropdown(500, 200, 300, 75, color(200));        
Button up = new Button(450, 500, 50, 50, color(200)){@Override public void onPress(){listBox.scrollUp();}};
Button down = new Button(450, 550, 50, 50, color(200)){@Override public void onPress(){listBox.scrollDown();}};

PFont futura;

void setup(){
  //Creates the window
  size(2000, 1000);
  //Sets font to futura
  futura = loadFont("futura-heavy.vlw");
  textFont(futura, 48);
  
  
  //TEST UI ELEMENTS
  Elements.add(label);
  Elements.add(button);
  Elements.add(textIn);
  Elements.add(toggle);
  Elements.add(listBox);
  Elements.add(dropdown);
  Elements.add(up);
  Elements.add(down);
  button.Text = "Button";
  button.HighlightColor = color(255, 0, 0);
  button.PressColor = color(0, 255, 0);
  listBox.options.add("Option 1");
  listBox.options.add("Option 2");
  listBox.options.add("Option 3");
  listBox.options.add("Option 4");
  dropdown.optionNames.add("Option 1");
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