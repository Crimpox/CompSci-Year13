import java.awt.Toolkit;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.StringSelection;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.UnsupportedFlavorException;
String getClipboard(){
  
  String text = "";
  Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();  
  try {
    return(String)clipboard.getData(DataFlavor.stringFlavor);
  } catch (UnsupportedFlavorException e){
    println("ERROR: Clipboard does not contain text");
  } catch (IOException e){
    println("ERROR: IO");
  } catch (Exception e){
    println("ERROR: Unkown");
  }
  return text;
}

void copyToClipboard(String text){
  StringSelection data = new StringSelection(text);
  Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
  clipboard.setContents(data, data);
  println("COPIED");
}