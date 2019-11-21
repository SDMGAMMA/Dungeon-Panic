/**
 @author Nicolaas Schuddeboom,Koen Groot, Casper Klinkhamer
 
 Deze class heeft het Player object. Dit object heeft beweging en collision detection in het.
 
 */
public class Player
{
  // Set variables
  PVector position = new PVector(width/1.5, height/2);

  // Size of the player
  private final int playerSize = 100;

  // Mobility variables - Casper: Ik heb een beetje aan deze variable gezeten zodat ik even sneller kon testen.
  private final float walkSpeed = 5f;

  private int invincibleTimer;
  private int trapTimer;
  private int currentLives = 5;

  private int keyCount = 0;

  // The keys array holds a boolean if a certain key is being pressed. The keycodes of up, down, left and right are 2, 0, 1, 3
  private boolean[] keys = new boolean[6];

  public boolean stunned = false;
  public boolean killedSpider = false;

  //Animations
  Animations ani;
  int rotation = 0;

  //Jumping
  Jumping jump;

  private boolean canMove = true; //This variable is for the playerClass to know if the player characher can move. Nice

  public Player() {
    ani = new Animations(); //Laadt de animatie class
    ani.setupAnimations(); //Laadt setup van de animaties
    jump = new Jumping(); //Laadt de jump class
    jump.setupJumping();  //Laadt setup van de jump
  }

  PVector posInc;//PositionIncrease (it can be a descrease);
  public void updateMovement(Scene scene, AudioPlayer walkingSound, AudioPlayer jumpingSound) { // This method contains the movement update for the player and checks if the player is in a wall or not.

    float characterSpeed = walkSpeed;
    posInc = new PVector(0, 0, 0);

    if (keys[2])
    {
      posInc.x += characterSpeed*DungeonPanic.delta;
    }
    if (keys[0])
    {
      posInc.x -= characterSpeed*DungeonPanic.delta;
    }
    if (keys[1])
    {
      posInc.y -= characterSpeed*DungeonPanic.delta;
    }
    if (keys[3])
    {
      posInc.y += characterSpeed*DungeonPanic.delta;
    }

    if ((posInc.x != 0 || posInc.y != 0) && !jump.jumping)
    {
      while (!walkingSound.isPlaying())
      {
        walkingSound.loop();
      }
    } else
    {
      walkingSound.rewind();
    }

    if (jump.jumping)
    {
      while (!jumpingSound.isPlaying())
      {
        jumpingSound.play();
      }
    } else
    {
      jumpingSound.rewind();
    }

    if (posInc.y < 0) {
      rotation = 0;
    } else if (posInc.y > 0) {

      rotation = 180;
    }

    if (posInc.x > 0) {
      if (posInc.y < 0) {

        rotation = 45;
      } else if (posInc.y > 0) {

        rotation = 135;
      } else {
        rotation = 90;
      }
    } else if (posInc.x < 0) {
      if (posInc.y < 0) {
        rotation = -45;
      } else if (posInc.y > 0) {
        rotation = -135;
      } else {
        rotation = -90;
      }
    }

    if (posInc.x != 0 || posInc.y !=0) {
      ani.updateCurrentFrameTime();
    }

    jump.updateCurrentFrameTime();

    //The underlying code is the collision detection part. It checks if a single position is in a green pixel on the reference map image. 
    if (gameManager.getCurrentScene().enemies.size() > 0)
    {
      for (int i = 0; i < gameManager.getCurrentScene().enemies.size(); i++) {
        if (canMove && !stunned && gameManager.getCurrentScene().enemies.get(i).canMove) { // TEMP if statement only so the game is playab
          position.y += posInc.y;
          player.checkOnHinderance(gameManager.getCurrentScene());
          checkForCollision(scene, new PVector(0, posInc.y));

          position.x += posInc.x;
          player.checkOnHinderance(gameManager.getCurrentScene());
          checkForCollision(scene, new PVector(posInc.x, 0));

          checkIfRecentlyHit();
          checkIfTriggeredTrap(scene);
          break;
        }
      }
    } else {
      if (canMove && !stunned) { // TEMP if statement only so the game is playab
        position.y += posInc.y;
        player.checkOnHinderance(gameManager.getCurrentScene());
        checkForCollision(scene, new PVector(0, posInc.y));

        position.x += posInc.x;
        player.checkOnHinderance(gameManager.getCurrentScene());
        checkForCollision(scene, new PVector(posInc.x, 0));

        checkIfRecentlyHit();
        checkIfTriggeredTrap(scene);
      }
    }
  }
  public PVector getPositionOnMap() {
    return new PVector(position.x/Scene.resizeFac, position.y/Scene.resizeFac);
  }

  public void display() {
    translate(width/2, height/2);
    rotate(radians(rotation));
    image(ani.getCurrentFrame(), 0, 0, playerSize * jump.getCurrentSize(), playerSize * jump.getCurrentSize() );
    rotate(-radians(rotation));
    translate(-width/2, -height/2);
  }

