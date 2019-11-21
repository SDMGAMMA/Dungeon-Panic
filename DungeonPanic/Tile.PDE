/**
 
 @author Casper Klinkhamer
 Deze class heeft een tile object. In dat object slaat hij bepaalde posities op die nodig zijn voor berekingen buiten het object
 
 */

class Tile {

  PVector topLeft;
  PVector size;
  PImage texture;

  PVector miniMapColor;

  public Tile(PImage texture, PVector miniMapColor, PVector topLeft, PVector size) {
    this.topLeft = topLeft;
    this.size = size;
    this.texture = texture;
    this.miniMapColor = miniMapColor;
  }

  PVector getTopLeft() {//Return the toleft corner of a tile
    return topLeft;
  }

  PVector getBottomRight() {//Return the bottomRight corner of a tile
    return topLeft.add(size.x, size.y);
  }

  PImage getTexture() {
    return texture;
  }

  PVector getMiniMapColor() {
    return miniMapColor;
  }
}



/**
 
 @author Nicolaas Schuddeboom
 In deze class zit het deur object. Het is een extentie van Tile want een deur heeft 1 meer variable dus het was handig om tile de parent te maken.
 
 */
class Door extends Tile
{
  boolean open = false;
  PImage openTexture;

  public Door(PImage texture, PImage openTexture, PVector miniMapColor, PVector topLeft, PVector size)
  {
    super(texture, miniMapColor, topLeft, size);

    this.openTexture = openTexture;
  }

  boolean checkState()
  {
    return open;
  }

  void openDoor()
  {
    open = true;
  }

  void closeDoor()
  {
    open = false;
  }

  PImage getOpenTexture()
  {
    return openTexture;
  }

  boolean OpenDoorOnCollision()
  {
    return false;
  }
}

/**
 
 @author Nicolaas Schuddeboom
 In deze class zit het deur object die met de sleutel open gemaakt wordt. De deur gaat open wanneer je een key hebt en in de deur loopt
 
 */
class KeyDoor extends Door
{
  public KeyDoor(PImage texture, PImage openTexture, PVector miniMapColor, PVector topLeft, PVector size)
  {
    super(texture, openTexture, miniMapColor, topLeft, size);
  }

  boolean OpenDoorOnCollision()
  {
    if (player.keyCount > 0)
    {
      player.keyCount--;
      openDoor();
      return true;
    }
    return false;
  }
}

/**
 
 @author Nicolaas Schuddeboom
 In deze class zit het deur object die open gaat met de switch. Wanneer een switch wordt in gedrukt, gaan de dichtsbijzijnde deuren open
 
 */
class SwitchDoor extends Door
{
  public SwitchDoor(PImage texture, PImage openTexture, PVector miniMapColor, PVector topLeft, PVector size)
  {
    super(texture, openTexture, miniMapColor, topLeft, size);
  }

  boolean OpenDoorOnCollision()
  {
    return false;
  }
}

/**
 
 @author Nicolaas Schuddeboom
 In deze class zit het switch object. Wanneer een switch wordt in gedrukt, gaan de dichtsbijzijnde SwitchDoors open
 
 */
class FloorSwitch extends Tile
{
  PImage pressedTexture;
  boolean pressed = false;

  public FloorSwitch(PImage texture, PImage pressedTexture, PVector miniMapColor, PVector topLeft, PVector size)
  {
    super(texture, miniMapColor, topLeft, size);

    this.pressedTexture = pressedTexture;
  }

  PImage getPressedTexture()
  {
    return pressedTexture;
  }

  void pressSwitch()
  {
    pressed = true;
  }

  void unpressSwitch()
  {
    pressed = false;
  }

  boolean pressed()
  {
    return pressed;
  }
}

/**
 
 @author Nicolaas Schuddeboom
 In deze class zit het deur object die open gaat met de switch. Wanneer een switch wordt in gedrukt, gaan de dichtsbijzijnde deuren open
 
 */
class LeverDoor extends Door
{
  public LeverDoor(PImage texture, PImage openTexture, PVector miniMapColor, PVector topLeft, PVector size)
  {
    super(texture, openTexture, miniMapColor, topLeft, size);
  }

  boolean OpenDoorOnCollision()
  {
    return false;
  }
}

/**
 
 @author Nicolaas Schuddeboom
 In deze class zit het switch object. Wanneer een switch wordt in gedrukt, gaan de dichtsbijzijnde SwitchDoors open
 
 */
class Lever extends Tile
{
  PImage secondTexture;
  boolean flicked;
  boolean lockLever;

  public Lever(PImage texture, PImage secondTexture, PVector miniMapColor, PVector topLeft, PVector size)
  {
    super(texture, miniMapColor, topLeft, size);

    this.secondTexture = secondTexture;

    flicked = false;
    lockLever = false;
  }

  void flickLever()
  {
    flicked = !flicked;
  }

  PImage getTexture()
  {
    if (!flicked)
    {
      return texture;
    } else
    {
      return secondTexture;
    }
  }
}

/**
 @author Casper Klinkhamer, Koen Groot
 In deze class het het muur object. Het is een extentie van Tile want een muur heeft 1 meer variable dus het was handig om tile de parent te maken.
 */
class Wall extends Tile {

  boolean connect_left = false, connect_right = false, connect_bottom = false, connect_top = false, connect_all = false;

