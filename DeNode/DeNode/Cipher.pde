// The base class for a cipher
static class Cipher{
  String input = "";
  String output = "";
  boolean encipher = true;
  //Static alphabet used for reference when deciphering.
  public static final char[] alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
  public static int letterValue(char Char){
    for (int i = 0; i < alphabet.length; i++){
      if (Character.toUpperCase(Char) == alphabet[i]){
        return i;
      }
    }
    print("ERROR: character given is not standard english alphabet");
    return 0;
  }
  
  public static char tableauLookup(char A, char B){
    int a = letterValue(A), b = letterValue(B);
    int c = (b+a)%26;
    return alphabet[c];
  }
  
/*  char reverseTableauLookup(char A, char B){
    
  }
*/  
  float relativeFreq(char letter){
    switch(Character.toUpperCase(letter)){
      case 'A': return 8.167;
      case 'B': return 1.492;
      case 'C': return 2.782;
      case 'D': return 4.253;
      case 'E': return 12.702;
      case 'F': return 2.228;
      case 'G': return 2.015;
      case 'H': return 6.094;
      case 'I': return 6.966;
      case 'J': return 0.153;
      case 'K': return 0.772;
      case 'L': return 4.025;
      case 'M': return 2.406;
      case 'N': return 6.749;
      case 'O': return 7.507;
      case 'P': return 1.929;
      case 'Q': return 0.095;
      case 'R': return 5.987;
      case 'S': return 6.327;
      case 'T': return 9.056;
      case 'U': return 2.758;
      case 'V': return 0.978;
      case 'W': return 2.360;
      case 'X': return 0.150;
      case 'Y': return 1.974;
      case 'Z': return 0.074;
      default: return 0;
    }
    
  }
}

// stores the caesar cipher function (Can probably be made into a static)
class CaesarCipher extends Cipher{
  char[] shifted_alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
  public int shiftAmount = 0;
  
  void Update(){
    if (input == null || output == null){
      return;
    }
    output = "";
    if (input.length() == 0){
      return;
    }
    shiftAmount = shiftAmount%26;
    Shift("R");
    //Swaps all the letters in the input according to the shifted alphabet
    for (int i = 0; i < input.length(); i++){
      if (Character.isLetter(input.charAt(i))){
        for(int j = 0; j < alphabet.length; j++){
          if (Character.toUpperCase(input.charAt(i)) == alphabet[j]){
            output += shifted_alphabet[j];
          }
        }
      }else{
        output += input.charAt(i);
      }
    }
  }
  //Changes the shifted alphabet by the required amount
  void Shift(String direction){
    if (direction == "L"){
      for (int i = 0; i < shifted_alphabet.length-1; i++){
        shifted_alphabet[i] = alphabet[(i+shiftAmount)%26];
      }
    }else if (direction == "R"){
      for (int i = 0; i < shifted_alphabet.length; i++){
        shifted_alphabet[i] = alphabet[(26-shiftAmount + i )%26];
      }
    }
  }
}

// Contains the functionality for a substitutions cipher
class SubstitutionCipher extends Cipher{
  Alphabet switched_alphabet;
  
  void Update(){
    output = "";
    //Switches the letters in the input with the correct ones in the switched alphabets
    if (encipher){
      for (int i = 0; i < input.length(); i++){
        if(Character.isLetter(input.charAt(i))){
          for (int j = 0; j < alphabet.length; j++){
            if (input.charAt(i) == alphabet[j]){
              output += switched_alphabet.getChar(j);
            }
          }
        }else {
          output += input.charAt(i);
        }
      }    
    }else{
      for (int i = 0; i < input.length(); i++){
        if (Character.isLetter(input.charAt(i))){
          for (int j = 0; j < switched_alphabet.alphabet.length; j++){
            if (input.charAt(i) == switched_alphabet.getChar(j)){
              output += Cipher.alphabet[j];
            }
          }
        }else{
          output += input.charAt(i);
        }
      }
    }

  }
}

class AtbashCipher extends Cipher{
  void Update(){
    output = "";
      for (int i = 0; i < input.length(); i++){
        if (Character.isLetter(input.charAt(i))){
          for (int j = 0; j < alphabet.length; j++){
            output += alphabet[25-j];
          }  
        }else{
          output += input.charAt(i);
        }
      }
  }
}

class RailFenceCipher extends Cipher{
  int Key = 1;
  
  void Update(){
    output = "";
    if (input == null){
      return;
    }
    if (Key < 1){ Key = 1;}
    input = input.replaceAll(" ", "");
    if (encipher){
      Encipher();
    }else{
      Decipher();
    }
  }
  
  void Encipher(){
    int[] depths = new int[input.length()];
    boolean down = true;
    int depth = 0;
    for (int i = 0; i < depths.length; i++){
      depths[i] = depth;
      if (down){
        depth++;
      }else{
        depth--;
      }
      if (depth == Key-1 && down){
        down = false;
      }
      if (depth == 0 && !down){
        down = true;
      }
    }
    for (int i = 0; i < Key; i++){
      for (int j = 0; j < input.length(); j++){
        if (depths[j] == i){
          output += input.charAt(j);
        }
      }
    }
  }
  
