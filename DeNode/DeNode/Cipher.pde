class cipher{
  String input;
  String output;
}

class CaesarCipher extends cipher{
  char[] alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
  char[] shifted_alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
  public int shiftAmount = 0;
  public String IN = "";
  public String OUT = "";
  
  void Update(){
    print(OUT);
    if (IN.length() == 0){
      return;
    }
    OUT = "";
    shifted_alphabet = alphabet;
    for (int i = 0; i < shiftAmount; i++){
      Shift("R");
    }
    for (int i = 0; i < IN.length(); i++){
      if (Character.isLetter(IN.charAt(i))){
        for(int j = 0; j < alphabet.length; j++){
          if (IN.charAt(i) == alphabet[i]){
            OUT += shifted_alphabet[i];
          }
        }
      }else{
        OUT += IN.charAt(i);
      }
    }
  }
  
  void Shift(String direction){
    if (direction == "L"){
      char first = shifted_alphabet[0];
      for (int i = 0; i < shifted_alphabet.length-1; i++){
        shifted_alphabet[i] = shifted_alphabet[i+1];
      }
      shifted_alphabet[shifted_alphabet.length] = first;
    }else if (direction == "R"){
      char last = shifted_alphabet[shifted_alphabet.length - 1];
      for (int i = 0; i < shifted_alphabet.length-1; i++){
        shifted_alphabet[shifted_alphabet.length-(i+1)] = shifted_alphabet[shifted_alphabet.length-(i)];
      }
      shifted_alphabet[0] = last;
    }
  }
}

class Substitution extends cipher{
  char[] alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
  char[] switched_alphabet = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
  String IN = "";
  String OUT = "";
  
  void Switch (char LetterA, char LetterB){
    for (int i = 0; i < alphabet.length; i++){
      if(alphabet[i] == LetterA){
        switched_alphabet[i] = LetterB;
      }
    }
  }
  
  void Update(){
    OUT = "";
    
    for (int i = 0; i < IN.length(); i++){
      if(Character.isLetter(IN.charAt(i))){
        for (int j = 0; j < alphabet.length; j++){
          if (IN.charAt(i) == alphabet[j]){
            OUT += alphabet[j];
          }
        }
      }else {
        OUT += IN.charAt(i);
      }
    }
  }
}