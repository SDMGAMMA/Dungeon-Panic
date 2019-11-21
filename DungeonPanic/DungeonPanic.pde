/**
 @author Casper Klinkhamer, Koen Groot, Mike Breur, Nicolaas Schuddeboom, Leander van Grinsven
 Dit is de hoofd class. In deze class tekent het programma alles en laadt het programma ook alles in.
 */

import ddf.minim.*;

Player player;
Minim minim;

AudioPlayer inGameBackgroundMusic;
AudioPlayer treasurePickupSound;
AudioPlayer walkingSound;
AudioPlayer jumpingSound;
AudioPlayer gunSound;
AudioPlayer damageSound;

ScoreSaver scoreSaver = new ScoreSaver();

static long prevDelta = 0;
boolean hasInit = false;
static double delta = 0; // This variable is a time mesure variable. Its used to calculate a acurate speed of a timer or anything else you need. This way regardless of the fps the player will always move the same speed if multiplied by this number.

static GameManager gameManager;
static CheatManager cheatManager;
CombatManager combatManager;

void setup() {
  minim = new Minim(this);

  inGameBackgroundMusic = minim.loadFile("sounds/inDungeon.mp3");
  treasurePickupSound =  minim.loadFile("sounds/treasurePickup.mp3");
  walkingSound = minim.loadFile("sounds/walkingSound.mp3");
  jumpingSound = minim.loadFile("sounds/jumpSound.mp3");
  gunSound = minim.loadFile("sounds/gunSound.aiff");
  damageSound = minim.loadFile("sounds/damageSound.mp3");

  inGameBackgroundMusic.setGain(-9);
  walkingSound.setGain(-2);
  jumpingSound.setGain(+4);
  gunSound.setGain(-10);
  damageSound.setGain(-5);

  SetupManager setupManager = new SetupManager();
  player = setupManager.player;
  gameManager = new GameManager(setupManager, player);
  cheatManager = new CheatManager();  
  combatManager = new CombatManager();

  scoreSaver.loadScores(); //Load the High scores from Highscores.txt file.

  size(1280, 720, P2D);
  noStroke();
  noSmooth();
  frameRate(100000);
}

void draw() {//To reduce the amount of lines in the draw() method I added the updateThings() method and the drawThings() method.
  updateEverything();
  gameManager.renderGame(player);
}

void updateEverything() {//Here everything is updated like movement and more stuff
  delta = ((-prevDelta + (prevDelta = frameRateLastNanos))/1e6d)/10;//Here the delta is calculated using the processing frameRateLastNanos variable.
  if (gameManager.getCurrentScene().totalLives <= 0) {
    gameManager.menuManager.gameover();
    gameManager.menuManager.currentMenuState = MenuState.GAMEOVER;
    gameManager.currentGameState = GameState.INMENU;
  }

  if (gameManager.currentGameState == GameState.INGAME) {
    if (!inGameBackgroundMusic.isPlaying()) {
      inGameBackgroundMusic.loop();
    }
  } else {
    inGameBackgroundMusic.rewind();
    walkingSound.rewind();
    jumpingSound.rewind();
    damageSound.rewind();
    if (!hasInit) {  
      gunSound.rewind();
      hasInit = true;
    }
  }
}

void keyPressed() {
  gameManager.keyPressed();
  cheatManager.keyPressed();

  boolean moved = player.moveInput(gameManager.getCurrentScene());
  if (moved) {
    gameManager.getCurrentScene().start(player);
  }
}

void keyReleased() {
  player.moveOutput();
}

PImage loadGameImage(String dir) {
  return loadImage(dir);
}
