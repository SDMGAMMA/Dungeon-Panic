/**
 
 @author Casper Klinkhamer
 Deze class heeft een map object. In dat object bewaart hij informatie die balangerijk zijn voor de art van de map en de hitboxes van de map. Ook zorgt dit object er voor dat de juiste textures op je juiste positie staan.
 
 */
class Scene {

  PImage mapTexture;

  SceneTextures textures;

  PVector position;

  MiniMap miniMap;

  //Hier onder staan de lijsten met alle entities die gerendert moeten worden en geupdate.
  HashMap<PVector, Tile> allTiles = new HashMap<PVector, Tile>();
  ArrayList<Wall> walls = new ArrayList<Wall>();
  ArrayList<Tile> floorTiles = new ArrayList<Tile>();
  ArrayList<Treasure> treasures = new ArrayList<Treasure>();
  ArrayList<RandomTreasure> randomTreasures = new ArrayList<RandomTreasure>();
  ArrayList<Tile> exits = new ArrayList<Tile>();
  ArrayList<Door> doors = new ArrayList<Door>();
  ArrayList<Lever> levers = new ArrayList<Lever>();
  ArrayList<FloorSwitch> floorSwitches = new ArrayList<FloorSwitch>();
  ArrayList<Key> keys = new ArrayList<Key>();
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();

  static final int wallCLR = -16711936, wallCLR2 = -16711903;
  static final int floorCLR = -16777216;
  static final int keyDoorCLR = -8438016; //(127, 63, 0) / #7f3f00
  static final int switchDoorCLR = -16744577; //(0, 127, 127) / #007f7f
  static final int floorSwitchCLR = -16740353; //(0, 143, 255) / #007fff
  static final int leverDoorCLR = -33024; //(255, 175, 95) / #ff7f00255, 175, 95
  static final int closedLeverDoorCLR = -20641; //(255, 127, 0) / #ffaf5f
  static final int leverCLR = -32769; //(255, 127, 255) / #ff7fff
  static final int treasureRandomCLR = -256; //(255, 255, 0)
  static final int treasureEpicCLR = -12058369; //(72, 0, 255)
  static final int treasureRareCLR = -16711681; //(0, 255, 255)
  static final int randomTreasureCLR = -65281; //#ff00ff (255, 0, 255)
  static final int exitCLR = -16776961; //(0, 0, 255)
  static final int trapCLR = -6388992; //(158, 131, 0)
  static final int keyCLR = -8421632; //(127, 127, 0) / #7f7f00
  static final int largeEnemyTerretoryCLR = -29696; //#ff8c00 (255, 140, 0)
  static final int mediumEnemyTerretoryCLR = -65536; //(255, 0, 0)
  static final int smallEnemyTerretoryCLR = -5635841; //aa00ff (170, 0, 255)

  PVector playerSpawn;

  final PVector miniMapColorWall = new PVector(255, 255, 255);

  final PVector miniMapColorFloor = new PVector(40, 40, 40);
  final PVector miniMapColorExit = new PVector(50, 255, 50);
  final PVector miniMapColorTrap = new PVector(150, 150, 150);  
  final PVector miniMapColorDoor = new PVector(127, 52, 0 );
  final PVector miniMapColorSwitch = new PVector(0, 0, 255);
  static final int resizeFac = 130;

  private float timeSpent = 0;
  boolean sceneStarted = false;

  private int totalLives = 5;
  private boolean invincible = false;

  public int mapSize = 0;

  public Scene(PImage mapTexture, SceneTextures textures, PVector position) {
    mapSize = mapTexture.width;

    this.mapTexture = mapTexture;
    this.position = position;
    this.textures = textures;

    SceneLoader sceneLoader = new SceneLoader(this);
    allTiles = sceneLoader.allTiles;
    treasures = sceneLoader.treasures;
    randomTreasures = sceneLoader.randomTreasures;
    exits = sceneLoader.exits;
    doors = sceneLoader.doors;
    floorSwitches = sceneLoader.floorSwitches;
    levers = sceneLoader.levers;
    keys = sceneLoader.keys;    
    walls = sceneLoader.walls;
    floorTiles = sceneLoader.floorTiles;
    playerSpawn = sceneLoader.playerSpawn;

    enemies.add(new LargeEnemy(this, sceneLoader.ogerTiles, textures.ogreTexture));
    enemies.add(new MediumEnemy(this, sceneLoader.ogerTiles, textures.goblinTexture));
    enemies.add(new SmallEnemy(this, sceneLoader.ogerTiles, textures.skeletonTexture));
    miniMap = new MiniMap(this);
  }

