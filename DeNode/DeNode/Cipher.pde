// The base class for a cipher
class cipher{
  String input = "";
  String output = "";
  //Static alphabet used for reference when deciphering.
  char[] alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
  
}

// stores the caesar cipher function (Can probably be made into a static)
class CaesarCipher extends cipher{
  char[] shifted_alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
  public int shiftAmount = 0;
  
  void Update(){
    if (input.length() == 0){
      return;
    }
    output = "";
    Shift("L");
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
class Substitution extends cipher{
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