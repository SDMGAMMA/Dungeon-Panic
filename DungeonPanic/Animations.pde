/** 
 @author Mike Breur, Casper Klinkhamer
 Deze class zorgt ervoor dat het playermodel animaties krijgt die reageren op input van de speler.
 Doel van deze class is 1 animated frame per seconde geven
 */
class Animations {   
  PImage[] frame = new PImage[20];
  int Frame = 0;
  int currentFrame = 0;
  float totalTime = 6;
  float time = 0;

  void setupAnimations() {
    for (int i = 0; i < frame.length; i++) {
      frame[i] = loadImage("playerAni/Moving/frame" + i + ".png");
    }
  }

  PImage getCurrentFrame() { // This method picks the current frame
    PImage returnImage = null; 
    if (currentFrame > 19 || currentFrame < 0) {
      currentFrame = 0;
    }
    returnImage = frame[currentFrame];

    return returnImage;
  }

  void updateCurrentFrameTime() { //This method updates the current frame
    time += DungeonPanic.delta/10;    
    if (time > 5) { 
      time = 0;
    }

    currentFrame = (int)(totalTime / time);
  }
}

/**
 @author Mike Breur, Casper Klinkhamer, Koen Groot
 Deze class zorgt ervoor dat het playermodel jump animaties krijgt die reageren wanneer de speler op "b" drukt.
 Doel van deze class is 1 animated frame per seconde geven
 */
class Jumping {

  float[] resizeFac = new float[16];

  int Frame = 0;
  float currentFrame = 0;
  double totalTime = 7;
  double time = 0;

  boolean jumping = false;

  void setupJumping() {
    resizeFac[0] = 1.1;  
    resizeFac[1] = 1.3;   
    resizeFac[2] = 1.5;
    resizeFac[3] = 1.6;
    resizeFac[4] = 1.65;
    resizeFac[5] = 1.6;
    resizeFac[6] = 1.55;
    resizeFac[7] = 1.5;  
    resizeFac[8] = 1.45;   
    resizeFac[9] = 1.4;
    resizeFac[10] = 1.35;
    resizeFac[11] = 1.3;
    resizeFac[12] = 1.25;
    resizeFac[13] = 1.2;
    resizeFac[14] = 1.15;
    resizeFac[15] = 1.1;
  }

  void jump() {
    jumping=true;
  }

  float getCurrentSize() {  //dit pakt de huidige grootte en vermenigvuldigd deze met de rescale factor
    if (jumping) {
      float resizeFacReturn = 1;
      if (currentFrame > 15 || currentFrame < 0) {
        currentFrame = 0;
      }
      resizeFacReturn = resizeFac[(int)currentFrame]; 

      return resizeFacReturn;
    } else {
      return 1;
    }
  }

  void updateCurrentFrameTime() { //This method updates the current frame
    if (jumping) {
      gameManager.getCurrentScene().invincible = true;
      time += (DungeonPanic.delta/10.0);    
      currentFrame = ((int) (totalTime / time))-1;
    }

    if (time > 5) { 
      gameManager.getCurrentScene().invincible = false;
      time = 0;
      jumpingSound.rewind();
      jumping = false;
    }
  }
}


/*
@author Casper Klinkhamer
 De volgende text animatie classes zijn voor het on screen popup systeem voor beijvoorbeeld loot en healt.
 */
public class TextAnimation {

  int x, y;
  String text;
  float textSize;
  PFont font;
  color textColor;

  float totalSizeIncrease;
  float lifeTime;//Life time in secconds

  private float timePassed = 0;
  public boolean removeMe = false;

  public TextAnimation(int x, int y, String text, float textSize, color textColor, float totalSizeIncrease, float lifeTime) {
    this.textColor = textColor;
    this.x = x;
    this.y = y;
    this.text = text;
    this.textSize = textSize;
    this.totalSizeIncrease = totalSizeIncrease;
    this.lifeTime = lifeTime;

    TextAnimationHandler.textAnimations.add(this);
  }

  public TextAnimation(int x, int y, String text, float textSize, PFont font, color textColor, float totalSizeIncrease, float lifeTime) {
    this.textColor = textColor;
    this.x = x;
    this.y = y;
    this.text = text;
    this.textSize = textSize;
    this.font = font;
    this.totalSizeIncrease = totalSizeIncrease;
    this.lifeTime = lifeTime;

    TextAnimationHandler.textAnimations.add(this);
  }

  void draw() {
    float thisIncrease = (float) (totalSizeIncrease/lifeTime * (DungeonPanic.delta/10));
    textSize = textSize + thisIncrease;

    timePassed += DungeonPanic.delta/10;

    if (font != null)
      textFont(font);
    fill(textColor);
    textSize((int) textSize);
    text(text, x, y);

    if (timePassed >= lifeTime) {
      removeMe = true;
    }
  }
}

public static class TextAnimationHandler {

  static ArrayList<TextAnimation> textAnimations = new ArrayList<TextAnimation>();

  static void draw() {
    ArrayList<TextAnimation> toRemove = new ArrayList<TextAnimation>();

    for (TextAnimation textAnimation : textAnimations) {
      textAnimation.draw();
      if (textAnimation.removeMe) {
        toRemove.add(textAnimation);
      }
    }
    textAnimations.removeAll(toRemove);
  }
}
