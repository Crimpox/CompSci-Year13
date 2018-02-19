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
  float gridSpacing = 100;
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
    rect(x, y, Width, Height);
    fill(gridLineColor);
    for (int i = 0; i < (Width-(Width%gridSpacing))/gridSpacing; i+=gridSpacing){
      line(x, y, x+Width, y);
      line(x, y, x, y+Height);
    }
  }
}

class Node extends GUI{
  Canvas canvas;
  String Title;
  String[] outputs;
  String[] Inputs;
  
  int[] canvasToScreen(int[] coords){
    int[] Coords = new int[]{0, 0};
    
    return Coords;
  }
  
  
}