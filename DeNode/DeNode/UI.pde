
class GUI {
  float x, y;
  float Width, Height;
  String ID;
  color Color;
  GUI parent = null;
  
  boolean WithinBounds(float X, float Y){
    if (this instanceof StringIN){
      //ISSUE HERE width is for some reason 0
      Node node = (Node)this;
      X = node.canvas.screenToCanvas(X, Y)[0];
      Y = node.canvas.screenToCanvas(X, Y)[1];
    }
    if (this instanceof connection){
      connection connect = (connection)this;
      X = connect.$canvas.screenToCanvas(X, Y)[0];
      Y = connect.$canvas.screenToCanvas(X, Y)[1];
    }
    
    if (X >= x && Y >= y){
      if (X <= x + Width && Y <= y + Height){
        return true;
      } else {return false;}
    } else {return false;}
  }
  
  void update(){return;}
  void hover(){return;}
  void pressed(){return;}
  void released(){return;}
  void deactivate(){return;}
}


ArrayList<GUI> Elements = new ArrayList<GUI>();
GUI[] FindByID(String ID){
  ArrayList<GUI> matchingElements = new ArrayList<GUI>();
  for (int i = 0; i < Elements.size(); i++){
    if (Elements.get(i).ID == ID){
      matchingElements.add(Elements.get(i));
    }
  }
  return matchingElements.toArray(new GUI[0]);
}

class Button extends GUI{
    color TextColor = color(0), HighlightColor = Color, TextHighlightColor = color(0), PressColor = Color, TextPressColor = color(0);
    String Text = "";
    public boolean Highlight = false, Pressed = false;
    float FontSize = 48;
    Button(float x, float y, float Width, float Height, color Color){
      this.x = x;
      this.y = y;
      this.Width = Width;
      this.Height = Height;
      this.Color = Color;
    }
    
    void released(){
      onPress();
    }
    
    void pressed(){
      Pressed = true;
      Highlight = false;
    }
    
    void hover(){
      Pressed = false;
      Highlight = true;
    }
    
    void onPress(){
      print("Pressed");
    }
    void update(){
      //Rect
      if (Highlight){
        stroke(TextColor);
        fill(HighlightColor);
      }else if (Pressed){
        stroke(TextColor);
        fill(PressColor);
      }else{
        stroke(TextColor);
        fill(Color);
      }
      rect(x, y, Width, Height);
      //Text
      if (Highlight){
        fill(TextHighlightColor);
      }else if(Pressed){
        fill(TextPressColor);
      }else{
        fill(TextColor);
      }
      textAlign(CENTER);
      textSize(FontSize);
      text(Text, x+(Width/2), y+(Height/2)+10);
      Highlight = false;
      Pressed = false;
    }
}

class TextInput extends GUI{
  color TextColor = color(0);
  String value = "";
  boolean active = false;
  float FontSize = 48;
  
  TextInput (float x, float y, float Width, float Height, color Color){
      this.x = x;
      this.y = y;
      this.Width = Width;
      this.Height = Height;
      this.Color = Color;
  }
  void pressed(){
    active = true;
  }
  void deactivate(){
    active = false;
  }
  void update(){
    float parentX = 0;
    float parentY = 0;
    float scaleWidth = Width;
    float scaleHeight = Height;
    if (parent instanceof Node){
      Node Parent = (Node)parent;
      parentX = Parent.getScreenCoords()[0];
      parentY = Parent.getScreenCoords()[1] + Parent.headsize*Parent.canvas.scale/2;
      scaleWidth *= Parent.canvas.scale;
      scaleHeight *= Parent.canvas.scale;
    }
    float X = x + parentX;
    float Y = y + parentY;
    fill(Color);
    stroke(TextColor);
    rect(X, Y, scaleWidth, scaleHeight);
    int overflow = 0;
    while(textWidth(value.substring(overflow, value.length())) > scaleWidth){
      overflow++;
    }  
    if(active){
      for(int i = 0; i < charBuffer.size(); i++){
        if (charBuffer.get(i) == "BACK" && value.length() > 0){
          value = value.substring(0, value.length()-1);
        }else if(charBuffer.get(i) != "BACK"){
            value += charBuffer.get(i);
        } 
      }
      fill(TextColor);
      textAlign(CORNER);
      if (second() % 2 == 0){
        //Draw |
        text(value.substring(overflow, value.length()) + "|", X, Y + (scaleHeight/2));
      }else{
        text(value.substring(overflow, value.length()), X, Y + (scaleHeight/2));
      }
      
    }else{
      //draw without |
      fill(TextColor);
      textAlign(CORNER);
      text(value.substring(overflow, value.length()), X, Y + (scaleHeight/2));
    }
  }
}

class Label extends GUI{
  color TextColor = color(0);
  String text = "Label";
  float FontSize = 48;
  

  
  Label (float x, float y, float Width, float Height, color Color){
    this.x = x;
    this.y = y;
    this.Width = Width;
    this.Height = Height;
    this.Color = Color;
  }
  
  void update(){
    //Box
    fill(Color);
    stroke(TextColor);
    rect(x, y, Width, Height);
    
    //Text
    fill(TextColor);
    textAlign(CENTER);
    textSize(FontSize);
    text(text, x+(Width/2), y+(Height/2)+10);

  }
}

