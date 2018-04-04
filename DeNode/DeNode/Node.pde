/**
Cipher Nodes
  Caesar [Done]
  Substitution
  Transposition
  Railspike
  Polybius
  Vigenere
  Playfair
  ADFGVX

IO Nodes
  Text In [Done]
  Int In [Done]
  Text Output [Done]
  Char In
  In from .txt document
  
Conections
  Bezier [Done]
  Error handling (invalid plug e.g. string into int plug)
  
Grid
  Zoom
  Move
  
Analysis
  Frequency analysis
  
**/
class Connection{
  plug start;
  plug end;
  
  Connection(plug Start, plug End){
    this.start = Start;
    this.end = End;
  }
  
  void transferData(){
    end.value = start.value;
  }
  
  void update(){
    noFill();
    stroke(color(201));
    strokeWeight(5);
    float[] startCoords = _canvas.canvasToScreen(start.x + start.node.x, start.y + start.node.y);
    float[] endCoords = _canvas.canvasToScreen(end.x + end.node.x, end.y + end.node.y);
    bezier(startCoords[0], startCoords[1], endCoords[0], startCoords[1], startCoords[0], endCoords[1], endCoords[0], endCoords[1]);
    strokeWeight(1);
    stroke(color(0));
    transferData();
    if (debug){
      fill(0);
      textAlign(CENTER);
      rectMode(CENTER);
      rect((startCoords[0] + endCoords[0])/2, (startCoords[1]+endCoords[1])/2 , textWidth(end.value.toString()), 20);
      rectMode(CORNER);
      fill(255);
      textSize(20);
      text(start.value.toString(), (startCoords[0]+endCoords[0])/2, (startCoords[1]+endCoords[1])/2 + 10);
    }
  }
}

class Canvas extends GUI{
  color gridLineColor;
  float scale = 60;
  float zoom = 100;
  float xoffset = 0;
  float yoffset = 0;
  ArrayList<Node> nodes = new ArrayList<Node>();
  boolean moveable = false;
  
  Canvas(float X, float Y, float Width, float Height, color GridColor, color GridLineColor){
    this.x = X;
    this.y = Y;
    this.Width = Width;
    this.Height = Height;
    this.Color = GridColor;
    this.gridLineColor = GridLineColor;
  }
  
  void update(){
    if (moveable){
      if (xdisplacement >1 || xdisplacement < -1){
        xoffset += xdisplacement;
      }
      if(ydisplacement > 1 || ydisplacement < -1){
        yoffset += ydisplacement;    
      }
    }
    fill(Color);
    rectMode(CORNER);
    rect(x, y, Width, Height);
    stroke(gridLineColor);
    strokeWeight(1);
    float xOffset = (Width%scale)/2;
    float yOffset = (Height%scale)/2;
    /*
    for (int i = 0; i < Width; i+=scale){
      line(x+i+xOffset, y, x+i+xOffset, y+Height);
    }

    for(int i = 0; i < Height; i+= scale){
      line(x, y+i+yOffset, x+Width, y+i+yOffset);
    }
    */
    
    for (int i = 0; i < (Width/2)/scale; i++){
      
      line(canvasToScreen(i, 0)[0], y, canvasToScreen(i, 0)[0], y+Height);
      line(canvasToScreen(-i, 0)[0], y, canvasToScreen(-i, 0)[0], y+Height);
    }
    for (int i = 0; i < (Height/2)/scale; i++){
      line(x, canvasToScreen(0, i)[1] + yoffset, x+Width, canvasToScreen(0, i)[1] + yoffset);
      line(x, canvasToScreen(0, -i)[1] + yoffset, x+Width, canvasToScreen(0, -i)[1] + yoffset);
    }
    
    strokeWeight(3);
    if (Width/2 +x + xoffset < x+Width && Width/2+xoffset > x){
      line(Width/2 +x +xoffset, y, Width/2 +x +xoffset, y+Height);    
    }
    if (Height/2 +y +yoffset < y+Height && Height/2 +y +yoffset > y){
      line(x, Height/2 +y +yoffset, x+Width, Height/2 +y +yoffset);
    }
    strokeWeight(1);
  }
  
  float[] canvasToScreen(float X, float Y){
    float[] Coords = new float[]{0, 0};
    //Need to factor in scale
    Coords[0] = X * scale + (x + Width/2);
    Coords[1] = Y * scale + (y + Height/2);
    return Coords;
  }
  
  float[] screenToCanvas(float X, float Y){
    float[] Coords = new float[]{0, 0};
    Coords[0] = (X - (x+Width/2))/scale;
    Coords[1] = (Y - (y+Height/2))/scale;
    return Coords;
  }
  
