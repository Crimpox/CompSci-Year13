/**
Cipher Nodes
  Caesar [Done]
  Substitution [Encipher/Decipher]
  Transposition [Encipher/Decipher]
  Railfence [Encipher/Decipher]
  Polybius [Encipher/Decipher]
  Vigenere [Encipher/Decipher]

IO Nodes
  Text In [Done]
  Int In [Done]
  Text Output [Done]
  Char In [Done]
  Counter [Done]
  Alphabet [Done]
  
Conections
  Bezier [Done]
  Error handling (invalid plug e.g. string into int plug) [Done]
  
Grid
  Zoom [Done]
  Move [Done]
  
Analysis
  Frequency analysis [Done]
  Char to Value [Done]
  Random generator (Alphabet/String/Integer) [Done]
  
**/
class Connection{
  plug start;
  plug end;
  boolean Valid = false;
  Canvas canvas;
  String errorMessage = "";
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
      errorMessage = "";
      Valid = true;
      end.value = start.value;  
    }else{
      Valid = false;
    }
  }
  

  void update(){
    transferData();
    float[] startCoords = canvas.canvasToScreen(start.x + start.node.x, start.y + start.node.y);
    float[] endCoords = canvas.canvasToScreen(end.x + end.node.x, end.y + end.node.y);
    stroke(color(0, 0, 0, 120));
    noFill();
    strokeWeight(0.1 * canvas.scale);
    bezier(startCoords[0] + start.node.shadowOffset, startCoords[1] + start.node.shadowOffset, startCoords[0] + (endCoords[0] - startCoords[0])/2 + 5, startCoords[1] + 5, startCoords[0] + (endCoords[0] - startCoords[0])/2 + 5, endCoords[1] + 5, endCoords[0] + end.node.shadowOffset, endCoords[1] + 5 + end.node.shadowOffset);

    if (Valid){
      stroke(color(201));
    }else{
      stroke(color(121, 37, 35));
    }
    
    strokeWeight(0.1 * canvas.scale);

    bezier(startCoords[0], startCoords[1], startCoords[0] + (endCoords[0] - startCoords[0])/2, startCoords[1], startCoords[0] + (endCoords[0] - startCoords[0])/2, endCoords[1], endCoords[0], endCoords[1]);
    strokeWeight(1);
    stroke(0);
    
    if (reveal){
      textSize((20.0/60)*canvas.scale);
      fill(138, 157, 205);
      textAlign(CENTER);
      rectMode(CENTER);
      String value = "";
      if (start.value != null){
        value = start.value.toString();
      }else{
        value = "NULL";
      }
      rect((startCoords[0] + endCoords[0])/2, (startCoords[1]+endCoords[1])/2 , textWidth(value) + canvas.scale / 6, (30.0/60)*canvas.scale, (0.1)*canvas.scale);
      rectMode(CORNER);
      if (!Valid){
        fill(color(242, 74, 70));
      }else{
        fill(255);
      }
      text(value, (startCoords[0]+endCoords[0])/2, (startCoords[1]+endCoords[1])/2 + (10.0/60)*canvas.scale);
    }else if(errorMessage.length() > 0){
      textSize((20.0/60)*canvas.scale);
      fill(0);
      textAlign(CENTER);
      rectMode(CENTER);
      rect((startCoords[0] + endCoords[0])/2, (startCoords[1]+endCoords[1])/2 , textWidth(errorMessage)  + canvas.scale / 6, (30.0/60)*canvas.scale, (0.1)*canvas.scale);
      rectMode(CORNER);
      fill(color(242, 74, 70));
      text(errorMessage, (startCoords[0]+endCoords[0])/2, (startCoords[1]+endCoords[1])/2 + (10.0/60)*canvas.scale);
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
    rect(getX(), getY(), getWidth(), getHeight());

    //DRAWS GRID
    stroke(gridLineColor);
    strokeWeight(1);
    float xRange = (getWidth()/scale);
    float yRange = (getHeight()/scale);
    float xStart = 0 - (xRange/2) - xoffset/scale;
    float yStart = 0 - (yRange/2) - yoffset/scale;
      
    for (int i = round(xStart); i < xStart+xRange; i++){
      line(canvasToScreen(i, 0)[0], getY(), canvasToScreen(i, 0)[0], getY()+getHeight());
      line(canvasToScreen(-i, 0)[0], getY(), canvasToScreen(-i, 0)[0], getY()+getHeight());
    }
    for (int i = round(yStart); i < yStart+yRange; i++){
      line(getX(), canvasToScreen(0, i)[1], getX()+getWidth(), canvasToScreen(0, i)[1]);
      line(getX(), canvasToScreen(0, -i)[1], getX()+getWidth(), canvasToScreen(0, -i)[1]);
    }
    
    //Draws center line
    strokeWeight(3);
    if (getWidth()/2 +getX() + xoffset < getX()+getWidth() && getWidth()/2+xoffset > getX()){
      line(getWidth()/2 +getX() +xoffset, getY(), getWidth()/2 + getX() +xoffset, getY()+getHeight());    
    }
    if (getHeight()/2 + getY() +yoffset < getY()+getHeight() && getHeight()/2 + getY() +yoffset > getY()){
      line(getX(), getHeight()/2 + getY() +yoffset, getX()+getWidth(), getHeight()/2 +getY() +yoffset);
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
  int shadowOffset = 5;
  
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
    shadowOffset = (active) ? 15 : 5;
    fill(color(0, 0, 0, 120));
    noStroke();
    rect(X+shadowOffset, Y+shadowOffset, (Width) * canvas.scale, Height*canvas.scale, smoothRadius * canvas.scale);
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
        while (findConnection((plug)elements.get(i)).length > 0){
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
    textSize(fontSize * canvas.scale);
    nodeWidth = (nodeWidth > textWidth(Title)/canvas.scale) ? nodeWidth: textWidth(Title)/canvas.scale;
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
    if (output){
      fill(color(0, 0, 0, 120));
      noStroke();
      arc(canvas.canvasToScreen(x + node.x, y + node.y)[0] + node.shadowOffset, canvas.canvasToScreen(x + node.x, y + node.y)[1] + node.shadowOffset, Width * canvas.scale, Height * canvas.scale, -HALF_PI, HALF_PI);
    }

    fill(Color);
    stroke(0);
    ellipse(canvas.canvasToScreen(x + node.x, y + node.y)[0], canvas.canvasToScreen(x + node.x, y + node.y)[1], Width * canvas.scale, Height * canvas.scale);
    if (connecting){
      noFill();
      stroke(114);
      strokeWeight(5);
      bezier(canvas.canvasToScreen(x+node.x, y+node.y)[0], canvas.canvasToScreen(x+node.x, y+node.y)[1], canvas.canvasToScreen(x+node.x, y+node.y)[0] + (mouseX - canvas.canvasToScreen(x+node.x, y+node.y)[0])/2, canvas.canvasToScreen(x+node.x, y+node.y)[1], canvas.canvasToScreen(x+node.x, y+node.y)[0] + (mouseX - canvas.canvasToScreen(x+node.x, y+node.y)[0])/2, mouseY , mouseX, mouseY);
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
                if (!(((plug)_node.elements.get(j)).output) && findConnection((plug)_node.elements.get(j)).length >0){
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
    return true;
  }
  
}

class StringIN extends Node{
  plug output;
  StringIN(Canvas canvas, float X, float Y){
    
    this.canvas = canvas;
    this.Color = color(9, 33, 90); 
    this.x = X;
    this.y = Y;
    this.Width = 4;
    this.Height = 5;
    this.Title = "Input";
    output = new plug<String>(this, 0, 0, "Output");
    elements.add(output);
    output.output = true;
    elements.add(new TextInput(0, 0, 3.5, 3.2, color(38, 48, 70)));
    elements.get(1).parent = this;
    ((TextInput)elements.get(1)).setTextMode("PARAGRAPH");
    setSizings();
  }
  
  void update(){
    super.update();
    TextInput input = (TextInput)elements.get(1);
    output.value = input.getText();
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
    textIn = new plug<String>(this, 0 , 2, "Text"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof String){
          return true;
        }else{
          findConnection(textIn)[0].errorMessage = "Text should be of type String";
          return false;
        }
        
      } 
    };
    count = new plug<Integer>(this, 0, 2.5, "shift"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof Integer){
          return true;
        }else{
          findConnection(count)[0].errorMessage = "Shift should be of type integer";
          return false;
        }
      }
    };
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
  plug input;
  StringOUT(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.Color = color(9, 33, 90); 
    this.x = X;
    this.y = Y;
    this.Width = 6;
    this.Height = 5;
    this.Title = "Output";
    input = new plug<String>(this, 0, 4, "Input"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof String){
          ((Label)elements.get(1)).setTextMode("PARAGRAPH");
          ((Label)elements.get(1)).FontSize = 32;  
          return true;
        }else if (value instanceof Character){
          ((Label)elements.get(1)).setTextMode("CENTER");
          ((Label)elements.get(1)).FontSize = 48;          
          return true;
        }else if (value instanceof Integer){
          ((Label)elements.get(1)).setTextMode("LINE");
          ((Label)elements.get(1)).FontSize = 48;
          return true;
        }else if (value instanceof Alphabet){
          ((Label)elements.get(1)).setTextMode("LINE");
          ((Label)elements.get(1)).FontSize = 32;  
          return true;
        }else{
          findConnection(input)[0].errorMessage = "Input should be of type String";
          return false;
        }
      }
    };
    elements.add(input);
    elements.add(new Label(0.25, 0.8, 5.5, 3.2, color(38, 48, 70)));
    elements.get(1).parent = this;
    setSizings();
  }
  
  void update(){
    Label label = (Label)elements.get(1);
    if (input.get() != null){
      if (input.get() instanceof Character){
        label.text = Character.toString((char)input.get());
      }else if (input.get() instanceof Integer){
        label.text = Integer.toString((int)input.get());
      }else if (input.get() instanceof Alphabet){
        label.text = input.get().toString();
      }else{
        label.text = (String)input.get();      
      }
    }else{
      label.text = "";
    }
    super.update();
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
    in.CharLimit = 9;
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
    ((Label)elements.get(2)).setTextMode("CENTER");
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
  boolean Cipher = true;
  Button cipherToggle;
  plug output;
  plug input;
  plug alphabet;
  
  Substitution(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Title = "Substitution";
    output = new plug<String>(this, 0, 0, "Output");
    output.output = true;
    input = new plug<String>(this, 0, 0, "Input"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof String){
          return true;
        }else{
          findConnection(input)[0].errorMessage = "Input should be of type String";
          return false;
        }
      }
    };
    alphabet = new plug<Alphabet>(this, 0, 0, "Alphabet"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof Alphabet){
          return true;
        }else{
          findConnection(alphabet)[0].errorMessage = "Alphabet should be of type Alphabet";
          return false;
        }
      }
    };
    elements.add(output);
    elements.add(input);
    elements.add(alphabet);
    
    cipherToggle = new Button(0, 0, 1, 0.8, color(38, 48, 70)){
      @Override
      void mouseDown(){
        cipher.encipher = !cipher.encipher;
      }
      
    };
    cipherToggle.parent = this;
    cipherToggle.FontSize = 28;
    elements.add(cipherToggle);
    
    setSizings();
    cipherToggle.Width = Width-0.5;
  }
  
  void update(){
    super.update();
    if (input.value != null && alphabet.value != null){
      cipher.input = (String)input.value;
      cipher.switched_alphabet = (Alphabet)alphabet.value;
      cipher.Update();
      output.value = cipher.output;
    }
    cipherToggle.Text = (cipher.encipher) ? "Encipher" : "Decipher";
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
    alphabet = Cipher.alphabet.clone();
  }
  
  void setChar(int index, char Char){
    alphabet[index] = Char;
  }
  
  char getChar(int index){
    return alphabet[index];
  }
  
  String toString(){
    return new String(alphabet);
  }
}

