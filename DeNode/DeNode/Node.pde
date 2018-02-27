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
  Error handling (invalid connection e.g. string into int connection)
  
Grid
  Zoom
  Move
  
Analysis
  Most common letter
  
**/
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
    moveable = false;
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
  String[] outputs;
  String[] Inputs;
  
  public float[] getScreenCoords(){
    float[] Coords =  new float[]{0, 0};
    Coords[0] = canvas.canvasToScreen(x, y)[0];
    Coords[1] = canvas.canvasToScreen(x, y)[1];
    return Coords;
  }
  
  boolean active = false;
  void pressed(){
    active = true;
  }
  
  void released(){
    active = false;
  }
  
  void move(){
    if (active){
      if (xdisplacement >1 || xdisplacement < -1){
        x += xdisplacement;
      }
      if(ydisplacement > 1 || ydisplacement < -1){
        y += ydisplacement;    
      }
    }
  }
  
}

class StringIN extends Node{
  //Width 120 Height 150
  float Width = 4;
  float Height = 5; 
  String Title = "Input";
  TextInput in = new TextInput(15,50, 3.5, 3.2, color(80));
  
  StringIN(Canvas canvas, float X, float Y){
    in.parent = this;
    this.canvas = canvas;
    this.Color = color(12, 33, 90); 
    this.x = X;
    this.y = Y;
  }
  void update(){
    float X = canvas.canvasToScreen(x, y)[0];
    float Y = canvas.canvasToScreen(x, y)[1];
    fill(Color);
    rect(X, Y, Width*canvas.scale, Height*canvas.scale, smoothRadius, smoothRadius, smoothRadius, smoothRadius);
    fill(headColor);
    rect(X, Y, Width*canvas.scale, headsize * canvas.scale, smoothRadius, smoothRadius, 0, 0);
    fill(textColor);
    textAlign(CENTER);
    textSize(fontSize);
    text(Title, X+(Width/2)*canvas.scale, Y + (headsize)*canvas.scale - (headsize/3)*canvas.scale);
    in.update();
  }
  
}