  public void update(Player player) {
    if (sceneStarted) {
      timeSpent+=DungeonPanic.delta/100;
    }
    setPosition(-player.position.x, -player.position.y);
    if (timeSpent <= 0) {
      player.canMove = false;
      timeSpent = 0;
    }
  }

  public void start(Player player) {
    if (!sceneStarted) {
      sceneStarted = true;
      player.canMove = true;
      if (playerSpawn != null) {
        player.position = new PVector(playerSpawn.x, playerSpawn.y, 1);
      } else {
        player.position = new PVector(width/1.5, height/2);
      }
    }
  }

  public void stop(Player player) {
    player.canMove = false;
  }

  public void restart(Player player) {
    timeSpent=0;
    sceneStarted = false;
    totalLives = player.currentLives;

    for (int i = enemies.size()-1; i >= 0; i--)
    {
      enemies.remove(i);
    }

    invincible = false;
    SceneLoader sceneReloader = new SceneLoader(this);
    enemies.add(new LargeEnemy(this, sceneReloader.ogerTiles, textures.ogreTexture));
    enemies.add(new MediumEnemy(this, sceneReloader.ogerTiles, textures.goblinTexture));
    enemies.add(new SmallEnemy(this, sceneReloader.ogerTiles, textures.skeletonTexture));

    for (FloorSwitch floorSwitch : floorSwitches)
    {
      floorSwitch.unpressSwitch();
    }
    
    for(RandomTreasure treasure : randomTreasures)
    {
      treasure.taken = false;
    }

    for (Door door : doors)
    {
      if (door instanceof LeverDoor)
      {
        if ((this.mapTexture.get((int)door.getTopLeft().x, (int)door.getTopLeft().y) == Scene.leverDoorCLR && door.checkState()) || (this.mapTexture.get((int)door.getTopLeft().x, (int)door.getTopLeft().y) == Scene.closedLeverDoorCLR && !door.checkState()))
        {
          for (Door door2 : doors)
          {
            if (door2 instanceof LeverDoor)
            {
              door.open = !door.checkState();
            }
          }
        }
        break;
      }
    }

    treasures = sceneReloader.treasures;
    doors = sceneReloader.doors;
    keys = sceneReloader.keys;    
    untriggerTraps();
    miniMap = new MiniMap(this);
    spawnPlayer();
  }

  public void spawnPlayer() {
    if (playerSpawn != null) {
      player.position = new PVector(playerSpawn.x, playerSpawn.y, 2);
    } else {
      player.position = new PVector(width/1.5, height/2);
    }
  }

  public int getTimeSpent() {
    return (int) (timeSpent);
  }

  public float getFloatTime()
  {
    return timeSpent;
  }

  public int getLives()
  {
    return totalLives;
  }

  public void setWallTexture(PImage wall) {
    textures.wallTexture = wall;
  }
  public void setFloorTexture(PImage floor) {
    textures.floorTexture = floor;
  }

  public void triggerTraps()
  {
    textures.trapTexture1 = textures.trapTexture2;
    SceneLoader sceneReloader = new SceneLoader(this);
    allTiles = sceneReloader.allTiles;
  }

  public void untriggerTraps()
  {
    textures.trapTexture1 = textures.tempTrap;
    SceneLoader sceneReloader = new SceneLoader(this);
    allTiles = sceneReloader.allTiles;
  }

  public void setPosition(float x, float y) {//This method is called in the main class and is the negitive position of the player "position"
    position.x = x;
    position.y = y;
  }

  color getColorFromMap(int x, int y) {//this method gets the color from a specific position of the map referance image
    return mapTexture.get(x, y);
  }

  void drawMap(Player player) {//In deze methode worden alle objecten op het scherm gerenderet.
    int actualPosX = (int) (width/2+position.x)+ resizeFac/2;
    int actualPosY = (int) (height/2+position.y)+ resizeFac/2;

    //Elk van de onderstaande for loops tekent de textures op de voorbeeld afbeelding en berekend of ze in de buurt van het frame staat. Als ze niet in de buurt van het frame staan worden ze niet ge renderd.
    renderTiles(allTiles, actualPosX, actualPosY);

    renderTreasuresKeysDoors(actualPosX, actualPosY);
    renderSwitchesLevers(actualPosX, actualPosY);

    for (int i = 0; i < enemies.size(); i++)
    {
      enemies.get(i).draw(player, this);
    }

    //render cut offs
    fill(0);
    rectMode(CORNER);
    rect(actualPosX-Scene.resizeFac/2, actualPosY-Scene.resizeFac, 50*Scene.resizeFac, Scene.resizeFac);
    rect(actualPosX-Scene.resizeFac, actualPosY-Scene.resizeFac/2, Scene.resizeFac, 50*Scene.resizeFac);
    rect(actualPosX-Scene.resizeFac/2, actualPosY-Scene.resizeFac+ Scene.resizeFac*50, 50*Scene.resizeFac, Scene.resizeFac);
    rect(actualPosX-Scene.resizeFac + Scene.resizeFac*50, actualPosY-Scene.resizeFac/2, Scene.resizeFac, 50*Scene.resizeFac);
  }