class AlphabetBuilder extends Node{
  plug Output;
  AlphabetBuilder(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Title = "Alphabet";
    Output = new plug<Alphabet>(this, 0, 0, "Output"){
      boolean meetsRequirements(Object value){
        if (((TextInput)elements.get(1)).value.length() == 26){
          return true;
        }else{
          findConnection(Output)[0].errorMessage = "The alphabet must contain 26 characters";
          return false;
        }
      }
    };
    elements.add(Output);
    Output.output = true;
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

    Output.value = alphabet;
  }
}

class Transposition extends Node{
  plug textIn;
  plug Key;
  plug output;
  Button cipherToggle;
  TranspositionCipher cipher = new TranspositionCipher();
  Transposition(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Title = "Transposition";
    output = new plug<String>(this, 0, 0, "Output");
    output.output = true;
    textIn = new plug<String>(this, 0, 0, "Text"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof String){
          return true;
        }else{
          findConnection(textIn)[0].errorMessage = "Text should be of type String";
          return false;
        }
      }
    };
    Key = new plug<String>(this, 0, 0, "Keyword"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof String){
          return true;
        }else{
          findConnection(Key)[0].errorMessage = "Key should be of type integer";
          return false;
        }
      }      
    };
    cipherToggle = new Button(0, 0, 1, 0.8, color(38, 48, 70)){
      @Override
      void mouseDown(){
        cipher.encipher = !cipher.encipher;
      }
      
    };
    cipherToggle.parent = this;
    cipherToggle.FontSize = 28;
    elements.add(output);
    elements.add(textIn);
    elements.add(Key);
    elements.add(cipherToggle);
    setSizings();
    cipherToggle.Width = Width -0.5;
  }
  
  void update(){
    super.update();
    cipherToggle.Text = (cipher.encipher) ? "Encipher" : "Decipher";
    if (textIn.value != null && Key.value != null){
      cipher.input = (String)textIn.value;
      cipher.Key = (String)Key.value;
      cipher.Update();
      output.value = cipher.output;
    }else{
      output.value = "";
    }
  }
}

