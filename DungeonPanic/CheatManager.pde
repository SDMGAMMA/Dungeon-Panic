class CheatManager {

  final String oneMilTime = "38=38=40=40=37=39=37=39=66=65=";
  final String doubleScore = "38=40=40=40=37=39=37=39=66=65=";
  final String namesEastereggPart1 = "65=65=65=66=66=66=65=65=65=38=";

  ArrayList<String> last10Keys = new ArrayList<String>();

  void keyPressed() {

    //UP = 38
    //DOWN = 40
    //LEFT = 37
    //RIGHT = 39
    //A = 65
    //B = 66

    if ((keyCode >= 37 && keyCode <= 40) || keyCode == 65 || keyCode == 66 ) {//UP
      if (last10Keys.size() >= 10) {
        last10Keys.remove(0);
      }
      last10Keys.add("" + keyCode + "=");

      if (listToString(last10Keys).contains(oneMilTime)) {
        DungeonPanic.gameManager.getCurrentScene().timeSpent = 1000000;
      }

      if (listToString(last10Keys).contains(doubleScore)) {
        for (Treasure treasure : DungeonPanic.gameManager.getCurrentScene().treasures) {
          treasure.scoreAdd = treasure.scoreAdd*2;
        }
      }
    }
  }
  String listToString(ArrayList<String> strings) {
    String ss = "";
    while (ss == "") {
      for (String s : strings) {        
        ss = ss + s;
      }
    }
    return ss;
  }
}