  public boolean moveInput(Scene scene) {
    // Check if keyCode doesn't crash the game and then make the corresponding index in keys true 
    boolean keyPressed = false;
    if (keyCode >= 37 && keyCode <= 40)
    {
      keys[keyCode - 37] = true;
      keyPressed=true;
    }
    if (keyCode == 65)
    {
      keys[4] = true;
      keyPressed=true;
    }
    if (keyCode == 66 && !keys[5])
    {
      keyPressed=true;
      PVector jumpDir = new PVector();
      jump.jump();

      jump(jumpDir, scene);

      keys[5] = true;
    }
    return keyPressed;
  }

  public void jump(PVector jumpDir, Scene scene) {

    float jumpX = jumpDir.x * 0.25;
    float jumpY = jumpDir.y * 0.25;
    position.x += jumpX;
    checkForCollision(scene, new PVector(jumpX, 0));

    position.y += jumpY;
    checkForCollision(scene, new PVector(0, jumpY));

    position.x += jumpX;
    checkForCollision(scene, new PVector(jumpX, 0));

    position.y += jumpY;
    checkForCollision(scene, new PVector(0, jumpY));
  }

  public boolean moveOutput()
  {
    boolean keyPressed = false;
    // Check if keyCode doesn't crash the game and then make the corresponding index in keys false 
    if (keyCode >= 37 && keyCode <= 40)
    {
      keys[keyCode - 37] = false;
      keyPressed = true;
    }
    if (keyCode == 65)
    {
      keys[4] = false;
      keyPressed = true;
    }
    if (keyCode == 66 && keys[5])
    {
      keys[5] = false;
      keyPressed = true;
    }
    return keyPressed;
  }


  //All possible checks

  public void checkInDoor(Scene scene, int colorI, int playerPosOnMapX, int playerPosOnMapY, PVector velocity) {
    for (Door door : scene.doors) 
    {
      if ( door.topLeft.x == playerPosOnMapX && door.topLeft.y == playerPosOnMapY  ) 
      {
        if (!door.checkState()) 
        {
          if (door.OpenDoorOnCollision())
          {
            door.openDoor();
          } else
          {
            position.x -=  velocity.x;
            position.y -=  velocity.y;
          }
        }
        break;
      }
    }
  }

  public void checkForExit(int colorI)
  {
    if ( colorI == Scene.exitCLR) 
    {
      ScoreManager.addScore(ScoreManager.checkTimeBonus());
      if (ScoreManager.checkScore(ScoreManager.totalScore, (gameManager.currentScene + 1) * 500))
      {
        gameManager.menuManager.gameover();
        gameManager.menuManager.currentMenuState = MenuState.GAMEOVER;       
        gameManager.currentGameState = GameState.INMENU;
      } else
      {
        gameManager.menuManager.gameover();
        gameManager.menuManager.currentMenuState = MenuState.GAMEOVER;
        gameManager.currentGameState = GameState.INMENU;        
        scoreSaver.saveScores();
      }
      gameManager.getCurrentScene().restart(DungeonPanic.gameManager.player);
    }
  }

  public void checkIfRecentlyHit()
  {
    if (gameManager.getCurrentScene().getFloatTime() >= invincibleTimer+1.5f)
    {
      gameManager.getCurrentScene().invincible = false;
    }
  }

  public void checkIfTriggeredTrap(Scene scene)
  {
    if (gameManager.getCurrentScene().getFloatTime() >= trapTimer+1)
    {
      scene.untriggerTraps();
    }
  }

  public void checkForTreasure(Scene scene, AudioPlayer treasurePickupSound) {//This method checks if the user has collected a treasure. Using the same method as collision detection.
    int playerPosOnMapX = ((int) (position.x))/Scene.resizeFac;
    int playerPosOnMapY = ((int) (position.y))/Scene.resizeFac;
    int colorI = scene.getColorFromMap(playerPosOnMapX, playerPosOnMapY);

    if (colorI == Scene.treasureRandomCLR || colorI == Scene.treasureEpicCLR || colorI == Scene.treasureRareCLR) {
      boolean continueC = true;

      for (Treasure treasure : scene.treasures) {
        if (continueC && treasure.topLeft.x == playerPosOnMapX && treasure.topLeft.y == playerPosOnMapY  ) {
          continueC=false;

          if (!treasure.taken()) {
            treasure.take();
            treasurePickupSound.play();
            treasurePickupSound.rewind();
            new TextAnimation(width/2 + 20, height/2, "+" + treasure.scoreAdd, 5f, color(52, 120, 40), 35f, 2.8f);
            ScoreManager.addScore(treasure.getScoreAdd());
          }
        }
      }
    }
  }

  public void checkForRandomTreasure(Scene scene) {//This method checks if the user has collected a treasure. Using the same method as collision detection.
    int playerPosOnMapX = ((int) (position.x))/Scene.resizeFac;
    int playerPosOnMapY = ((int) (position.y))/Scene.resizeFac;
    int colorI = scene.getColorFromMap(playerPosOnMapX, playerPosOnMapY);

    if (colorI == Scene.randomTreasureCLR) {
      boolean continueC = true;

      for (RandomTreasure treasure : scene.randomTreasures) {
        if (continueC && treasure.topLeft.x == playerPosOnMapX && treasure.topLeft.y == playerPosOnMapY  ) {
          continueC=false;

          if (!treasure.taken()) {
            treasure.take();
            treasurePickupSound.play();
            treasurePickupSound.rewind();
            treasure.giveBonus();
          }
        }
      }
    }
  }

