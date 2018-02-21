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
  
  Canvas(float X, float Y, float Width, float Height, color GridColor, color GridLineColor){
    this.x = X;
    this.y = Y;
    this.Width = Width;
    this.Height = Height;
    this.Color = GridColor;
    this.gridLineColor = GridLineColor;
  }
  
  void update(){
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
      line(x, canvasToScreen(0, i)[1], x+Width, canvasToScreen(0, i)[1]);
      line(x, canvasToScreen(0, -i)[1], x+Width, canvasToScreen(0, -i)[1]);
    }
    
    strokeWeight(3);
    line(Width/2 +x, y, Width/2 +x, y+Height);    
    line(x, Height/2 +y, x+Width, Height/2 +y);
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
}

class Node extends GUI{
  Canvas canvas;
  String Title;
  String[] outputs;
  String[] Inputs;
  

  
  
}