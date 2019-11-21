class SceneLoader {

  final int playerSpawnCLR = color(255, 255, 255);

  HashMap<PVector, Tile> allTiles = new HashMap<PVector, Tile>();
  ArrayList<Wall> walls = new ArrayList<Wall>();
  ArrayList<Treasure> treasures = new ArrayList<Treasure>();
  ArrayList<RandomTreasure> randomTreasures = new ArrayList<RandomTreasure>();
  ArrayList<Tile> exits = new ArrayList<Tile>();
  ArrayList<Door> doors = new ArrayList<Door>();
  ArrayList<FloorSwitch> floorSwitches = new ArrayList<FloorSwitch>();
  ArrayList<Lever> levers = new ArrayList<Lever>();
  ArrayList<Key> keys = new ArrayList<Key>();
  ArrayList<Tile> floorTiles = new ArrayList<Tile>();
  ArrayList<EnemyTile> ogerTiles = new ArrayList<EnemyTile>();
  PVector playerSpawn;
  public SceneLoader(Scene scene) {

    int imgSize = scene.mapSize;

    ArrayList<Treasure> treasuresToGenerate = new ArrayList<Treasure>();

    Wall[][] wallTiles = new Wall[scene.mapSize][scene.mapSize];

    for (int x = 0; x < imgSize; x++) {
      for (int y = 0; y < imgSize; y++) {

        color c = scene.mapTexture.get(x, y);

        PVector pos = new PVector(x, y);
        PVector size = new PVector(Scene.resizeFac, Scene.resizeFac);

        //The underlying method uses the color the program is on to read if its a wall floor or treasure.
        if (c == Scene.wallCLR || c == Scene.wallCLR2) {
          Wall wall = new Wall(scene.textures.wallTexture, scene.miniMapColorWall, pos, size);
          allTiles.put(pos, wall);
          wallTiles[(int) pos.x][(int) pos.y] = wall;
        } else if (c == Scene.floorCLR) {//TODO floor tiles
          Tile tile = new Tile(scene.textures.floorTexture, scene.miniMapColorFloor, pos, size);          
          allTiles.put(pos, tile);
          floorTiles.add(tile);
        } else if (c == Scene.keyDoorCLR) {
          KeyDoor door = new KeyDoor(scene.textures.keyDoorClosedTexture, scene.textures.keyDoorOpenTexture, scene.miniMapColorDoor, pos, size);
          doors.add(door);
          allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorDoor, pos, size));
        } else if (c == Scene.switchDoorCLR) {
          SwitchDoor door = new SwitchDoor(scene.textures.switchDoorClosedTexture, scene.textures.switchDoorOpenTexture, scene.miniMapColorDoor, pos, size);
          doors.add(door);
          allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorDoor, pos, size));
        } else if (c == Scene.floorSwitchCLR) {
          FloorSwitch tile = new FloorSwitch(scene.textures.floorSwitchTexture, scene.textures.floorSwitchPressedTexture, scene.miniMapColorSwitch, pos, size);          
          allTiles.put(pos, tile);
          floorSwitches.add(tile);
        } else if (c == Scene.leverDoorCLR) {
          LeverDoor door = new LeverDoor(scene.textures.leverDoorClosedTexture, scene.textures.leverDoorOpenTexture, scene.miniMapColorDoor, pos, size);
          doors.add(door);
          allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorDoor, pos, size));
        } else if (c == Scene.closedLeverDoorCLR) {
          LeverDoor door = new LeverDoor(scene.textures.leverDoorClosedTexture, scene.textures.leverDoorOpenTexture, scene.miniMapColorDoor, pos, size);
          door.openDoor();
          doors.add(door);
          allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorDoor, pos, size));
        } else if (c == Scene.leverCLR) {
          Lever tile = new Lever(scene.textures.leverTexture, scene.textures.secondLeverTexture, scene.miniMapColorSwitch, pos, size);          
          allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorDoor, pos, size));
          levers.add(tile);
        } else if (c == Scene.treasureRandomCLR) {
          Treasure treasure = new Treasure(null, pos, size, 5);
          treasuresToGenerate.add(treasure);
          allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorFloor, pos, size));
        } else if (c == Scene.treasureEpicCLR) {
          Treasure treasure = new Treasure(scene.textures.treasure_textures[3], pos, size, 30);
          treasures.add(treasure);
          allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorFloor, pos, size));
        } else if (c == Scene.largeEnemyTerretoryCLR) {
          LargeEnemyTile ogrTile = new LargeEnemyTile(x, y);
          ogerTiles.add(ogrTile);
          allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorFloor, pos, size));
        } else if (c == Scene.mediumEnemyTerretoryCLR) {
          MediumEnemyTile ogrTile = new MediumEnemyTile(x, y);
          ogerTiles.add(ogrTile);
          allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorFloor, pos, size));
        } else if (c == Scene.smallEnemyTerretoryCLR) {
          SmallEnemyTile ogrTile = new SmallEnemyTile(x, y);
          ogerTiles.add(ogrTile);
          allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorFloor, pos, size));
        } else if (c == Scene.treasureRareCLR) {
          Treasure treasure = new Treasure(scene.textures.treasure_textures[2], pos, size, 20);
          treasures.add(treasure);
          allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorFloor, pos, size));
        } else if (c == Scene.randomTreasureCLR) {
          RandomTreasure treasure;
          switch((int)random(0, 3))
          {
            case(0):
            treasure = new HealthPotion(scene.textures.pickups[0], pos, size);
            randomTreasures.add(treasure);
            allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorFloor, pos, size));
            break;
            case(1):
            treasure = new SprayShot(scene.textures.pickups[1], pos, size);
            randomTreasures.add(treasure);
            allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorFloor, pos, size));
            break;
            case(2):
            treasure = new ShotGun(scene.textures.pickups[2], pos, size);
            randomTreasures.add(treasure);
            allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorFloor, pos, size));
            break;
          }
        } else if (c == Scene.exitCLR) {
          Tile exitTile = new Tile(scene.textures.exitTexture, scene.miniMapColorExit, pos, size);
          allTiles.put(pos, exitTile);
        } else if (c == Scene.trapCLR) {
          Tile trapTile = new Tile(scene.textures.trapTexture1, scene.miniMapColorTrap, pos, size);
          allTiles.put(pos, trapTile);
        } else if (c == Scene.keyCLR) {
          // Werkt hetzelfde als de treasure
          Key doorKey = new Key(scene.textures.keyTexture, pos, size);
          keys.add(doorKey);
          allTiles.put(pos, new Tile(scene.textures.floorTexture, scene.miniMapColorFloor, pos, size));
        } else if (c == playerSpawnCLR) {
          playerSpawn = new PVector(pos.x * Scene.resizeFac + Scene.resizeFac/2, pos.y * Scene.resizeFac + Scene.resizeFac/2);

          Tile tile = new Tile(scene.textures.floorTexture, scene.miniMapColorFloor, pos, size);          
          allTiles.put(pos, tile);
          floorTiles.add(tile);
        }
      }
    }
    //================================================================================================
    //WallTiles with black square on top
    //================================================================================================
    for (int x = 0; x < imgSize; x++) {
      for (int y = 0; y < imgSize; y++) {

        if (wallTiles[x][y] != null) {

          PVector above = new PVector(x, y-1);
          PVector underneith = new PVector(x, y+1);
          PVector left = new PVector(x-1, y);
          PVector right = new PVector(x+1, y);

          try {
            if (wallTiles[(int) above.x][(int) above.y] != null) {
              wallTiles[x][y].connect_top=true;
            }
          }
          catch(Exception e) {
          }

          try {
            if (wallTiles[(int) underneith.x][(int) underneith.y] != null) {
              wallTiles[x][y].connect_bottom=true;
            }
          }
          catch(Exception e) {
          }

          try {
            if (wallTiles[(int) left.x][(int) left.y] != null) {
              wallTiles[x][y].connect_left=true;
            }
          }
          catch(Exception e) {
          }

          try {
            if (wallTiles[(int) right.x][(int) right.y] != null) {
              wallTiles[x][y].connect_right=true;
            }
          }
          catch(Exception e) {
          }

          walls.add(wallTiles[x][y]);
        }
      }
    }


    //The underlying code fills a certain persentage of all the potential treasure locations with 60% common treasures and 40% uncommon treasures
    int treasureLocToHaveTreasureAmount = (int) (treasuresToGenerate.size() * 0.4);
    for (int i =0; i < treasureLocToHaveTreasureAmount; i++) {
      boolean done = false;
      while (!done) {
        int randomTreasure = (int) random(treasuresToGenerate.size());
        Treasure selectedTreasure = treasuresToGenerate.get(randomTreasure);
        if (selectedTreasure.texture == null) {
          int whichTreasure = (int) random(10);
          int treasureType = 0;
          int pointsAdd = 0;
          if ( whichTreasure <= 6) {
            //COMMON
            treasureType=0;
            pointsAdd = 5;
          } else {
            //UNCOMMON
            treasureType = 1;
            pointsAdd = 10;
          }
          treasures.add(selectedTreasure.setTexture(scene.textures.treasure_textures[treasureType]).setPointsAdd(pointsAdd));
          done = true;
        }
      }
    }
  }
}