  void pressed(){
    if (mouseButton == CENTER){
      moveable = true;
    }
  }
  
  void released(){
    if (mouseButton == CENTER){
      moveable = false;
    }
    
  }
}

class Node extends GUI{
  Canvas canvas;
  float smoothRadius = 20;
  color headColor = color(138, 157, 205);
  float headsize = 1;
  float fontSize = 36;
  color textColor = color(218);
  color Color = color(9, 33, 90);
  String Title;
  public ArrayList<GUI> elements = new ArrayList<GUI>();
  
  public float[] getScreenCoords(){
    float[] Coords =  new float[]{0, 0};
    Coords[0] = canvas.canvasToScreen(x, y)[0];
    Coords[1] = canvas.canvasToScreen(x, y)[1];
    return Coords;
  }
  
  boolean active = false;
  void pressed(){
    if (mouseY < canvas.canvasToScreen(x, y)[1] + headsize * canvas.scale){
      active = true;
    }
  }
  
  void mouseDown(){
    if (mouseY < canvas.canvasToScreen(x, y)[1] + headsize * canvas.scale){
      active = true;
    }
  }
  
  void released(){
    active = false;
    dragRelease();
  }
  
  void move(){
    if (active){
      x += xdisplacement/canvas.scale;
      y += ydisplacement/canvas.scale;    
    }
  }
  
  void drawBox(float X, float Y){
    fill(Color);
    stroke(0);
    rect(X, Y, Width*canvas.scale, Height*canvas.scale, smoothRadius, smoothRadius, smoothRadius, smoothRadius);
    fill(headColor);
    rect(X, Y, Width*canvas.scale, headsize * canvas.scale, smoothRadius, smoothRadius, 0, 0);
    fill(Color);
    textAlign(CENTER);
    textSize(fontSize);
    text(Title, X+(Width/2)*canvas.scale, Y + (headsize)*canvas.scale - (headsize/3)*canvas.scale);
  }
  
  void update(){
    move();
    float X = canvas.canvasToScreen(x, y)[0];
    float Y = canvas.canvasToScreen(x, y)[1];
    drawBox(X, Y);
    /*
    for(int i = 0; i < inputs.size(); i++){
      inputs.get(i).update();
    }
    for(int i = 0; i < outputs.size(); i++){
      outputs.get(i).update();
    }*/
    for(int i = 0; i < elements.size(); i++){
      elements.get(i).update();
    }

  }
  
  void dragRelease(){
    active = false;
    for (int i = 0; i < elements.size(); i++){
      if (elements.get(i) instanceof plug){
        ((plug)elements.get(i)).clearLine();
      }
    }
    
  }
  //Sets the size of the box and the positions of the UI elements
  void setSizings(){
    setWidth();
    float spacing = 0.25;
    for (int i = 0; i < elements.size(); i++)
      if (i == 0){
        //If it's the first element in the node
        if (elements.get(i) instanceof plug){
          elements.get(i).y = 1.5;
          elements.get(i).x = (((plug)elements.get(i)).output) ? Width : 0;

        }else{
          elements.get(i).x = spacing;
          elements.get(i).y = 1.5;
        }
      }else{
        elements.get(i).x = spacing;
        if (elements.get(i) instanceof plug){
          elements.get(i).x = (((plug)elements.get(i)).output) ? Width : 0;
        }
        float prevHeight;
        if (elements.get(i-1) instanceof plug){
          prevHeight = spacing;
        }else{
          prevHeight = elements.get(i-1).Height;
        }

        elements.get(i).y = elements.get(i-1).y + prevHeight + spacing;
      }    
    float prevHeight = elements.get(elements.size()-1).Height;
    if (elements.get(elements.size()-1) instanceof plug){prevHeight = spacing;}
    float nodeHeight = elements.get(elements.size()-1).y + prevHeight + spacing;
    Height = (nodeHeight > Height) ? nodeHeight : Height;

  }
  
  void setWidth(){
    float nodeWidth = 2;
    for (int i = 0; i < elements.size(); i++){
      if (elements.get(i) instanceof plug){
          nodeWidth = (nodeWidth > textWidth(((plug)elements.get(i)).label)) ? nodeWidth : textWidth(((plug)elements.get(i)).label)/canvas.scale;      
      }else{
          nodeWidth = (nodeWidth > elements.get(i).Width) ? nodeWidth : elements.get(i).Width;       
      }
    }
    Width = (nodeWidth > Width) ? nodeWidth : Width;
  }
}

// The T is the dimensions of the plug. Basically what data type it receives or ouputs.
class plug<T> extends GUI{
  private T value;
  public void set(T value){ this.value = value;}
  public T get(){ return value;}
  public String label = "";
  Node node;
  Canvas canvas;
  //If it's an output then it'll go on the right side of the node.
  boolean output = false;
  boolean connecting = false;
  