  void Decipher(){
    int[] depths = new int[input.length()];
    boolean down = true;
    int depth = 0;
    for (int i = 0; i < depths.length; i++){
      depths[i] = depth;
      if (down){
        depth++;
      }else{
        depth--;
      }
      if (depth == Key-1 && down){
        down = false;
      }
      if (depth == 0 && !down){
        down = true;
      }
    }  
    /*Marks all the points where letters should go e.g (key 3 length 10)
      -   -   -   
       - - - - - 
        -   -   
    */
    char[][] fence = new char[Key][input.length()];
    for (int i = 0; i < input.length(); i++){
      fence[depths[i]][i] = '-';
    }
    /*Fills the marks with the corresponding letters e.g (key: 3 length: 10 plaintext: HELLOWORLD ciphertext:HOLELWRDLO) 
      H   O   L
       E L W R D
        L   O
    */
    for (int i = 0; i < Key; i++){
      for (int j = 0; j < fence[i].length; j++){
        if (fence[i][j] == '-'){
          fence[i][j] = input.charAt(0);
          input = input.substring(1, input.length());
        }
      }
    }
    
    // searches each collumn for a letter which is added to the output
    for (int i = 0; i < fence[0].length; i++){
      for (int j = 0; j < fence.length; j++){
        if (fence[j][i] != 0){
          output += fence[j][i];
        }
      }
    }
  }
}

class TranspositionCipher extends Cipher{
  String Key = "";
  char pad = 'X';
  char[][] matrix;
  void Update(){
    output = "";
    input = input.replaceAll(" ", "");
    if (input.length() == 0 || Key.length() == 0){
      return;
    }
    int Width = Key.length();
    int Height = (int)Math.ceil((float)input.length() / Width);
    matrix = new char[Height][Width];
    //Puts the input into a matrix
    if (encipher){
      for (int i = 0; i < Height; i++){
        for (int j = 0; j < Width; j++){
          if (input.length() != 0){
            matrix[i][j] = input.charAt(0);
            input = input.substring(1, input.length());
          }else{
            matrix[i][j] = pad;
          }
        }
      }
    }else{
     if (input.length() % Key.length() != 0){
        for (int i = 0; i < input.length() % Key.length(); i++){
          input += pad;
        }
      }
      for (int i = 0; i < Width; i++){
        for (int j = 0; j < Height; j++){
          matrix[j][i] = input.charAt(0);
          input = input.substring(1, input.length());
        }
      }
    }
    
    
    if (encipher){    
      sortMatrix();
      for (int i = 0; i < Width; i++){
        for (int j = 0; j < Height; j++){
          output += matrix[j][i];
        }
      }    
    }else{
      unSortMatrix();
      for (int i = 0; i < Height; i++){
        for (int j = 0; j < Width; j++){
          output += matrix[i][j];
        }
      }
    }    
  }
  
  void sortMatrix(){
    boolean sorted = false;
    while (!sorted){
      boolean swapped = false;
      for (int i = 0; i < Key.length()-1; i++){
        if (int(Key.charAt(i+1)) < int(Key.charAt(i))){
          swapCollumn(i);
          swapped = true;
        }
      }
      if (swapped == false){
        sorted = true;
      }
    }
  }
  
  void unSortMatrix(){
    char[][] _matrix = new char[matrix.length][matrix[0].length];
    //Deep copy matrix
    for (int i = 0; i < matrix.length; i++){
      for(int j = 0; j < matrix[i].length; j++){
        _matrix[i][j] = matrix[i][j];
      }
    }
    String _Key = Key;
    char[][] newMatrix = new char[_matrix.length][_matrix[0].length];
    //Sort it to find the key in ascending order
    sortMatrix();
    matrix = _matrix;
    String sortedKey = Key; //AEGMNR
    Key = _Key; //GERMAN
    for (int i = 0; i < matrix[0].length; i++){
      char current = sortedKey.charAt(i);
      for (int j = 0; j < matrix[0].length; j++){
        if (current == Key.charAt(j)){
          println(i + "   " + j);
          for (int k = 0; k < matrix.length; k++){
            newMatrix[k][j] = matrix[k][i];
          }
        }
      }
    }
    matrix = newMatrix;
    
  }
  
  void swapCollumn(int index){
    //Swap the key
    char I = Key.charAt(index);
    char J = Key.charAt(index+1);
    String head = Key.substring(0, index);
    String tail = Key.substring(index+2, Key.length());
    Key = head+J+I+tail;
    
    int Height = matrix.length;
    //Swap columns
    println(" input: " + Height);
    for (int i = 0; i < Height; i++){
      char swap = matrix[i][index];
      matrix[i][index] = matrix[i][index+1];
      matrix[i][index+1] = swap;
    }
  }
}