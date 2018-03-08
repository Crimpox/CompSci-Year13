/**
Cipher Nodes
  Caesar 
  Substitution
  Matrix
  Railspike

IO Nodes
  Text In
  Int In
  Text Output
  Char In
  In from .txt document
  
Conections
  Bezier
  Error handling (invalid plug e.g. string into int plug)
  
Grid
  Zoom
  Move
  
Analysis
  Most common letter
  
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
      rectMode(CENTER);
      rect((startCoords[0] + endCoords[0])/2, (startCoords[1]+endCoords[1])/2 , textWidth(start.value.toString())/2, 20);
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
  String Title;
  public ArrayList<plug> inputs = new ArrayList<plug>();
  public ArrayList<plug> outputs = new ArrayList<plug>();
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
    for(int i = 0; i < inputs.size(); i++){
      inputs.get(i).update();
    }
    for(int i = 0; i < outputs.size(); i++){
      outputs.get(i).update();
    }
    for(int i = 0; i < elements.size(); i++){
      elements.get(i).update();
    }

  }
  
  void dragRelease(){
    active = false;
    for(int i = 0; i < inputs.size(); i++){
      inputs.get(i).clearLine();
    }
    for(int i = 0; i < outputs.size();i++){
      outputs.get(i).clearLine();
    }
    
  }
  
}

//TODO add mouse hover highlighting
class plug<T> extends GUI{
  private T value;
  public void set(T value){ this.value = value;}
  public T get(){ return value;}
  public String label = "";
  Node node;
  Canvas canvas;

  boolean connecting = false;
  
  void setValue(T value){
    this.value = value;
  }
  
  T getValue(){
    return this.value;
  }
  
  plug(Node node, float x, float y, Canvas canvas, String label){
    this.x = x;
    this.y = y;
    this.Width = 20;
    this.Height = 20;
    this.Color = color(201);
    this.node = node;
    this.canvas = canvas;
    this.label = label;
    if (value instanceof String){
      String Value = (String)value;
      Value = "";
    } else if (value instanceof Integer){
      Integer Value = (Integer)value;
      Value = 0;
    } else if (value instanceof Character){
      Character Value = (Character)value;
      Value = 'A';
    }
  }
  
  void update(){
    fill(Color);
    ellipse(canvas.canvasToScreen(x + node.x, y + node.y)[0], canvas.canvasToScreen(x + node.x, y + node.y)[1], Width, Height);
    if (connecting){
      line(canvas.canvasToScreen(x+node.x, y+node.y)[0], canvas.canvasToScreen(x+node.x, y+node.y)[1], mouseX, mouseY);
    }
    if (WithinBounds(mouseX, mouseY)){
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
      //TODO INTEGRATE PLUGS[] in nodes class
      Node _node = (Node)nodes.Elements.get(i);
      for (int j = 0; j < _node.inputs.size(); j++){
          if (_node.inputs.get(j).WithinBounds(mouseX, mouseY) && connecting){
            print("CONNECT\n");
            if (node != _node){
              connections.add(new Connection(this, _node.inputs.get(j)));
            
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
    outputs.add(new plug<String>(this, 4, 2, canvas, ""));
    elements.add(new TextInput(0.25, 0.8, 3.5, 3.2, color(38, 48, 70)));
    elements.get(0).parent = this;
  }
  
  void update(){
    super.update();
    TextInput input = (TextInput)elements.get(0);
    outputs.get(0).value = input.getText();
  }
}

class Caesar extends Node{
  
  CaesarCipher cipher = new CaesarCipher();
  
  Caesar(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.x = X;
    this.y = Y;
    this.Width = 3;
    this.Height = 3;
    this.Title = "Caesar";
    this.Color = color(9, 33, 90);
    inputs.add(new plug<String>(this, 0, 2, canvas, "text"));
    //textIn = new plug<String>(this, 0, 2, canvas);
    inputs.add(new plug<Integer>(this, 0, 2.5, canvas, "shift"));
    inputs.get(1).value = 0;
    inputs.get(0).value = "";
    outputs.add(new plug<String>(this, 3, 2.5, canvas, ""));
  }
  
  void update(){
    super.update();
    cipher.Update();
    
    cipher.IN = (String)inputs.get(0).value;
    cipher.shiftAmount = (Integer)inputs.get(1).value;
    outputs.get(0).value = cipher.OUT;
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
    inputs.add(new plug<String>(this, 0, 4, canvas, ""));
    elements.add(new Label(0.25, 0.8, 5.5, 3.2, color(38, 48, 70)));
    elements.get(0).parent = this;
  }
  
  void update(){
    super.update();
    Label label = (Label)elements.get(0);
    if (inputs.get(0).value != null){
      label.text = (String)inputs.get(0).value;  
    }
  }
}

class IntIN extends Node{

  IntIN(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.Color = color(9, 33, 90);
    this.x = X;
    this.y = Y;
    this.Width = 2;
    this.Height = 2.5;
    this.Title = "Int";
    outputs.add(new plug<Integer>(this, 2, 1.5, canvas, ""));
  }
  
}

class TestNode extends Node{
  TestNode(Canvas canvas, float X, float Y){
    this.canvas = canvas;
    this.Color = color(9, 33, 90);
    this.x = X;
    this.y = Y;
    this.Width = 2.5;
    this.Height = 3.5;
    this.Title = "Test";
    outputs.add(new plug<Integer>(this, 2.5, 1.5, canvas, ""));
    outputs.get(0).value = 0;
    Button button = new Button(0.25, 0.8, 2, 1.7, color(38, 48, 70)){
      @Override
      void mouseDown(){
        outputs.get(0).value = (Integer)outputs.get(0).value + 1;
      }
    };
    elements.add(button);
    elements.get(0).parent = this;
  }
}