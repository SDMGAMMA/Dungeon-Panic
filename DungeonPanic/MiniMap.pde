/**
 
 @author Casper Klinkhamer
 Deze class heeft een minimap object. In dit object worden alle ontdekte tiles opgeslagen en wordt de minimap op het scherm weergeven
 
 */
class MiniMap {

  //Width and height is in sync with the map image;
  final int widthW = 300;
  final int heightH = 300;

  final int widthWBig = 500;
  final int heightHBig = 500;

  Scene map;

  //In this double array all the tiles are saved.
  Tile[][] allTiles;

  int resizeFac;

  //These coordinates are the cordinates the map will be display on the screen.
  int mapRenderX = width-widthW;
  int mapRenderY = 0;

  boolean enlargedMap = false;

  public MiniMap(Scene map) {
    this.map = map;
    allTiles = new Tile[map.mapSize][map.mapSize];
    resizeFac = widthW/map.mapSize;
  }

  public void addTile(PVector vector, Tile tile) {//In this method a tile is added if it is not already discovered.
    if (allTiles[(int)vector.x][(int)vector.y] == null) {
      allTiles[(int)vector.x][(int)vector.y] = tile;
    }
  }

  public void drawMiniMap(Player player) {//In this method the minimap is rendered. It also displays the player using a red dot wich moves tile based.
    int playerXOnMap = (int)player.position.x/Scene.resizeFac;
    int playerYOnMap = (int)player.position.y/Scene.resizeFac;

    int renderWidth = widthW;
    int renderHeight = heightH;

    if (enlargedMap) {
      renderHeight = heightHBig;
      renderWidth = widthWBig;
    }

    resizeFac = renderWidth/map.mapSize;

    mapRenderX = width-renderWidth;
    mapRenderY = 0;

    //Here the map reference image is rendered
    fill(0);
    rect(mapRenderX, mapRenderY, renderWidth, renderHeight);

    renderTiles(allTiles, mapRenderX, mapRenderY);


    fill(255, 0, 0);
    ellipse(mapRenderX + playerXOnMap * resizeFac + resizeFac/2, mapRenderY+playerYOnMap * resizeFac + resizeFac/2, resizeFac, resizeFac);
  }

  int renderedTiles = 0;
  public void renderTiles(Tile[][] tiles, int posX, int posY) {//In this method all of the discoverd tiles are rendered.
    renderedTiles=0;
    for (int x = 0; x < map.mapSize; x++) {
      for (int y = 0; y < map.mapSize; y++) {
        Tile tile = null;
        try {
          tile = tiles[x][y];
        }
        catch(Exception e) {
        }
        if (tile != null) {
          renderedTiles++;
          float xx = posX + tile.topLeft.x * resizeFac;
          float yy= posY + tile.topLeft.y * resizeFac;

          fill(tile.getMiniMapColor().x, tile.getMiniMapColor().y, tile.getMiniMapColor().z);
          rect(xx, yy, tile.size.x/Scene.resizeFac*resizeFac, tile.size.y/Scene.resizeFac*resizeFac);
        }
      }
    }
  }

  void keyPressed() {
    if (keyCode == 'T') {
      enlargedMap = !enlargedMap;
    }
  }
}