class RailFence extends Node{
  plug textIn;
  plug Key;
  plug output;
  Button cipherToggle;
  RailFenceCipher cipher = new RailFenceCipher();
  
  RailFence(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Title = "Railfence";
    output = new plug<String>(this, 0, 0, "Output");
    output.output = true;
    elements.add(output);
    textIn = new plug<String>(this, 0, 0, "Text"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof String){
          return true;
        }else{
          findConnection(textIn)[0].errorMessage = "Text should be of type String";
          return false;
        }
      }
    };
    elements.add(textIn);
    Key = new plug<Integer>(this, 0, 0, "Key"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof Integer){
          return true;
        }else{
          findConnection(Key)[0].errorMessage = "Key should be of type integer";
          return false;
        }
      }
    };
    elements.add(Key);
    cipherToggle = new Button(0, 0, 1, 0.8, color(38, 48, 70)){
      @Override
      void mouseDown(){
        cipher.encipher = !cipher.encipher;
      }
      
    };
    cipherToggle.parent = this;
    cipherToggle.FontSize = 28;    
    elements.add(cipherToggle);
    setSizings();
    cipherToggle.Width = Width - 0.5;
  }
  
  void update(){
    super.update();
    cipherToggle.Text = (cipher.encipher) ? "Encipher" : "Decipher";
    if (textIn.value != null && Key.value != null){
      cipher.input = (String)textIn.value;
      cipher.Key = (int)Key.value;
      cipher.Update();
      output.value = cipher.output;
    }else{
      output.value = "";
    }
  }
}