  void setValue(T value){
    this.value = value;
  }
  
  T getValue(){
    return this.value;
  }
  
  plug(Node node, float x, float y, String label){
    this.x = x;
    this.y = y;
    this.Width = 20;
    this.Height = 20;
    this.Color = color(201);
    this.node = node;
    this.canvas = node.canvas;
    this.label = label;

  }
  
  void update(){
    fill(Color);
    textSize(28);
    if (output){
      textAlign(RIGHT, CENTER);
      text(label, canvas.canvasToScreen(x - 0.3 + node.x, y)[0], canvas.canvasToScreen(x, y + node.y)[1]);
    }else{
      textAlign(LEFT, CENTER);
      text(label, canvas.canvasToScreen(x + 0.3 + node.x, y)[0], canvas.canvasToScreen(x, y + node.y)[1]);
  }
    ellipse(canvas.canvasToScreen(x + node.x, y + node.y)[0], canvas.canvasToScreen(x + node.x, y + node.y)[1], Width, Height);
    if (connecting){
      noFill();
      stroke(205);
      strokeWeight(5);
      bezier(canvas.canvasToScreen(x+node.x, y+node.y)[0], canvas.canvasToScreen(x+node.x, y+node.y)[1], mouseX, canvas.canvasToScreen(x+node.x, y+node.y)[1], canvas.canvasToScreen(x+node.x, y+node.y)[0], mouseY , mouseX, mouseY);
      strokeWeight(1);
    }
    if (WithinBounds(mouseX, mouseY )){
      if (mousePressed == true){
        pressed();
      }else{
        hover();
      }
    }else{
      if (mousePressed == true){
        deactivate();      
      }
    }
    
  }
  void pressed(){
    //draw bezier
    connecting = true;
  }
  
  void released(){
    //either connect bezier or stop drawing
    connecting = false;
  }
  
  
  void clearLine(){
    for(int i = 0; i < nodes.Elements.size(); i++){
      Node _node = (Node)nodes.Elements.get(i);
      for (int j = 0; j < _node.elements.size(); j++){
          if (_node.elements.get(j).WithinBounds(mouseX, mouseY) && connecting && _node.elements.get(j) instanceof plug){
            if (node != _node){
              if (output != ((plug)_node.elements.get(j)).output){
                connections.add(new Connection(this, (plug)_node.elements.get(j)));
              }

            
            }
          }
      }
      
    }
    connecting = false;
  }
  

  
}

class StringIN extends Node{
  StringIN(Canvas canvas, float X, float Y){
    
    this.canvas = canvas;
    this.Color = color(9, 33, 90); 
    this.x = X;
    this.y = Y;
    this.Width = 4;
    this.Height = 5;
    this.Title = "Input";
    elements.add(new plug<String>(this, 0, 0, "Output"));
    ((plug)elements.get(0)).output = true;
    elements.add(new TextInput(0, 0, 3.5, 3.2, color(38, 48, 70)));
    elements.get(1).parent = this;
    setSizings();
  }
  
  void update(){
    super.update();
    TextInput input = (TextInput)elements.get(1);
    ((plug)elements.get(0)).value = input.getText();
  }
}

class Caesar extends Node{  
  CaesarCipher cipher = new CaesarCipher();
  plug textIn = new plug<String>(this, 0 , 2, "text");
  plug count = new plug<Integer>(this, 0, 2.5, "shift");
  plug output = new plug<String>(this, 3, 2.5, "output");
  Caesar(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Width = 3;
    this.Height = 3;
    this.Title = "Caesar";
    this.Color = color(9, 33, 90);
    //inputs.add(new plug<String>(this, 0, 2, canvas, "text"));
    textIn = new plug<String>(this, 0 , 2, "text");
    count = new plug<Integer>(this, 0, 2.5, "shift");
    output = new plug<String>(this, 3, 1.5, "output");
    count.setValue(0);
    elements.add(output);
    elements.add(textIn);
    output.output = true;
    elements.add(count);
  }
  
  void update(){
    super.update();
    cipher.input = (String)textIn.value;
    cipher.shiftAmount = (Integer)count.value;
    cipher.Update();
    output.value = cipher.output;
    setSizings();
  }  
}

class StringOUT extends Node{
  //Label output
  
  StringOUT(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.Color = color(9, 33, 90); 
    this.x = X;
    this.y = Y;
    this.Width = 6;
    this.Height = 5;
    this.Title = "Output";
    elements.add(new plug<String>(this, 0, 4, ""));
    elements.add(new Label(0.25, 0.8, 5.5, 3.2, color(38, 48, 70)));
    elements.get(1).parent = this;
    setSizings();
  }
  
