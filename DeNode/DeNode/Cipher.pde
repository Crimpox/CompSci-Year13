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
    println("ERROR: character given is not standard english alphabet");
    return 0;
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
      // Switches the input with ones from the standard english alphabet based on the index of the letter in the cipher alphabet
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
    //Creates an array called depths that states the of the railfence at each index of the input
    // E.G. 0123210123210
    //      0     0     0
    //       1   1 1   1
    //        2 2   2 2
    //         3     3
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
    //Adds the input to the output based be depth. So adds all the characters with depth 0 then all with depth 1
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
    // Creates an array of depths. See encipher() for more detailed explanation
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

    if (encipher){
      //Looks up the input
      //Puts the input into columns based on the key length
      // e.g DEFEND THE EAST WALL with key GERMAN
      // 
      //  Goes to: GERMAN
      //
      //           DEFEND
      //           THEEAS
      //           TWALLX     
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
      //Puts the input into columns
      //Puts the input in by columns not by rows like the enciphering.
      for (int i = 0; i < Width; i++){
        for (int j = 0; j < Height; j++){
          matrix[j][i] = input.charAt(0);
          input = input.substring(1, input.length());
        }
      }
    }
    
    
    if (encipher){  
      //Sort matrix
      sortMatrix();
      //Displays the output by reading the matrix by columns
      for (int i = 0; i < Width; i++){
        for (int j = 0; j < Height; j++){
          output += matrix[j][i];
        }
      }    
    }else{
      //Unsort matrix
      unSortMatrix();
      //Dsiplays the output by reading by rows
      for (int i = 0; i < Height; i++){
        for (int j = 0; j < Width; j++){
          output += matrix[i][j];
        }
      }
    }    
  }
  
  void sortMatrix(){
    //Uses bubblesort to sort the matrix by key
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
    //Unsort the matrix by moving collumns so the key is unsorted.
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
    //Take the heading character from the sorted key for the collumn
    //Then find the index of it in the original key
    //Set the collumn in the new matrix at the index of the original key to corresponding collumn in the sorted matrix
    for (int i = 0; i < matrix[0].length; i++){
      char current = sortedKey.charAt(i);
      for (int j = 0; j < matrix[0].length; j++){
        if (current == Key.charAt(j)){
          for (int k = 0; k < matrix.length; k++){
            newMatrix[k][j] = matrix[k][i];
          }
        }
      }
    }
    matrix = newMatrix;
    
  }
  
  //Swaps the collumn with the one to the right of it
  //Used for enciphering bubblesort
  void swapCollumn(int index){
    //Swap the key
    char I = Key.charAt(index);
    char J = Key.charAt(index+1);
    String head = Key.substring(0, index);
    String tail = Key.substring(index+2, Key.length());
    Key = head+J+I+tail;
    
    int Height = matrix.length;
    //Swap columns
    for (int i = 0; i < Height; i++){
      char swap = matrix[i][index];
      matrix[i][index] = matrix[i][index+1];
      matrix[i][index+1] = swap;
    }
  }
}

class PolybiusCipher extends Cipher{
  String Key = "";
  String cipherChars;
  String[] matrix;
  
  void Update(){
    output = "";
    if (input.length() == 0 || Key.length() == 0 || cipherChars.length() == 0){
      return;
    }
    input.replaceAll(" ", "");
    if (encipher){
      encipher();
    }else{
      decipher();
    }
  }
  
  void encipher(){
    //Replaces the missing letter with either some common substitutes or just X
    if (Key.length() == 5){
      char missing = 'A';
      for (int i = 0; i < alphabet.length; i++){
        if (Key.indexOf(alphabet[i]) == -1){
          missing = alphabet[i];
          i = alphabet.length;
        }
      }
      switch (missing){
        case 'I':
          input.replaceAll(Character.toString(missing), "J");
          break;
        case 'J':
          input.replaceAll(Character.toString(missing), "I");
          break;
        case 'Q':
          input.replaceAll(Character.toString(missing), "O");
          break;
        case 'O':
          input.replaceAll(Character.toString(missing), "Q");
          break;
        case 'X':
          input.replaceAll(Character.toString(missing), "Z");
          break;
        default:
          input.replaceAll(Character.toString(missing), "X");
          break;
      }
    }
    
    
    //Puts the key into a square matrix
    matrix = new String[cipherChars.length()];
    for (int i = 0; i < cipherChars.length(); i++){
      matrix[i] = Key.substring(i * cipherChars.length(), (i+1) * cipherChars.length());
    }
    
    for (int i = 0; i < input.length(); i++){
      output += getCharacters(input.charAt(i));
    }
  }
  
  //Searches for the input character in the keysquare and outputs two characters based on the position of that letter.
  //The first is the nth character of the key where n is the row which the character is in .
  //The second is the mth character of the key where m is the collumn which the character is in
  String getCharacters(char Char){
    String Return = "";
    for (int i = 0; i < cipherChars.length(); i++){
      for(int j = 0; j < cipherChars.length(); j++){
        if (matrix[i].charAt(j) == Char){
          Return += cipherChars.charAt(i);
          Return += cipherChars.charAt(j);
        }
      }
    }
    return Return;
  }
  
  
  void decipher(){
    matrix = new String[cipherChars.length()];
    //Matrix the Key
    for (int i = 0; i < cipherChars.length(); i++){
      matrix[i] = Key.substring(i * cipherChars.length(), (i+1) * cipherChars.length());
    }
    for (int i = 0; i < input.length(); i += 2){
      output += getLetter(input.substring(i, i+2));
    }
    
  }
  
  char getLetter(String Chars){
    int y = cipherChars.indexOf(Chars.charAt(0));
    int x = cipherChars.indexOf(Chars.charAt(1));
    
    return matrix[y].charAt(x);
  }
}

class VigenereCipher extends Cipher{
  boolean encipher;
  String Key;
  
  void Update(){
    output = "";
    if (input.length() == 0 || Key.length() == 0){
      return;
    }
    if (encipher){
      encipher();
    }else{
      decipher();
    }
    
  }
  
  void encipher(){
    for (int i = 0; i < input.length(); i++){
      output += tableauLookup(Key.charAt(i%Key.length()), input.charAt(i));
    }
  }
  
  void decipher(){
    for (int i = 0; i < input.length(); i++){
      output += reverseTableauLookup(input.charAt(i), Key.charAt(i%Key.length()));
    }
  }
  
  char tableauLookup(char A, char B){
    int a = letterValue(A), b = letterValue(B);
    int c = (b+a)%26;
    return alphabet[c];
  }
  
  //A is the cipiherText B is the key
  char reverseTableauLookup(char cipherLetter, char keyLetter){
    //int index = alphabet[letterValue(cipherLetter) - letterValue(keyLetter)];
    return alphabet[(26+letterValue(cipherLetter) - letterValue(keyLetter))%26];
  }
}