  private void renderTreasuresKeysDoors(int actualPosX, int actualPosY) {//In this method all the keys treasures and doors are rendered on top of floor tiles 

    for (Treasure treasure : treasures) {
      float x = actualPosX + treasure.topLeft.x * resizeFac;
      float y = actualPosY + treasure.topLeft.y * resizeFac;

      if (!treasure.taken()) {
        image(treasure.getTexture(), x, y, (int) treasure.size.x, (int) treasure.size.y);
      }
    }

    for (RandomTreasure treasure : randomTreasures) {
      float x = actualPosX + treasure.topLeft.x * resizeFac;
      float y = actualPosY + treasure.topLeft.y * resizeFac;

      if (!treasure.taken()) {
        image(treasure.getTexture(), x, y, (int) treasure.size.x, (int) treasure.size.y);
      }
    }

    // Works the same as the treasure forloop above
    for (Key doorKey : keys) 
    {
      float x = actualPosX + doorKey.topLeft.x * resizeFac;
      float y = actualPosY + doorKey.topLeft.y * resizeFac;

      if (!doorKey.taken()) {
        image(doorKey.getTexture(), x, y, (int) doorKey.size.x, (int) doorKey.size.y);
      }
    }

    for (Door door : doors) 
    {
      float x = actualPosX + door.topLeft.x * resizeFac;
      float y = actualPosY + door.topLeft.y * resizeFac;

      if (!door.checkState()) {
        image(door.getTexture(), x, y, (int) door.size.x, (int) door.size.y);
      } else if (door.open)
      {
        image(door.getOpenTexture(), x, y, (int) door.size.x, (int) door.size.y);
      }
    }

    renderWalls(actualPosX, actualPosY);
  }

  private void renderSwitchesLevers(int actualPosX, int actualPosY)
  {
    for (Lever lever : levers) 
    {
      float x = actualPosX + lever.topLeft.x * resizeFac;
      float y = actualPosY + lever.topLeft.y * resizeFac;

      image(lever.getTexture(), x, y, (int) lever.size.x, (int) lever.size.y);
    }

    for (FloorSwitch floorSwitch : floorSwitches)
    {
      float x = actualPosX + floorSwitch.topLeft.x * resizeFac;
      float y = actualPosY + floorSwitch.topLeft.y * resizeFac;

      if (floorSwitch.pressed())
      {
        image(floorSwitch.getPressedTexture(), x, y, (int) floorSwitch.size.x, (int) floorSwitch.size.y);
      } else
      {
        image(floorSwitch.getTexture(), x, y, (int) floorSwitch.size.x, (int) floorSwitch.size.y);
      }
    }
  }

  private void renderWalls(int actualPosX, int actualPosY) {//TODO add the black part to the render
    for (Wall wall : walls) 
    {

      float x = actualPosX + wall.topLeft.x * resizeFac;
      float y = actualPosY + wall.topLeft.y * resizeFac;

      if (x>0-resizeFac && x< width+resizeFac) {
        if (y>0-resizeFac && y <height+resizeFac) {
          imageMode(CENTER);
          image(wall.getTexture(), x, y, wall.size.x, wall.size.y);

          float xCorBlack = x - ((Scene.resizeFac/2)*0.6);
          float yCorBlack = y - ((Scene.resizeFac/2)*0.6);
          float rectSize = Scene.resizeFac*0.6;
          rectMode(CORNER);
          fill(0);
          rect(xCorBlack, yCorBlack, rectSize, rectSize);

          if (wall.connect_top) {
            float tX = xCorBlack;
            float tY = y-Scene.resizeFac/2;
            rect(tX, tY, Scene.resizeFac*0.6, Scene.resizeFac*0.4);
          }

          if (wall.connect_bottom) {
            float bX = xCorBlack;
            float bY = y+Scene.resizeFac/4;
            rect(bX, bY, rectSize, rectSize);
          }

          if (wall.connect_left) {

            float bX = x-Scene.resizeFac/2;
            float bY = yCorBlack;
            rect(bX, bY, Scene.resizeFac*0.5, Scene.resizeFac*0.6);
          }

          if (wall.connect_right) {
            float bX = x+Scene.resizeFac/4;
            float bY = yCorBlack;
            rect(bX, bY, Scene.resizeFac*0.5, Scene.resizeFac*0.6);
          }
        }
      }
    }
  }