  void update(){
    super.update();
    Label label = (Label)elements.get(1);
    if (((plug)elements.get(0)).value != null){
      label.text = (String)((plug)elements.get(0)).value;  
    }
  }
}

class IntIN extends Node{

  IntIN(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.Color = color(9, 33, 90);
    this.x = X;
    this.y = Y;
    this.Width = 2.5;
    this.Height = 3;
    this.Title = "Int";
    elements.add(new plug<Integer>(this, 2.5, 1.5, "output"));
    ((plug)elements.get(0)).output = true;
    elements.add(new TextInput(0.25, 0.8, 2, 1.2, color(38, 48, 70)));
    elements.get(1).parent = this;
    TextInput in = (TextInput)elements.get(1);
    in.setCharacterSet(new String[]{"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"});
    setSizings();
  }
  void update(){
    super.update();
    TextInput input = (TextInput)elements.get(1);
    if (!input.getText().isEmpty()){
      ((plug)elements.get(0)).value = Integer.parseInt(input.getText());   
    }else{
      ((plug)elements.get(0)).value = 0;
    }
  }
}

class Counter extends Node{
  Counter(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.Color = color(9, 33, 90);
    this.x = X;
    this.y = Y;
    this.Width = 2.5;
    this.Height = 3.5;
    this.Title = "Counter";
    elements.add(new plug<Integer>(this, 2.5, 1.5, "Output"));
    ((plug)elements.get(0)).value = 0;
    ((plug)elements.get(0)).output = true;
    Button plus = new Button(0.25, 0.8, 2, 1, color(38, 48, 70)){
      @Override
      void mouseDown(){
        ((plug)elements.get(0)).value = (Integer)((plug)elements.get(0)).value + 1;
      }
    };
    Button minus = new Button(1.25, 0.8, 2, 1, color(38, 48, 70)){
      @Override
      void mouseDown(){
        ((plug)elements.get(0)).value = (Integer)((plug)elements.get(0)).value - 1;
      } 
    };
    elements.add(plus);
    elements.get(1).parent = this;
    elements.add(new Label(0, 0, 2, 1, color(38, 48, 70)));
    elements.get(2).parent = this;
    elements.add(minus);
    elements.get(3).parent = this;
    setSizings();
  }
  
  void update(){
    super.update();
    ((Label)elements.get(2)).text = ((plug)elements.get(0)).value.toString();
  }
}

class Substitution extends Node{

}

class CharIn extends Node{
  CharIn(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Width = 1;
    this.Height = 1;
    this.Title = "Char";
    elements.add(new plug<Character>(this, 0, 0, "Output"));
    ((plug)elements.get(0)).output = true;
    elements.add(new TextInput(0, 0, 1.5, 1.2, color(38, 48, 70)));
    elements.get(1).parent = this;
    ((TextInput)elements.get(1)).CharLimit = 1;
    setSizings();
  }
  
  void update(){
    super.update();
    if (((TextInput)elements.get(1)).value.length() > 0){
      ((plug)elements.get(0)).value = ((TextInput)elements.get(1)).value.charAt(0);
    }
    

  }
}

class Alphabet {
  char[] alphabet = new char[26];
  
  Alphabet(){
    cipher temp = new cipher();
    alphabet = temp.alphabet;
  }
  
  void setChar(int index, char Char){
    alphabet[index] = Char;
  }
  
  char getChar(int index){
    return alphabet[index];
  }
}

class AlphabetBuilder extends Node{
  AlphabetBuilder(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Title = "Alphabet";
    elements.add(new plug<Alphabet>(this, 0, 0, "Output"));
    ((plug)elements.get(0)).output = true;

    for(int i = 1; i <= 26; i++){
      elements.add(new TextInput(0, 0, 0.8, 0.8, color(38, 48, 70)));
      ((TextInput)elements.get(i)).CharLimit = 1;
      ((TextInput)elements.get(i)).parent = this;    
    }
    setSizings();
    for(int i = 1; i <= 26; i++){
      elements.get(i).y -= (0.25 * (i-1));
    }
  }
  
  void update(){
    super.update();
    Alphabet alphabet = new Alphabet();
    for (int i = 1; i <= 26; i++){
      if (((TextInput)elements.get(i)).value != null && ((TextInput)elements.get(i)).value != ""){
        alphabet.setChar(i-1, ((TextInput)elements.get(i)).value.charAt(0));
      }

    }
    ((plug)elements.get(0)).value = alphabet;
  }
}

class Collumn extends Node{
  int numberOfColumns;
  int wordsPerColumn;
}