  public Wall(PImage texture, PVector miniMapColor, PVector topLeft, PVector size)
  {
    super(texture, miniMapColor, topLeft, size);
  }
}

/**
 
 @author Casper Klinkhamer
 Deze class heeft een treasure object. In dat object slaat hij bepaalde posities op die nodig zijn voor berekingen buiten het object. Ook heeft dit object een taken variable waardoor de kist uitgeschakelt kan worden.
 
 */
class Treasure {

  PVector topLeft;
  PVector size;

  int scoreAdd;

  boolean taken = false;

  PImage texture;

  public Treasure(PImage texture, PVector topLeft, PVector size, int scoreAdd) {
    this.topLeft = topLeft;
    this.scoreAdd = scoreAdd;
    this.size = size;
    this.texture = texture;
  }

  PVector getTopLeft() {
    return topLeft;
  }

  PVector getBottemRight() {

    return topLeft.add(size.x, size.y);
  }

  int getScoreAdd() {
    return scoreAdd;
  }

  void take() {
    taken = true;
  }

  boolean taken() {
    return taken;
  }

  PImage getTexture() {
    return texture;
  }

  Treasure setTexture(PImage texture) {
    this.texture = texture;
    return this;
  }

  Treasure setPointsAdd(int i) {
    scoreAdd = i;
    return this;
  }
}

/**
 
 @author Nicolaas Schuddeboom
 In deze class zit de RandomTreasure object. Dit object geeft je een bonus wanneer je het op pakt waarbij de extenties de verschillende bonusses bevatten.
 
 */
class RandomTreasure
{
  PVector topLeft;
  PVector size;

  boolean taken = false;

  PImage texture;

  public RandomTreasure(PImage texture, PVector topLeft, PVector size) {
    this.topLeft = topLeft;
    this.size = size;
    this.texture = texture;
  }

  PVector getTopLeft() {
    return topLeft;
  }

  PVector getBottemRight() {

    return topLeft.add(size.x, size.y);
  }

  void take() {
    taken = true;
  }

  boolean taken() {
    return taken;
  }

  PImage getTexture() {
    return texture;
  }

  RandomTreasure setTexture(PImage texture) {
    this.texture = texture;
    return this;
  }

  void giveBonus()
  {
    // this is here to activate the inheritance treasure their code
  }
}

/**
 
 @author Nicolaas Schuddeboom
 De HealthPotion is een extentie van randomTreasure. Wanneer deze wordt opgepakt, krijg je 1 hartje erbij als je er niet 5 hebt
 
 */
class HealthPotion extends RandomTreasure
{
  HealthPotion(PImage texture, PVector topLeft, PVector size)
  {
    super(texture, topLeft, size);
  }

  void giveBonus()
  {
    if (player.currentLives < 5 && gameManager.getCurrentScene().totalLives < 5)
    {
      player.currentLives++;
      gameManager.getCurrentScene().totalLives++;
    }
  }
}

/**
 
 @author Nicolaas Schuddeboom
 De SprayShot is een extentie van randomTreasure. Wanneer deze wordt opgepakt, wordt je shot type voor 10 secondes veranderd en shiet je in een spray.
 
 */
class SprayShot extends RandomTreasure
{
  SprayShot(PImage texture, PVector topLeft, PVector size)
  {
    super(texture, topLeft, size);
  }

  void giveBonus()
  {
    combatManager.shotType = ShotType.SPRAY_SHOT;
    combatManager.time = 0;
    combatManager.bulletImage = gameManager.getCurrentScene().textures.bullets[0];
  }
}

/**
 
 @author Nicolaas Schuddeboom
 De ShotGun is een extentie van randomTreasure. Wanneer deze wordt opgepakt, wordt je shot type voor 10 secondes veranderd en shiet je alsof een shotgun.
 
 */
class ShotGun extends RandomTreasure
{
  ShotGun(PImage texture, PVector topLeft, PVector size)
  {
    super(texture, topLeft, size);
  }

  void giveBonus()
  {
    combatManager.shotType = ShotType.SHOT_GUN;
    combatManager.time = 0;
    combatManager.bulletImage = gameManager.getCurrentScene().textures.bullets[1];
  }
}
/**
 
 @author Nicolaas Schuddeboom
 In deze class zit de Key object. De key heeft een positie, size, texture en boolean of hij opgepakt is en wordt dan uitgeschakelt als hij opgepakt is.
 
 */

class Key
{
  // Declareer variables
  PVector topLeft;
  PVector size;

  boolean taken = false;

  PImage texture;

  // Initialiseer variables
  public Key(PImage texture, PVector topLeft, PVector size) 
  {
    this.topLeft = topLeft;
    this.size = size;
    this.texture = texture;
  }

  // Krijg de linker boven hoek van de key
  PVector getTopLeft() 
  {
    return topLeft;
  }

  // Krijg de rechter onder hoek van de key
  PVector getBottemRight() 
  {
    return topLeft.add(size.x, size.y);
  }

  // Pak sleutel en zet taken op true
  void take() 
  {
    taken = true;
  }

  // Check of de key is gepakt
  boolean taken() 
  {
    return taken;
  }

  // Get texture
  PImage getTexture()
  {
    return texture;
  }

  // Set texture
  Key setTexture(PImage texture)
  {
    this.texture = texture;
    return this;
  }
}
