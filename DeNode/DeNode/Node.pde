/**
Cipher Nodes
  Caesar [Done]
  Substitution [Done]
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
  Char In [Done]
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
  boolean Valid = false;
  Canvas canvas;
  Connection(plug Start, plug End){
    if (Start.output != true){
      this.end = Start;
      this.start = End;
    }else{
      this.start = Start;
      this.end = End;
    }
    Start.connected = true;
    End.connected = true;
    this.canvas = end.node.canvas;
  }
  
  void transferData(){
    if (end.meetsRequirements(start.value) && start.meetsRequirements(start.value)){
      Valid = true;
      end.value = start.value;  
    }else{
      Valid = false;
    }
  }
  

  void update(){
    transferData();
    noFill();
    if (Valid){
      stroke(color(201));
    }else{
      stroke(color(121, 37, 35));
    }
    
    strokeWeight(0.1 * canvas.scale);
    float[] startCoords = canvas.canvasToScreen(start.x + start.node.x, start.y + start.node.y);
    float[] endCoords = canvas.canvasToScreen(end.x + end.node.x, end.y + end.node.y);
    bezier(startCoords[0], startCoords[1], endCoords[0], startCoords[1], startCoords[0], endCoords[1], endCoords[0], endCoords[1]);
    strokeWeight(1);
    stroke(0);

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
  float xMax = 85;
  float yMax = 40;
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

        if (xoffset/scale + (Width/scale)/2 > xMax){xoffset = xMax*scale - (Width)/2;}
        if (xoffset/scale - (Width/scale)/2 < -xMax){xoffset = -xMax*scale + (Width)/2;}

      }
      if(ydisplacement > 1 || ydisplacement < -1){
        yoffset += ydisplacement;    
        if (yoffset/scale + (Height/scale)/2 > yMax){yoffset = yMax*scale - Height/2;}
        if (yoffset/scale - (Height/scale)/2 < -yMax){yoffset = -yMax*scale + Height/2;}
      }
    }
    fill(Color);
    rectMode(CORNER);
    rect(x, y, Width, Height);

    //DRAWS GRID
    stroke(gridLineColor);
    strokeWeight(1);
    float xRange = (Width/scale);
    float yRange = (Height/scale);
    float xStart = 0 - (xRange/2) - xoffset/scale;
    float yStart = 0 - (yRange/2) - yoffset/scale;
    //print(yRange + "\n");
    
    
    for (int i = round(xStart); i < xStart+xRange; i++){
      line(canvasToScreen(i, 0)[0], y, canvasToScreen(i, 0)[0], y+Height);
      line(canvasToScreen(-i, 0)[0], y, canvasToScreen(-i, 0)[0], y+Height);
    }
    for (int i = round(yStart); i < yStart+yRange; i++){
      line(x, canvasToScreen(0, i)[1], x+Width, canvasToScreen(0, i)[1]);
      line(x, canvasToScreen(0, -i)[1], x+Width, canvasToScreen(0, -i)[1]);
    }
    
    //Draws center line
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
    Coords[0] = X * scale + (x + Width/2) + xoffset;
    Coords[1] = Y * scale + (y + Height/2) + yoffset;
    return Coords;
  }
  
  float[] screenToCanvas(float X, float Y){
    float[] Coords = new float[]{0, 0};
    Coords[0] = (X - (x+Width/2) - xoffset)/scale;
    Coords[1] = (Y - (y+Height/2) - yoffset)/scale;
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
  
  void dragRelease(){
    if (mouseButton == CENTER){
      moveable = false;
    } 
  }
  //Checks all corners of nodes to see if they need to be drawn
  boolean isNodeShowing(Node node){
    // 10 is the radius of a plug. This is accounted for as the edge of a plug may still be within the canvas
    
    if (WithinBounds(canvasToScreen(node.x, 0)[0] - 10, canvasToScreen(0, node.y)[1] - 10)){                                         //Top Left
      return true;
    }else if (WithinBounds(canvasToScreen(node.x + node.Width, 0)[0] + 10, canvasToScreen(0, node.y)[1] - 10)){                      //Top right
      return true;
    }else if (WithinBounds(canvasToScreen(node.x, 0)[0] - 10, canvasToScreen(0, node.y + node.Height)[1] + 10)){                     //Bottom Left
      return true;
    }else if (WithinBounds(canvasToScreen(node.x + node.Width, 0)[0] + 10, canvasToScreen(0, node.y + node.Height)[1] + 10)){        //Bottom Right
      return true;
    }else{
      return false;
    }
  }
  
}

class Node extends GUI{
  Canvas canvas;
  float smoothRadius = 0.3;
  color headColor = color(138, 157, 205);
  float headsize = 1;
  float fontSize = 0.6;
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
  
  void mouseDown(){
    topLayer();
    if (mouseY < canvas.canvasToScreen(x, y)[1] + headsize * canvas.scale && mouseButton == LEFT){
      active = true;
    }
  }
  
  //Moves the node to the toplayer meaning it is drawn on top
  void topLayer(){
    int index = nodes.Elements.indexOf(this);
    nodes.Elements.remove(index);
    nodes.Elements.add(this);
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
    rect(X, Y, Width*canvas.scale, Height*canvas.scale, smoothRadius * canvas.scale, smoothRadius * canvas.scale, smoothRadius * canvas.scale, smoothRadius * canvas.scale);
    fill(headColor);
    rect(X, Y, Width*canvas.scale, headsize * canvas.scale, smoothRadius * canvas.scale, smoothRadius * canvas.scale, 0, 0);
    fill(Color);
    textAlign(CENTER);
    textSize(fontSize * canvas.scale);
    text(Title, X+(Width/2)*canvas.scale, Y + (headsize)*canvas.scale - (headsize/3)*canvas.scale);
  }
  
  void update(){
    if (!canvas.isNodeShowing(this)){
      return;
    }
    move();
    if (active && charBuffer.contains("DEL")){
      Delete();
    }
    float X = canvas.canvasToScreen(x, y)[0];
    float Y = canvas.canvasToScreen(x, y)[1];
    drawBox(X, Y);
    for(int i = 0; i < elements.size(); i++){
      elements.get(i).update();
    }

  }
  
  void hover(){
    if (charBuffer.contains("DEL")){
      Delete();
    }
  }
  
  void Delete(){
    for (int i = 0; i < elements.size(); i++){
      if (elements.get(i) instanceof plug){
        while (findConnection((plug)elements.get(i)) != null){
          findConnection((plug)elements.get(i))[0].end.value = null;
          connections.remove(findConnection((plug)elements.get(i))[0]);
        }
      }
    }
    
    nodes.Elements.remove(this);  
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
          textSize(0.45 * canvas.scale);
          nodeWidth = (nodeWidth > textWidth(((plug)elements.get(i)).label)/canvas.scale) ? nodeWidth : textWidth(((plug)elements.get(i)).label)/canvas.scale;      
      }else{
          nodeWidth = (nodeWidth > elements.get(i).Width) ? nodeWidth : elements.get(i).Width;       
      }
    }
    Width = (nodeWidth > Width) ? nodeWidth + 0.5: Width;
    
  }
}

boolean inUse = false;
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
  boolean connected = false;
  
  void setValue(T value){
    this.value = value;
  }
  
  T getValue(){
    return this.value;
  }
  
  plug(Node node, float x, float y, String label){
    this.x = x;
    this.y = y;
    this.Width = 0.33;
    this.Height = 0.33;
    this.Color = color(201);
    this.node = node;
    this.canvas = node.canvas;
    this.label = label;

  }
  
  void update(){
    fill(Color);
    textSize(0.45 * canvas.scale);
    if (output){
      textAlign(RIGHT, CENTER);
      text(label, canvas.canvasToScreen(x - 0.3 + node.x, y)[0], canvas.canvasToScreen(x, y + node.y)[1]);
    }else{
      textAlign(LEFT, CENTER);
      text(label, canvas.canvasToScreen(x + 0.3 + node.x, y)[0], canvas.canvasToScreen(x, y + node.y)[1]);
  }
    stroke(0);
    ellipse(canvas.canvasToScreen(x + node.x, y + node.y)[0], canvas.canvasToScreen(x + node.x, y + node.y)[1], Width * canvas.scale, Height * canvas.scale);
    if (connecting){
      noFill();
      stroke(114);
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
  void mouseDown(){
    if (!inUse){
      if (!output && connected){
        Connection currentConnection = findConnection(this)[0];
        plug start = currentConnection.start;
        start.connecting = true;
        inUse = true;
        connections.remove(currentConnection);
      }else{
        //draw bezier
        connecting = true;
        inUse = true;
      }
    } 

  }
  
  void released(){
    //either connect bezier or stop drawing
    connecting = false;
    inUse = false;
  }
  
  
  void clearLine(){
    for(int i = 0; i < nodes.Elements.size(); i++){
      Node _node = (Node)nodes.Elements.get(i);
      for (int j = 0; j < _node.elements.size(); j++){
          if (_node.elements.get(j).WithinBounds(mouseX, mouseY) && connecting && _node.elements.get(j) instanceof plug){
            if (node != _node){
              if (output != ((plug)_node.elements.get(j)).output){
                //If the plug is already in use and an input plug then remove the current connection
                if (!(((plug)_node.elements.get(j)).output) && findConnection((plug)_node.elements.get(j)) != null){
                  connections.remove(findConnection((plug)_node.elements.get(j))[0]);
                }
                //New connection is created between current plug and plug under mouse
                connections.add(new Connection(this, (plug)_node.elements.get(j)));
                connected = true;
                ((plug)_node.elements.get(j)).connected = true;
              }

            
            }
          }
      }
      
    }
    connecting = false;
    inUse = false;
  }
  
  boolean meetsRequirements(Object value){
    println("WAY");
    return true;
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
    ((TextInput)elements.get(1)).setTextMode("PARAGRAPH");
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
    textIn = new plug<String>(this, 0 , 2, "text"){
      @Override
      boolean meetsRequirements(Object value){
        println("LAWD");
        if (value instanceof String){
          return true;
        }else{
          errorLog.add("TextIn must be plugged into some sort of text");
          return false;
        }
        
      } 
    };
    count = new plug<Integer>(this, 0, 2.5, "shift");
    output = new plug<String>(this, 3, 1.5, "output");
    count.setValue(0);
    elements.add(output);
    elements.add(textIn);
    output.output = true;
    elements.add(count);
    setSizings();    
  }
  
  void update(){
    super.update();
    cipher.input = (String)textIn.value;
    cipher.shiftAmount = (Integer)count.value;
    cipher.Update();
    output.value = cipher.output;

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
    }else{
      label.text = "";
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
  SubstitutionCipher cipher = new SubstitutionCipher();
  Substitution(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Title = "Substitution";
    elements.add(new plug<String>(this, 0, 0, "Output"));
    ((plug)elements.get(0)).output = true;
    elements.add(new plug<String>(this, 0, 0, "Input"));
    elements.add(new plug<Alphabet>(this, 0, 0, "Alphabet"));
    setSizings();
  }
  
  void update(){
    super.update();
    if (((plug)elements.get(1)).value != null && ((plug)elements.get(2)).value != null){
      cipher.input = (String)((plug)elements.get(1)).value;
      cipher.switched_alphabet = (Alphabet)((plug)elements.get(2)).value;
      cipher.Update();
      ((plug)elements.get(0)).value = cipher.output;
    }
  }
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
    alphabet = cipher.alphabet;
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
    elements.add(new TextInput(0, 0, 8, 0.8, color(38, 48, 70)));
    elements.get(1).parent = this;
    ((TextInput)elements.get(1)).CharLimit = 26;
    setSizings();

  }
  
  void update(){
    super.update();
    Alphabet alphabet = new Alphabet();
    for (int i = 0; i < ((TextInput)elements.get(1)).value.length(); i++){
      alphabet.setChar(i, ((TextInput)elements.get(1)).value.charAt(i));
    }
    ((plug)elements.get(0)).value = alphabet;
  }
}

class Collumn extends Node{
  int numberOfColumns;
  int wordsPerColumn;
}