class Toggle extends GUI{
  boolean active = false;
  color HighlightColor = #83F4FF;
  
  Toggle (float X, float Y, float Width, float Height, color Color){
    this.x = X;
    this.y = Y;
    this.Width = Width;
    this.Height = Height;
    this.Color = Color;
  }
  
  void update(){
    fill(color(100));
    stroke(HighlightColor);
    ellipse(x+(Width/2), y+(Height/2), Width, Height);
    noStroke();
    if (active){
      fill(HighlightColor);
      ellipse(x+(Width/2), y+(Height/2), Width*0.6, Height*0.6);
    }else{
      fill(60);
      ellipse(x+(Width/2), y+(Height/2), Width*0.6, Height*0.6);
    }
  }
  
  void released(){
    active = !active;
  }
}

class Dropdown extends GUI{
    int optionIndex = 0;
    color TextColor = color(100);
    color ButtonColor = color(100);
    boolean open = false;
    int options = 1;
    float OptionHeight;
    ArrayList<String> optionNames = new ArrayList<String>();
    
    Dropdown(float X, float Y, float Width, float Height, color Color){
      this.x = X;
      this.y = Y;
      this.Width = Width;
      this.Height = Height;
      this.Color = Color;
    }
    
    void update(){
      fill(Color);
      rect(x, y, Width-Height, Height);
      fill(TextColor);
      textAlign(CENTER);
      text(optionNames.get(optionIndex),x + ((Width-Height)/2), y + Height/2 + 10);
      fill(ButtonColor);
      rect(x+Width-Height, y, Height, Height);
      fill(40);
      triangle(x+Width-(Height/2), y+Height - 10, x+Width-Height + 10, y + 10, x+Width - 10 , y + 10);
      
    }
}

class Listbox extends GUI{
  ArrayList<String> options = new ArrayList<String>();
  color TextColor = color(230);
  int scrollAmount = 0;
  int optionsShowing;
  float optionHeights;
  float FontSize = 32;
  int highlightOption = -1;
  color highlightColor = color(100, 0, 200);
  color BlankColor = color(60);
  float padding = 5;
  Listbox(float X, float Y, float Width, color Color, float optionHeights, int optionsShowing){
    this.x = X;
    this.y = Y;
    this.Width = Width;
    this.Color = Color;
    this.optionHeights = optionHeights;
    this.optionsShowing = optionsShowing;
    this.Height = optionHeights * optionsShowing;
  }
  
  void scrollDown(){
    if(scrollAmount < (options.size() - optionsShowing)){
      scrollAmount++;
    }
  }
  
  void scrollUp(){
    if (scrollAmount >0){
      scrollAmount--;
    }
    
  }
  
  void released(){
    onPress();
  }
  
  void hover(){
    highlight(true);
  }
  
  void onPress(){
    returnSelected(getIndex());
  }
  int getIndex(){
    float index = ((mouseY - y) - (mouseY%optionHeights)) / optionHeights;
    int Index = round(index);
    if(Index > optionsShowing-1){Index = optionsShowing-1;}
    Index += scrollAmount;
    return Index;
  }
  
  void returnSelected(int index){
    //To be overriden on instance
    print(index);
  }
  
  void highlight(boolean highlight){
    if (highlight){
      highlightOption = getIndex() -scrollAmount;
    }else{
      highlightOption = -1;
    }
    
  }
  
  void update(){
    fill(Color);
    stroke(TextColor);
    rect(x, y, Width, optionsShowing*optionHeights);
    fill(highlightColor);
    if (highlightOption >= 0 && highlightOption < options.size()){
      rect(x, y+(optionHeights*highlightOption), Width, optionHeights);
    }
    fill(Color);
    for(int i = 1; i < optionsShowing; i++){
      line(x, y+(i*optionHeights), x+Width, y+(i*optionHeights));
    }
    textAlign(CENTER);
    textSize(FontSize);
    for(int i = 0; i < optionsShowing; i++){
      if (i < options.size()){
        fill(TextColor);
        text(options.get(i+scrollAmount), x+(Width/2), y+(i*(optionHeights)+optionHeights/1.5));
      }else{
        fill(BlankColor);
        rect(x + padding, y+(optionHeights*i)+padding, Width - 2*padding, optionHeights - 2*padding);
      }

    }
    fill(TextColor);
    stroke(Color);
    highlight(false);
  }  
}

class Panel extends GUI{
  void update(){
    fill(Color);
    noStroke();
    rect(x, y, Width, Height);
  }
}

class Image extends GUI{
  PImage image;
  Image(float x, float y, float Width, float Height){
    this.x = x;
    this.y = y;
    this.Width = Width;
    this.Height = Height;
  }
  void update(){
    tint(Color);
    image(image, x, y, Width, Height);
  }
}

class GUIGroup extends GUI{
  ArrayList<GUI> Elements = new ArrayList<GUI>();
  void update(){
    for(int i = 0; i < Elements.size(); i++){
      Elements.get(i).update();
    }
  }
  
  boolean WithinBounds(float X, float Y){
    return false;
  }
}