
/**
 
 @author Casper Klinkhamer
 In deze class zorgt er voor dat het spel op de goede manier is weergeven.
 
 */

class GameManager {

  GameState currentGameState = GameState.INMENU;

  final int TOTAL_LEVELS_AMOUNT = 5;
  Scene[] levels = new Scene[TOTAL_LEVELS_AMOUNT];

  int currentScene = 0;

  MenuManager menuManager = new MenuManager();

  Player player;
  HUD hud = new HUD();

  public GameManager(SetupManager manager, Player player) {
    menuManager.setup();
    levels = manager.levels;
    this.player = player;
  }

  public void setGameState(GameState state) {
    this.currentGameState = state;
  }

  public Scene getCurrentScene() {
    return levels[currentScene];
  }

  public void renderGame(Player player) {//THis method renders the game scene. It also updates the player only if the GameState equals INGAME. Thats how to pause menu will work too.

    background(0);

    switch(currentGameState) {
    case INGAME:

      player.updateMovement(gameManager.getCurrentScene(), walkingSound, jumpingSound);
      player.checkForTreasure(gameManager.getCurrentScene(), treasurePickupSound);
      player.checkForRandomTreasure(gameManager.getCurrentScene());
      player.checkForTreasure(gameManager.getCurrentScene(), gunSound);
      player.checkForKey(gameManager.getCurrentScene());
      player.checkForSwitch(gameManager.getCurrentScene());
      player.checkForLever(gameManager.getCurrentScene());

      gameManager.getCurrentScene().update(player);

      getCurrentScene().drawMap(player);
      combatManager.draw();
      player.display();

      gameManager.getCurrentScene().updateMiniMap(player);
      gameManager.getCurrentScene().miniMap.drawMiniMap(player);

      renderGUI();
      break;
    case INMENU:
      menuManager.updateAndRender();
      break;
    case PAUSE:
      getCurrentScene().drawMap(player);
      player.display();
      renderGUI();
      menuManager.updateAndRender();
      break;
    }
  }

  private void renderGUI() {

    fill(255);
    textSize(20);

    textSize(25);
    textAlign(LEFT, TOP);
    text("Score: " + ScoreManager.getScore(), 0, 0);  

    textAlign(CENTER, TOP);
    textSize(50);
    text(gameManager.getCurrentScene().getTimeSpent(), width / 2, 0);

    textSize(20);
    textAlign(LEFT);

    hud.drawHUD();

    TextAnimationHandler.draw();
  }

  void keyPressed() {
    menuManager.keyPressed();
    getCurrentScene().miniMap.keyPressed();
    combatManager.keyPressed(player);
  }

  void nextLevel()
  {
    if (currentScene == (TOTAL_LEVELS_AMOUNT - 1)) {
      currentScene = 0;
    } else {
      currentScene++;
    }
    getCurrentScene().restart(player);
  }
}

enum GameState {
  INGAME, INMENU, PAUSE;
}