  public void checkForKey(Scene map)
  {
    int playerPosOnMapX = ((int) (position.x))/Scene.resizeFac;
    int playerPosOnMapY = ((int) (position.y))/Scene.resizeFac;
    int colorI = map.getColorFromMap(playerPosOnMapX, playerPosOnMapY);

    if (colorI == Scene.keyCLR) 
    {  
      for (Key doorKey : map.keys) 
      {
        if ( doorKey.topLeft.x == playerPosOnMapX && doorKey.topLeft.y == playerPosOnMapY  ) 
        {
          if (!doorKey.taken()) 
          {
            doorKey.take();
            keyCount++;
            break;
          }
        }
      }
    }
  }

  public void checkForCollision(Scene scene, PVector velocity) {
    int playerPosOnMapX = ((int) (position.x))/Scene.resizeFac;
    int playerPosOnMapY = ((int) (position.y))/Scene.resizeFac;
    color colorI = scene.getColorFromMap(playerPosOnMapX, playerPosOnMapY);
    if ( colorI == Scene.wallCLR || colorI == Scene.wallCLR2) {
      position.x -=  velocity.x;
      position.y -=  velocity.y;
    }
    checkInDoor(scene, colorI, playerPosOnMapX, playerPosOnMapY, velocity);
    checkForExit(colorI);
  }

  public void checkOnHinderance(Scene scene)
  {
    int playerPosOnMapX = ((int) (position.x))/Scene.resizeFac;
    int playerPosOnMapY = ((int) (position.y))/Scene.resizeFac;
    color colorI = scene.getColorFromMap(playerPosOnMapX, playerPosOnMapY);
    if (colorI == scene.trapCLR)
    {
      scene.triggerTraps();
      trapTimer = gameManager.getCurrentScene().getTimeSpent();
      if (!gameManager.getCurrentScene().invincible)
      {
        gameManager.getCurrentScene().totalLives--;
        currentLives--;
        gameManager.getCurrentScene().invincible = true;
        invincibleTimer = gameManager.getCurrentScene().getTimeSpent();
        if (!damageSound.isPlaying())
        {
          damageSound.play();
          damageSound.rewind();
        }
      }
    }
  }

  public void checkForSwitch(Scene map)
  {
    // Get X and Y position of player and then get the color on the map
    int playerPosOnMapX = ((int) (position.x))/Scene.resizeFac;
    int playerPosOnMapY = ((int) (position.y))/Scene.resizeFac;
    int colorI = map.getColorFromMap(playerPosOnMapX, playerPosOnMapY);

    // If the tile the player is standing on is a switch,
    if (colorI == Scene.floorSwitchCLR) 
    {  
      // Check which switch the player is standing on
      for (FloorSwitch floorSwitch : map.floorSwitches) 
      {
        if ( floorSwitch.topLeft.x == playerPosOnMapX && floorSwitch.topLeft.y == playerPosOnMapY  ) 
        {
          // If it isn't pressed,
          if (!floorSwitch.pressed)
          {
            // Press it
            floorSwitch.pressSwitch();

            // These 2 variables are used in the next loop. breakLoop is used to break from the while loop and distance is used to know the distance from the switch
            boolean breakLoop = false;
            int distance = 0;

            while (!breakLoop)
            {
              distance++;

              // This part is hard to explain with comments
              for (int x = -distance; x <= distance; x++)
              {
                for (int y = -distance; y <= distance; y++)
                {
                  // Go through all doors
                  for (Door door : map.doors) 
                  {
                    // If the door should be opened with the 
                    if (door instanceof SwitchDoor)
                    {                     
                      if (door.topLeft.x + x == floorSwitch.topLeft.x && door.topLeft.y + y == floorSwitch.topLeft.y)
                      {
                        door.openDoor();
                        breakLoop = true;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  public void checkForLever(Scene map)
  {
    // Get X and Y position of player and then get the color on the map
    int playerPosOnMapX = ((int) (position.x))/Scene.resizeFac;
    int playerPosOnMapY = ((int) (position.y))/Scene.resizeFac;
    int colorI = map.getColorFromMap(playerPosOnMapX, playerPosOnMapY);

    for (Lever lever : map.levers)
    {
      if (lever.topLeft.x == playerPosOnMapX && lever.topLeft.y == playerPosOnMapY)
      {
        if (!lever.lockLever) 
        {
          lever.flickLever();
          lever.lockLever = true;

          for (Door door : map.doors)
          {
            if (door instanceof LeverDoor)
            {
              door.open = !door.checkState();
              /*
              if (door.checkState())
               {
               door.closeDoor();
               } else
               {
               door.openDoor();
               }*/
            }
          }
        }
        break;
      } else if (lever.lockLever)
      {
        lever.lockLever = false;
      }
    }
  }
}

enum MovementDirection {
  LEFT, UP, DOWN, RIGHT;
}
