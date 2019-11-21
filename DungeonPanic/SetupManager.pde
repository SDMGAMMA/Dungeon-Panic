/**
 
 @author Casper Klinkhametr
 In deze class laadt het spel alle essentiele data. Onderandere huidige 2 scenes.
 
 */

class SetupManager {
  Player player;

  Scene[] levels;

  PImage[] treasureTexture = new PImage[4];
  PImage[] bulletTexture = new PImage[2];
  PImage[] pickupTexture = new PImage[3];

  public SetupManager() {
    this.setup();
  }

  void setup() {
    treasureTexture[0] = loadImage("treasures/treasure_common.png");
    treasureTexture[1] = loadImage("treasures/treasure_uncommon.png");
    treasureTexture[2] = loadImage("treasures/treasure_rare.png");
    treasureTexture[3] = loadImage("treasures/treasure_epic.png");

    bulletTexture[0] = loadImage("bullets/normalBullet.png");
    bulletTexture[1] = loadImage("bullets/shotGunPellet.png");

    pickupTexture[0] = loadImage("pickups/potion.png");
    pickupTexture[1] = loadImage("pickups/sprayShotPickup.png");
    pickupTexture[2] = loadImage("pickups/shotGunPickup.png");

    levels = new Scene[5];

    SceneTextures textures = new SceneTextures(treasureTexture, loadImage("wallImages/wall1.jpg"), loadImage("floorImages/floor1.png"), loadImage("doorImages/door1.png"), loadImage("doorImages/door2.png"), loadImage("doorImages/buttonDoor1.png"), loadImage("doorImages/buttonDoor2.png"), loadImage("floorButtonImages/button1.png"), loadImage("floorButtonImages/button2.png"), loadImage("doorImages/leverDoor1.png"), loadImage("doorImages/leverDoor2.png"), loadImage("leverImages/lever1.png"), loadImage("leverImages/lever2.png"), loadImage("trapImages/trap1.png"), loadImage("trapImages/trap2.png"), loadImage("keyImages/key1.png"), loadImage("exitImages/exit1.jpg"), loadImage("ogreImages/ogre1.png"), loadImage("skeletonImages/skeleton1.png"), loadImage("goblinImages/goblin1.png"), bulletTexture, pickupTexture);

    levels[0] = new Scene(loadImage("level_1/map.png"), textures, new PVector(0, 0));
    levels[1] = new Scene(loadImage("level_2/map.png"), textures, new PVector(0, 0));
    levels[2] = new Scene(loadImage("level_3/map.png"), textures, new PVector(0, 0));
    levels[3] = new Scene(loadImage("level_4/map.png"), textures, new PVector(0, 0));
    levels[4] = new Scene(loadImage("level_5/map.png"), textures, new PVector(0, 0));

    player = new Player();
  }
}