class FreqAnalysis extends Node{
  plug textIn;
  plug output;
  plug index;
  String input = "";
  
  FreqAnalysis(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Title = "Frequency Analysis";
    textIn = new plug<String>(this, 0, 0, "Text"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof String){
          return true;
        }else{
          findConnection(textIn)[0].errorMessage = "Text should be of type String";
          return false;
        }      
      }
    };
    output = new plug<Character>(this, 0, 0, "Output");
    output.output = true;
    index = new plug<Integer>(this, 0, 0, "Index"){
      @Override
      boolean meetsRequirements(Object value){
        if (value instanceof Integer){
          if ((int)value >= 0 && (int)value < 26){
            return true;
          }else{
            findConnection(index)[0].errorMessage = "Index must be between 0 and 25";
            return false;
          }
        }else{
          findConnection(index)[0].errorMessage = "Index should be of type Integer";
          return false;
        }
      }
    };
    elements.add(output);
    elements.add(textIn);
    elements.add(index);
    setSizings();
  }
  
  void update(){
    super.update();
    if (((String)textIn.value) != null){
      if (index.value == null){
        index.value = 0;
      }
      input = (String)textIn.value;
      output.value = freqAnalysis((int)index.value);
    }
  }
    
  char freqAnalysis(int index){
    int[] count = new int[26];
    for (int i = 0; i < input.length(); i++){
      if (Character.isLetter(input.charAt(i))){
        for (int j = 0; j < Cipher.alphabet.length; j++){
          if (input.charAt(i) == Cipher.alphabet[j]){
            count[j]++;
          }
        }
      }
    }
    
    boolean sorted = false;
    char[] swappable = Cipher.alphabet.clone();
    while (!sorted){
      boolean swapped = false;
      for (int i = 0; i < count.length - 1; i++){
        if (count[i] < count[i+1]){
          int swapCount = count[i];
          char swapAlph = swappable[i];
          count[i] = count[i+1];
          swappable[i] = swappable[i+1];
          count[i+1] = swapCount;
          swappable[i+1] = swapAlph;
          swapped = true;
        }
      }
      if (!swapped){
        sorted = true;
      }
    }  
    return swappable[index];
  }
}