  public void renderTiles(HashMap<PVector, Tile> tiles, int posX, int posY) {//In this method all the floor/tiles tiles are rendered.
    for (Tile tile : tiles.values()) {
      if (tile.getTexture() != null) {

        float x = posX + tile.topLeft.x * resizeFac;
        float y = posY + tile.topLeft.y * resizeFac;

        if (x>0-resizeFac && x< width+resizeFac) {
          if (y>0-resizeFac && y <height+resizeFac) {
            imageMode(CENTER);
            if (!(tile instanceof Wall)) {
              image(tile.getTexture(), x, y, tile.size.x, tile.size.y);
            }
          }
        }
      }
    }
  }

  private void updateMiniMap(Player player) {//In this method the map is updated with the new discovered "tiles"
    int playerPosOnMapX = ((int) (player.position.x))/resizeFac;
    int playerPosOnMapY = ((int) (player.position.y))/resizeFac;  
    for (int x = 0; x < 3; x++) {
      for (int y = 0; y < 3; y++) {
        int xPos = playerPosOnMapX + x - 1;
        int yPos = playerPosOnMapY + y - 1;
        PVector posOnMap = new PVector(xPos, yPos);
        try {
          Tile tile = allTiles.get(posOnMap);
          miniMap.addTile(posOnMap, tile);
        }
        catch(Exception e) {
        }
      }
    }
  }
}

class SceneTextures { 

  PImage wallTexture;
  PImage floorTexture;
  PImage trapTexture1;
  PImage trapTexture2;
  PImage tempTrap;
  PImage[] treasure_textures;
  PImage keyTexture;
  PImage keyDoorClosedTexture;
  PImage keyDoorOpenTexture;
  PImage switchDoorClosedTexture;
  PImage switchDoorOpenTexture;
  PImage leverDoorClosedTexture;
  PImage leverDoorOpenTexture;
  PImage leverTexture;
  PImage secondLeverTexture;
  PImage floorSwitchTexture;
  PImage floorSwitchPressedTexture;
  PImage exitTexture;
  PImage ogreTexture;
  PImage skeletonTexture;
  PImage goblinTexture;
  PImage[] bullets;
  PImage[] pickups;

  public SceneTextures(PImage[] treasure_textures, PImage wallTexture, PImage floorTexture, PImage keyDoorClosedTexture, PImage keyDoorOpenTexture, PImage switchDoorClosedTexture, PImage switchDoorOpenTexture, PImage floorSwitchTexture, PImage floorSwitchPressedTexture, PImage leverDoorClosedTexture, PImage leverDoorOpenTexture, PImage leverTexture, PImage secondLeverTexture, PImage trapTexture1, PImage trapTexture2, PImage keyTexture, PImage exitTexture, PImage ogreTexture, PImage skeletonTexture, PImage goblinTexture, PImage[] bullets, PImage[] pickups) {
    this.treasure_textures = treasure_textures;
    this.wallTexture = wallTexture;
    this.floorTexture = floorTexture;
    this.keyDoorClosedTexture = keyDoorClosedTexture;
    this.keyDoorOpenTexture = keyDoorOpenTexture;
    this.switchDoorClosedTexture = switchDoorClosedTexture;
    this.switchDoorOpenTexture = switchDoorOpenTexture;
    this.floorSwitchTexture = floorSwitchTexture;
    this.floorSwitchPressedTexture = floorSwitchPressedTexture;
    this.leverDoorClosedTexture = leverDoorClosedTexture;
    this.leverDoorOpenTexture = leverDoorOpenTexture;
    this.leverTexture = leverTexture;
    this.secondLeverTexture = secondLeverTexture;
    this.trapTexture1 = trapTexture1;
    this.tempTrap = trapTexture1;
    this.trapTexture2 = trapTexture2;
    this.keyTexture = keyTexture;
    this.exitTexture = exitTexture;
    this.ogreTexture = ogreTexture;
    this.skeletonTexture = skeletonTexture;
    this.goblinTexture = goblinTexture;
    this.bullets = bullets;
    this.pickups = pickups;
  }
}
