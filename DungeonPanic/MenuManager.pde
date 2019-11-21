import java.io.File;
public class MenuManager {

  File backgroundsFolder;
  File buttonsFolder;
  String [] backgroundsFilenames;
  ArrayList<PImage> Backgrounds;
  MenuState currentMenuState = MenuState.MAINMENU;

  PVector menuPosition = new PVector(width/2, height/1.5);
  PFont score; 

  int buttonDistance = 150;
  int activeButton = 0;
  int textDistance = 35;
  int activeButtonPosition;

  boolean levelPast = false; // Decides if you can go to the next level.

  char[] letters = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};

  int currentLetter = 0;
  ArrayList<Character> currentName = new ArrayList<Character>();

  String getPlayerName() {
    String returnS = "";
    for (Character chars : currentName) {
      returnS += chars;
    }
    return returnS;
  }

  void setup() {
    Backgrounds = new ArrayList<PImage>();
    java.io.File backgroundsFolder = new java.io.File(dataPath("menuImages/"));
    backgroundsFilenames = backgroundsFolder.list();

    for (int i = 0; i < backgroundsFilenames.length; i++)
    {
      Backgrounds.add(loadImage(backgroundsFolder +"/"+ backgroundsFilenames[i]));
    }
    scoreSaver.loadScores();
    textSize(32);
    fill(204, 204, 204, 255);
    score = createFont("/fonts/font1.otf", 32);
    textFont(score);
    imageMode(CENTER);
  }
  void updateAndRender() {
    menuPosition = new PVector(width/2, height/1.5);
    activeButtonPosition = buttonDistance*activeButton-buttonDistance;
    switch(currentMenuState) {

    case MAINMENU:
      background(Backgrounds.get(0));
      image(Backgrounds.get(6), menuPosition.x, menuPosition.y-buttonDistance);
      image(Backgrounds.get(7), menuPosition.x, menuPosition.y);
      image(Backgrounds.get(8), menuPosition.x, menuPosition.y+buttonDistance);      
      break;
    case LEVELSELECTOR:
      background(Backgrounds.get(1));
      if (activeButton != 0) {
        image(Backgrounds.get(14+activeButton-1), menuPosition.x-buttonDistance*2, menuPosition.y);
        image(Backgrounds.get(15+activeButton-1), menuPosition.x, menuPosition.y);
      } else {
        image(Backgrounds.get(15-activeButton-1), menuPosition.x, menuPosition.y);
      }
      if (activeButton != 4) {
        image(Backgrounds.get(16+activeButton-1), menuPosition.x+buttonDistance*2, menuPosition.y);
      } else {
        // Do not display the last button
      }
      break;
    case HIGHSCORE:
      background(Backgrounds.get(2));
      String[] highscores = ScoreManager.getScoreBoard();
      fill(204, 204, 204, 255);
      for (int highscoreList = 0; highscoreList < highscores.length; highscoreList++) {

        if (highscores[highscoreList] == null) {
          text(highscoreList+1 + "     " + "EMPTY", width/2-150, 250+highscoreList*textDistance); // If name is not specified.
        } else {
          text(highscoreList+1 + "     " + highscores[highscoreList], width/2-150, 250+highscoreList*textDistance); // Show name + Highest score.
        }
      }
      break;
    case GAMEOVER:
      if (levelPast == false) {    
        background(Backgrounds.get(4));
        image(Backgrounds.get(10), menuPosition.x, menuPosition.y-buttonDistance);
      } else if (levelPast == true) {
        background(Backgrounds.get(3));
        image(Backgrounds.get(9), menuPosition.x, menuPosition.y-buttonDistance);
      }
      image(Backgrounds.get(11), menuPosition.x, menuPosition.y);
      if (gameManager.getCurrentScene().totalLives <= 0)// Start of custom end messages on why you failed the level.
      {
        textAlign(CENTER);
        text("You ran out of lives!", width/2, 190);
      } // End of custom messages.

      textAlign(CENTER);
      text("Your time:     " + ScoreManager.time, width/2, 210);
      text("Time bonus:    " + ScoreManager.timeBonus, width/2, 230);
      text("Your score:    " + ScoreManager.getScore(), width/2, 250);
      break;
    case PAUSE:
      background(Backgrounds.get(5));
      image(Backgrounds.get(12), menuPosition.x, menuPosition.y-buttonDistance);
      image(Backgrounds.get(13), menuPosition.x, menuPosition.y);
      break;
    case INSERTSCORE:
      background(Backgrounds.get(0));

      textAlign(CORNER);
      rectMode(CENTER);   

      int textBoxX = width/2;
      int textBoxY = height/2;
      fill(0);
      rect(textBoxX, textBoxY, 204, 44);
      fill(200);
      rect(textBoxX, textBoxY, 200, 40);
      fill(0);
      textSize(20);
      text(getPlayerName(), textBoxX-98, textBoxY+12);
      fill(140, 140, 140, 255);

      int middleX = width/2;
      int middleY = height/2+100;
      int biggerBoxSize = 100;
      fill(0);
      rect(middleX, middleY, biggerBoxSize+4, biggerBoxSize+4);
      fill(200);
      rect(middleX, middleY, biggerBoxSize, biggerBoxSize);

      int amountOnLeft = 5 - currentLetter;
      if (amountOnLeft < 0)
        amountOnLeft = 0;

      int leftMiddleX = width/2;
      int leftMiddleY = height/2+100;
      int smallerBoxSize = 80;
      leftMiddleX -= 20;
      for (int i = amountOnLeft; i < 5; i++) {

        leftMiddleX -= smallerBoxSize+10;
        fill(0);
        rect(leftMiddleX, leftMiddleY, smallerBoxSize+4, smallerBoxSize+4);
        fill(200);
        rect(leftMiddleX, leftMiddleY, smallerBoxSize, smallerBoxSize);
      }

      int amountOnRight =  (currentLetter - 21)+1;
      if (amountOnRight < 0)
        amountOnRight = 0;

      int rightMiddleX = width/2;
      int rightMiddleY = height/2+100;


      rightMiddleX += 20;
      for (int i = amountOnRight; i < 5; i++) {
        rightMiddleX += smallerBoxSize+10;
        fill(0);
        rect(rightMiddleX, rightMiddleY, smallerBoxSize+4, smallerBoxSize+4);
        fill(200);
        rect(rightMiddleX, rightMiddleY, smallerBoxSize, smallerBoxSize);
      }

      int textSize = 48;

      int middleTextX = middleX-textSize/4-2;
      int middleTextY = middleY+textSize/4+2;
      //Selected letter
      fill(0);
      textSize(textSize);
      text(letters[currentLetter] + "", middleTextX, middleTextY);

      textSize = 36;

      leftMiddleX = width/2;
      leftMiddleY = height/2+100;
      leftMiddleX -= 20;

      for (int i = amountOnLeft; i < 5; i++) { 
        try {
          leftMiddleX -= smallerBoxSize+10;
          int leftTextX = leftMiddleX-textSize/4-2;
          int leftTextY = leftMiddleY+textSize/4+2;
          fill(0);
          textSize(textSize);

          if ((currentLetter-(i+1)) >= 0 && currentLetter >= 5) {
            text(letters[(currentLetter-i)-1] + "", leftTextX, leftTextY);
          } else {
            int letter = (currentLetter - i - 1)+4;
            letter = letter - (currentLetter-1);
            text(letters[letter] + "", leftTextX, leftTextY);
          }
        }
        catch(Exception e) {
          println("Hier: text for loop linker kant van middelste in de menu manager");
        }
      }

      rightMiddleX = width/2;
      rightMiddleY = height/2+100;

      rightMiddleX += 20;
      for (int i = amountOnRight; i < 5; i++) {
        rightMiddleX += smallerBoxSize+10;
        int rightTextX = rightMiddleX-textSize/4-2;
        int rightTextY = rightMiddleY+textSize/4+2;
        fill(0);
        textSize(textSize);
        if ((currentLetter+i)+1 <= 25) {
          int letter = currentLetter+i+1;
          if (currentLetter+i > 22) {
            int tempLetterValue = 25 - currentLetter;
            int actualLetterValue = 5 - tempLetterValue;
            letter = letter + actualLetterValue;
            letter -= 3;
          }
          text(letters[letter] + "", rightTextX, rightTextY);
        }
      }

      rectMode(CORNER);
      break;
    }
    if (currentMenuState != MenuState.HIGHSCORE) {
      if (currentMenuState != MenuState.LEVELSELECTOR) {
        if (currentMenuState == MenuState.INSERTSCORE) {
        } else {
          image(Backgrounds.get(19), menuPosition.x, menuPosition.y+activeButtonPosition);
        }
      } else {

        image(Backgrounds.get(20), menuPosition.x+2/**activeButtonPosition*/, menuPosition.y);
      }
    }
  }

  public void gameover() {
    if (gameManager.getCurrentScene().totalLives <= 0)
    {
      levelPast = false;
    } else
    {
      levelPast = true;
    }
  }
  void keyPressed() {
    if (currentMenuState != MenuState.LEVELSELECTOR && DungeonPanic.gameManager.currentGameState == GameState.INMENU) {
      if (currentMenuState == MenuState.INSERTSCORE) {
        if (keyCode == LEFT) {
          currentLetter -- ;
          if (currentLetter < 0) {
            currentLetter = 0;
          }
        } 
        if (keyCode == RIGHT) {
          currentLetter ++ ;
          if (currentLetter > 25) {
            currentLetter = 25;
          }
        }
      } else {
        if (keyCode == DOWN) {
          activeButton++;
        } 
        if (keyCode == UP) {
          activeButton--;
        }
      }
    } else {
      if (keyCode == RIGHT) {
        activeButton++;
      } 
      if (keyCode == LEFT) {
        activeButton--;
      }
    }
    if (currentMenuState == MenuState.LEVELSELECTOR)
    {
      if (activeButton > 4) {
        activeButton = 4;
      } else if (activeButton < 0) {
        activeButton = 0;
      }
    }
    if (currentMenuState == MenuState.MAINMENU)
    {
      if (activeButton > 2) {
        activeButton = 0;
      } else if (activeButton < 0) {
        activeButton = 2;
      }
    }
    if (currentMenuState == MenuState.GAMEOVER || currentMenuState == MenuState.PAUSE)
    {
      if (activeButton > 1) {
        activeButton = 0;
      } else if (activeButton < 0) {
        activeButton = 1;
      }
    } 
    if (key == 'a' && DungeonPanic.gameManager.currentGameState == GameState.INMENU) {
      switch(currentMenuState) {
      case MAINMENU :
        switch(activeButton) {
        case 0:
          currentMenuState = MenuState.LEVELSELECTOR;
          activeButton = 0;
          break;
        case 1:
          textSize(32);
          currentMenuState = MenuState.HIGHSCORE;
          activeButton = 0;
          break;
        case 2:
          exit();
          break;
        }
        break;
      case LEVELSELECTOR:
        switch(activeButton) {
        case 0: // Start level 1
          DungeonPanic.gameManager.getCurrentScene().timeSpent = 0; 
          gameManager.player.currentLives = 5;
          ScoreManager.totalScore = 0;
          activeButton = 0;
          gameManager.currentScene = 0;
          gameManager.getCurrentScene().spawnPlayer();
          DungeonPanic.gameManager.currentGameState = GameState.INGAME;
          break;
        case 1: // Start level 2
          DungeonPanic.gameManager.getCurrentScene().timeSpent = 0; 
          gameManager.player.currentLives = 5;
          ScoreManager.totalScore = 0;
          activeButton = 0;
          gameManager.currentScene = 1;
          gameManager.getCurrentScene().spawnPlayer();
          DungeonPanic.gameManager.currentGameState = GameState.INGAME;
          break;       
        case 2: // Start level 3 
          DungeonPanic.gameManager.getCurrentScene().timeSpent = 0; 
          gameManager.player.currentLives = 5;
          ScoreManager.totalScore = 0;
          activeButton = 0;
          gameManager.currentScene = 2;
          gameManager.getCurrentScene().spawnPlayer();
          DungeonPanic.gameManager.currentGameState = GameState.INGAME;
          break;
        case 3: // Start level 4  
          DungeonPanic.gameManager.getCurrentScene().timeSpent = 0; 
          gameManager.player.currentLives = 5;
          ScoreManager.totalScore = 0;
          activeButton = 0;
          gameManager.currentScene = 3;
          gameManager.getCurrentScene().spawnPlayer();
          DungeonPanic.gameManager.currentGameState = GameState.INGAME;
          break;
        case 4: // Start level 5  
          DungeonPanic.gameManager.getCurrentScene().timeSpent = 0; 
          gameManager.player.currentLives = 5;
          ScoreManager.totalScore = 0;
          activeButton = 0;
          gameManager.currentScene = 4;
          gameManager.getCurrentScene().spawnPlayer();
          DungeonPanic.gameManager.currentGameState = GameState.INGAME;
          break;
        }
        break;
      case GAMEOVER:
        switch(activeButton) { // Check which button is active 0=continue 1=Main Menu
        case 0:
          if (levelPast == true) {
            DungeonPanic.gameManager.currentGameState = GameState.INGAME;
            gameManager.nextLevel();
          } else if (levelPast == false) { // Restart the level from scratch.
            DungeonPanic.gameManager.currentGameState = GameState.INGAME;
            gameManager.player.currentLives = 5;
            gameManager.getCurrentScene().restart(DungeonPanic.gameManager.player);
            ScoreManager.resetScore();
            currentMenuState = MenuState.MAINMENU;
            gameManager.currentScene = 0;
          }
          break;
        case 1: // Return to main menu and reset everything.
          gameManager.getCurrentScene().totalLives = 5;
          currentMenuState = MenuState.INSERTSCORE;
          DungeonPanic.gameManager.currentGameState = GameState.INMENU;
          DungeonPanic.gameManager.getCurrentScene().timeSpent = 0;
          break;
        }
        activeButton = 0;
        break;
      case PAUSE:
        switch(activeButton) { // Check which button is active 0=continue 1=Main Menu
        case 0: // Continue where you left off in the level.
          DungeonPanic.gameManager.currentGameState = GameState.INGAME;
          break;
        case 1: // Stop playing the level and reset stats.
          DungeonPanic.gameManager.getCurrentScene().timeSpent = 0; 
          activeButton = 0;
          gameManager.player.currentLives = 5;
          ScoreManager.totalScore = 0;
          DungeonPanic.gameManager.currentGameState = GameState.INMENU; 
          currentMenuState = MenuState.MAINMENU; 
          gameManager.getCurrentScene().restart(DungeonPanic.gameManager.player);         
          break;
        }
        activeButton = 0;
        break;
      case INSERTSCORE:
        if (currentName.size() < 12) {//Max 12 charachers
          currentName.add(letters[currentLetter]);
        }
        break;
      }
    } 
    if (key == 'b' && DungeonPanic.gameManager.currentGameState == GameState.INMENU) {
      switch(currentMenuState) {
      case MAINMENU:
        break;
      case LEVELSELECTOR:
        currentMenuState = MenuState.MAINMENU;
        break;
      case HIGHSCORE:
        currentMenuState = MenuState.MAINMENU;
        break;
      case GAMEOVER:
        break;
      case INSERTSCORE:
        int size = currentName.size();
        if (size >= 1) {
          currentName.remove(size-1);
        }
        break;
      case PAUSE:
        DungeonPanic.gameManager.currentGameState = GameState.INGAME;
        break;
      }
      activeButton = 0;
    } 
    if (key == 'r') {
      if ( currentMenuState == MenuState.INSERTSCORE) {
        ScoreManager.insertScore(this.getPlayerName(), ScoreManager.saveScore);
        scoreSaver.saveScores();
        resetText();
        gameManager.player.currentLives = 5;
        ScoreManager.resetScore();
        currentMenuState = MenuState.MAINMENU;
        gameManager.getCurrentScene().restart(DungeonPanic.gameManager.player);
      } else if (DungeonPanic.gameManager.currentGameState == GameState.INGAME) {
        DungeonPanic.gameManager.currentGameState = GameState.INMENU;
        currentMenuState = MenuState.PAUSE;
      }
      activeButton = 0;
    }
  }

  public void resetText() {
    currentName = new ArrayList<Character>();
  }
}
enum MenuState {
  MAINMENU, LEVELSELECTOR, HIGHSCORE, GAMEOVER, INSERTSCORE, PAUSE;
}