class Polybius extends Node{
  plug Output;
  plug input;
  plug keySquare;
  plug cipherChars;
  Button cipherToggle;
  PolybiusCipher cipher = new PolybiusCipher();
  
  Polybius(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Title = "Polybius";
    Output = new plug<String>(this, 0, 0, "Output");
    Output.output = true;
    elements.add(Output);
    input = new plug<String>(this, 0, 0, "Text"){
      @Override
      boolean meetsRequirements(Object value){
        if (value instanceof String){
          return true;
        }
        if (value == null){
          return true;
        }
        findConnection(input)[0].errorMessage = "Text should be of type String";
        return false;
      }
    };
    elements.add(input);
    keySquare = new plug<String>(this, 0, 0, "Key"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof String){
          if (((String)value).length() == 25){
            return true;
          }else{
            findConnection(keySquare)[0].errorMessage = "Key square must be of length 25";
            return false;
          }
        }
        findConnection(keySquare)[0].errorMessage = "Key should be of type String";
        return false;
      }
    };
    elements.add(keySquare);
    cipherChars = new plug<String>(this, 0, 0, "Cipher Characters"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof String){
          String Value = (String)value;
          Value.replaceAll(" ", "");
          if (Value.length() == 5){
            return true;
          }
          findConnection(cipherChars)[0].errorMessage = "Cipher Characters needs to be of length 5";
          return false;
        }
        findConnection(cipherChars)[0].errorMessage = "Cipher Characters should be of type String";
        return false;
      }
    };
    elements.add(cipherChars);
    cipherToggle = new Button(0, 0, 1, 0.8, color(38, 48, 70)){
      @Override
      void mouseDown(){
        cipher.encipher = !cipher.encipher;
      }
      
    };
    cipherToggle.parent = this;
    cipherToggle.FontSize = 28;    
    elements.add(cipherToggle);
    setSizings();
    cipherToggle.Width = Width - 0.5;
  }
  
  void update(){
    super.update();
    cipherToggle.Text = (cipher.encipher) ? "Encipher" : "Decipher";
    if (input.value != null && cipherChars.value != null && keySquare.value != null){
      cipher.input = (String)input.value;
      cipher.Key = (String)keySquare.value;
      cipher.cipherChars = (String)cipherChars.value;
      cipher.Update();
      Output.value = cipher.output;
    }else{
      Output.value = "";
    }
  }
}

