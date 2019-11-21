/** 
 @author Mike Breur,
 Deze class zorgt ervoor dat de speler zijn levens in hartjes terugziet 
 */


class HUD {

  int Frame = 0;
  PImage heart;

  Heart[] currentHearts = new Heart[5];

  public HUD() { // Er wordt een nieuw HUD object gemaakt
    PImage heart = loadImage("hudImages/hartje.png");

    for ( int i = 0; i < 5; i++) {
      currentHearts[i] = new Heart(true, heart);
    }
  }

  //De hartjes worden relatief aan de schermgrootte getekent
  final float HEART_RENDER_X = width / 64;
  final float HEART_RENDER_Y = height / 36 + 25;
  final float HEART_SIZE = 30;

  public void drawHearts() {  //Deze functie laadt, houdt je levens bij en update alle hartjes in real time zodat je precies op tijd ziet hoeveel levens je hebt. 

    for (Heart h : currentHearts) {
      h.active = false;
    }

    for (int i = 0; i < gameManager.getCurrentScene().totalLives; i++) {
      currentHearts[i].active = true;
      currentHearts[i].resetHearts();
    }

    float x = HEART_RENDER_X;
    float y = HEART_RENDER_Y;

    for (int i = 0; i < 5; i++) {
      currentHearts[i].updateHearts();
      if (currentHearts[i].render) {
        imageMode(CENTER);
        image(currentHearts[i].heart, x, y, (int)currentHearts[i].size, (int)currentHearts[i].size);
      }
      x += HEART_SIZE;
    }
  }

  public void drawHUD() { // Deze methode tekent de HUD. Er staat nu alleen een methode om hartjes te tekenen in maar binnenkort komen er meer methodes in voor stamina en tijd etc
    drawHearts();
    //Something koen is working on
    //System.out.println("Keys in level: " + DungeonPanic.gameManager.getCurrentScene().keys.size() + " Keys gotten: " + DungeonPanic.gameManager.player.keyCount );
  }
}

class Heart { //Dit is het hart object met daarin alle variabelen die door de rest van deze class gebruikt gaan worden
  public boolean render = true;
  double size = 30;
  public boolean active = false;
  public PImage heart;

  public Heart(boolean active, PImage heart) {
    this.active = active;
    this.heart = heart;
  }

  public void updateHearts() {
    if (!active && render) { // dit stukje code kan gebruikt worden om de hartjes een animatie te laten afspelen
      size -= 5 * (DungeonPanic.delta/10);
      if (size < 0) {
        render = false;
      }
    }
  }

  public void resetHearts() { //Dit reset het hartje weer terug naar de oorspronkelijke grootte en tekent alle hartjes weer op het scherm
    size = 30;
    render = true;
    active = true;
  }
}
