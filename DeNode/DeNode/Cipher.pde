// The base class for a cipher
class cipher{
  String input = "";
  String output = "";
  //Static alphabet used for reference when deciphering.
  char[] alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
  int letterValue(char Char){
    for (int i = 0; i < alphabet.length; i++){
      if (Character.toUpperCase(Char) == alphabet[i]){
        return i;
      }
    }
    print("ERROR: character given is not standard english alphabet");
    return 0;
  }
  
  char tableauLookup(char A, char B){
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
      case 'i': return 6.966;
      case 'j': return 0.153;
      case 'k': return 0.772;
      case 'l': return 4.025;
      case 'm': return 2.406;
      case 'n': return 6.749;
      case 'o': return 7.507;
      case 'p': return 1.929;
      case 'q': return 0.095;
      case 'r': return 5.987;
      case 's': return 6.327;
      case 't': return 9.056;
      case 'u': return 2.758;
      case 'v': return 0.978;
      case 'w': return 2.360;
      case 'x': return 0.150;
      case 'y': return 1.974;
      case 'z': return 0.074;
      default: return 0;
    }
    
  }
}

// stores the caesar cipher function (Can probably be made into a static)
class CaesarCipher extends cipher{
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
class SubstitutionCipher extends cipher{
  char[] switched_alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
  //Swaps letter A with letter B in the switched alphabet.
  void Switch (char LetterA, char LetterB){
    for (int i = 0; i < alphabet.length; i++){
      if(alphabet[i] == LetterA){
        switched_alphabet[i] = LetterB;
      }
    }
  }
  
  void Update(){
    output = "";
    //Switches the letters in the input with the correct ones in the switched alphabets
    for (int i = 0; i < input.length(); i++){
      if(Character.isLetter(input.charAt(i))){
        for (int j = 0; j < alphabet.length; j++){
          if (input.charAt(i) == alphabet[j]){
            output += alphabet[j];
          }
        }
      }else {
        output += input.charAt(i);
      }
    }
  }
}

class AtbashCipher extends cipher{
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

class RailFenceCipher extends cipher{
  int Key = 0;
  
  void Update(){
    output = "";
  }
}