class Vigenere extends Node{
  plug output;
  plug textIn;
  plug Key;
  Button cipherToggle;
  VigenereCipher cipher = new VigenereCipher();
  
  Vigenere(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Title = "Vigenere";
    output = new plug<String>(this, 0, 0, "Output");
    output.output = true;
    elements.add(output);
    textIn = new plug<String>(this, 0, 0, "Text"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof String){
          return true;
        }
        findConnection(textIn)[0].errorMessage =" Text should be of type String";
        return false;
      }
    };
    elements.add(textIn);
    Key = new plug<String>(this, 0, 0, "Keyword"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof String){
          return true;
        }
        findConnection(textIn)[0].errorMessage = "Key should be of type String";
        return false;
      }
    };
    elements.add(Key);
    cipherToggle = new Button(0, 0, 1, 0.8, color(38, 48, 70)){
      @Override
      void mouseDown(){
        cipher.encipher = !cipher.encipher;
      }
      
    };
    cipherToggle.parent = this;
    cipherToggle.FontSize = 28;    
    elements.add(cipherToggle);
    setSizings();
    cipherToggle.Width = Width - 0.5;
  }
  
  void update(){
    super.update();
    cipherToggle.Text = (cipher.encipher) ? "Encipher" : "Decipher";
    if (textIn.value != null && Key.value != null){
      cipher.input = (String)textIn.value;
      cipher.Key = (String)Key.value;
      cipher.Update();
      output.value = cipher.output;
    }else{
      output.value = "";
    }
  }
}

class CharValue extends Node{
  plug input;
  plug output;
  
  CharValue(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Title = "Character Value";
    input = new plug<Character>(this, 0, 0, "Character"){
      @Override
      boolean meetsRequirements(Object value){
        if (value == null){
          return true;
        }
        if (value instanceof Character){
          return true;
        }
        findConnection(input)[0].errorMessage = "The input must be a Character";
        return false;
      }
    };
    output = new plug<Integer>(this, 0, 0, "Ouptut");
    output.output = true;
    elements.add(input);
    elements.add(output);
    setSizings();
  }
  
  void update(){
    super.update();
    if (input.value != null){
      output.value = Cipher.letterValue((char)input.value);
    }
    
  }
}

class RandomGenerator extends Node{
  plug output;
  plug StringLength;
  plug IntMin;
  plug IntMax;
  Button type;
  Button generate;
  
  String[] Types = {"String", "Alphabet", "Integer"};
  int currentType = 0;
  Object Output;
  
  RandomGenerator(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Title = "Random";
    type = new Button(0, 0, 1, 0.8, color(38, 48, 70)){
      @Override
      void mouseDown(){
        ((RandomGenerator)parent).Switch();
      }
    };
    type.parent = this;
    type.FontSize = 28;
    type.Text = Types[currentType];
    output = new plug<String>(this, 0, 0, "Output");
    output.output = true;
    elements.add(output);
    elements.add(type);
    generate = new Button(0, 0, 1, 0.8, color(38, 48, 70)){
      @Override
      void mouseDown(){
        ((RandomGenerator)parent).Generate();
      }
    };
    generate.parent = this;
    generate.FontSize = 28;
    generate.Text = "Generate";
    elements.add(generate);
    StringLength = new plug<Integer>(this, 0, 0, "Length"){
      @Override
      boolean meetsRequirements(Object value){
        if (value instanceof Integer){
          return true;
        }
        findConnection(StringLength)[0].errorMessage = "Length should be of type Integer";
        return false;
      }
    };
    elements.add(StringLength);
    IntMax = new plug<Integer>(this, 0, 0, "Max"){
      @Override
      boolean meetsRequirements(Object value){
        if (value instanceof Integer){
          return true;
        }
        findConnection(IntMax)[0].errorMessage = "Max should be of type Integer";
        return false;
      }
    };
    IntMin = new plug<Integer>(this, 0, 0, "Min"){
      @Override
      boolean meetsRequirements(Object value){
        if (value instanceof Integer){
          if ((int)value < 0){
            findConnection(IntMin)[0].errorMessage = "Minimum must be positive";
            return false;
          }else{
            return true;
          }
        }else{
          findConnection(IntMin)[0].errorMessage = "Min should be of type Integer";
          return false;
        }
      }
    };
    setSizings();
    type.Width = Width - 0.5;
    generate.Width = Width - 0.5;
    
  }
  
  void Generate(){
    switch (currentType){
      case 0:
        if (StringLength.value != null){
          Output = generateString();
        }
        break;
      case 1:
        Output = generateAlphabet();
        break;
      case 2:
        if (IntMin.value == null){
          IntMin.value = 0;
        }
        if (IntMax.value != null){
          Output = generateInt();
        }
        break;
      default:
        break;
    }
  }
  
  void Switch(){
    currentType++;
    if (currentType == Types.length){
      currentType = 0;
    }
    Output = null;
    switch (currentType){
      case 0:
        if (findConnection(IntMax).length != 0){
          connections.remove(findConnection(IntMax)[0]);
        }
        elements.remove(IntMax);
        if (findConnection(IntMin).length != 0){
          connections.remove(findConnection(IntMin)[0]);
        }
        elements.remove(IntMin);
        elements.add(StringLength);
        output = new plug<String>(this, 0, 0, "Output");
        output.output = true;
        type.Text = "String";
        
        break;
      case 1:
        if (findConnection(StringLength).length != 0){
          connections.remove(findConnection(StringLength)[0]);
        }
        elements.remove(StringLength);
        output = new plug<Alphabet>(this, 0, 0, "Output");
        output.output = true;
        type.Text = "Alphabet";
        
        break;
      case 2:
        elements.add(IntMin);
        elements.add(IntMax);
        output = new plug<Integer>(this, 0, 0, "Output");
        output.output = true;
        type.Text = "Int";
        
        break;
      default:
        break;
    }
    output = (plug)elements.get(0);
    Height = 2;
    setSizings();
    type.Width = Width - 0.5;
  }
  
  void update(){
    super.update();
    output.value = null;
    
    switch(currentType){
      case 0:
        if (Output instanceof String){
          output.value = (String)Output;
        }
        break;
      case 1:
        if (Output instanceof Alphabet){
          output.value = (Alphabet)Output;
        }
        break;
      case 2:
        if (Output instanceof Integer){
          output.value = (Integer)Output;
        }
        break;
      default:
        break;
    }
  }
  
  String generateString(){
    String alphanum = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    String alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String random = "";
    for (int i = 0; i < (int)StringLength.value; i++){
      if ((int)StringLength.value > 26){
        int index = (int)random(alphanum.length());
        random += alphanum.charAt(index);
        alphanum = alphanum.substring(0, index) + alphanum.substring(index+1, alphanum.length());
      }else{
        int index = (int)random(alpha.length());
        random += alpha.charAt(index);
        alpha = alpha.substring(0, index) + alpha.substring(index+1, alpha.length());
      }
    }
    return random;
  }
  
  Alphabet generateAlphabet(){
    Alphabet random = new Alphabet();
    String alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (int i = 0; i < 26; i++){
      int index = (int)random(0, alpha.length());
      random.setChar(i, alpha.charAt(index));
      alpha = alpha.substring(0, index) + alpha.substring(index+1, alpha.length());
    }
    return random;
  }
  
  int generateInt(){
    if (IntMin.value == IntMax.value){
      return (int)IntMin.value;
    }
    if ((int)IntMin.value > (int)IntMax.value){
      return 0;
    }
    return (int)random((int)IntMin.value, (int)IntMax.value);
  }
  
}