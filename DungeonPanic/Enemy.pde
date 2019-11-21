class Enemy {
  float x = -1000, y = -1000;//The oger position relative to world
  float rotation = 0;
  PVector velocity = new PVector();
  float walkSpeed;
  float runSpeed;
  int health;
  float knockBack;


  PImage enemyTexture;

  ArrayList<EnemyTile> tiles = new ArrayList<EnemyTile>();

  OgerStatus status = OgerStatus.Turning;

  float newRotation = 0;
  float rotationFelocity = 0;

  private PVector[] collisionPoints = new PVector[4];
  private PVector[] hitBoxCoords = new PVector[2];

  PVector playerLastVelocity = new PVector();

  boolean hitBy = false;
  boolean doneDamage = false;
  boolean canMove = true;

  public Enemy(Scene scene, ArrayList<EnemyTile> tiles, PImage enemyTexture) {
    this.tiles = tiles;//new ArrayList<EnemyTile>(tiles);
    this.enemyTexture = enemyTexture;

    int halfRange = (int) (Scene.resizeFac*1.3) /2;

    collisionPoints[0] = new PVector(halfRange, 0);
    collisionPoints[1] = new PVector(0, halfRange);

    collisionPoints[2] = new PVector(-halfRange, 0);
    collisionPoints[3] = new PVector(0, -halfRange);

    hitBoxCoords[0] = new PVector(-halfRange, - halfRange);
    hitBoxCoords[1] = new PVector(halfRange, halfRange);

    for (int i = tiles.size() - 1; i >= 0; i--)
    {
      int randomInt = (int)random(0, i + 1);

      EnemyTile tempVar = tiles.get(randomInt);
      tiles.set(randomInt, tiles.get(i));
      tiles.set(i, tempVar);
    }

    if (tiles.size() > 0 ) {

      int tempInt = 0;
      boolean spawnEnemy = false;
      for (int i = 0; i < tiles.size(); i++)
      {
        if (this instanceof LargeEnemy && tiles.get(i) instanceof LargeEnemyTile)
        {
          tempInt = i;
          spawnEnemy = true;
          break;
        }
        if (this instanceof MediumEnemy && tiles.get(i) instanceof MediumEnemyTile)
        {
          tempInt = i;
          spawnEnemy = true;
          break;
        }
        if (this instanceof SmallEnemy && tiles.get(i) instanceof SmallEnemyTile)
        {
          tempInt = i;
          spawnEnemy = true;
          break;
        }
      }
      if (spawnEnemy)
      {
        EnemyTile randomSpawnTile = this.tiles.get(tempInt);
        this.x = randomSpawnTile.x * Scene.resizeFac + Scene.resizeFac*1;
        this.y = randomSpawnTile.y * Scene.resizeFac + Scene.resizeFac*1;
      }
    }
    setNewRotation(random(360));
  }

  int i = 0;

  void reset() {
    for (int i = tiles.size() - 1; i >= 0; i--)
    {
      int randomInt = (int)random(0, i + 1);

      EnemyTile tempVar = tiles.get(randomInt);
      tiles.set(randomInt, tiles.get(i));
      tiles.set(i, tempVar);
    }

    if (tiles.size() > 0 ) {

      int tempInt = 0;
      boolean spawnEnemy = false;
      for (int i = 0; i < tiles.size(); i++)
      {
        if (this instanceof LargeEnemy && tiles.get(i) instanceof LargeEnemyTile)
        {
          tempInt = i;
          spawnEnemy = true;
          break;
        }
        if (this instanceof MediumEnemy && tiles.get(i) instanceof MediumEnemyTile)
        {
          tempInt = i;
          spawnEnemy = true;
          break;
        }
        if (this instanceof SmallEnemy && tiles.get(i) instanceof SmallEnemyTile)
        {
          tempInt = i;
          spawnEnemy = true;
          break;
        }
      }
      if (spawnEnemy)
      {
        EnemyTile randomSpawnTile = this.tiles.get(tempInt);
        this.x = randomSpawnTile.x * Scene.resizeFac + Scene.resizeFac*1;
        this.y = randomSpawnTile.y * Scene.resizeFac + Scene.resizeFac*1;
      }
    }
    doneDamage = false;
    playerLastVelocity = new PVector();
    hitBy = false;
  }
  void CanMove() {
    canMove = true;
  }
  void draw(Player player, Scene scene) {
    update(player, scene);
    int actualPosX = (int) (width/2+scene.position.x);
    int actualPosY = (int) (height/2+scene.position.y);

    float renderX = actualPosX + x;
    float renderY = actualPosY + y;

    imageMode(CENTER);
    translate(renderX, renderY);
    rotate(radians(rotation));
    image(enemyTexture, 0, 0, Scene.resizeFac * 1.3f, Scene.resizeFac * 1.3f);
    rotate(-radians(rotation));
    translate(-renderX, -renderY);
  }

  void update(Player player, Scene scene) {
    if (player.jump.jumping && hitBy) {//This if statement moves the player back when it hits the oger
      canMove = false;
      player.position.x -= (playerLastVelocity.x * DungeonPanic.delta * this.knockBack);
      player.checkForCollision(scene, new PVector((float) (-playerLastVelocity.x * DungeonPanic.delta * this.knockBack), 0));
      player.position.y -= (playerLastVelocity.y * DungeonPanic.delta * this.knockBack);
      player.checkForCollision(scene, new PVector(0, (float) (-playerLastVelocity.y * DungeonPanic.delta * this.knockBack)));
    } else {
      hitBy = false;
      canMove = true;
      playerLastVelocity = player.posInc;
      if (playerLastVelocity.x / DungeonPanic.delta < 0)
      {
        playerLastVelocity.x = -5.0;
      } else if (playerLastVelocity.x / DungeonPanic.delta > 0)
      {
        playerLastVelocity.x = 5.0;
      }

      if (playerLastVelocity.y / DungeonPanic.delta > 0)
      {
        playerLastVelocity.y = 5.0;
      } else if (playerLastVelocity.y / DungeonPanic.delta < 0)
      {
        playerLastVelocity.y = -5.0;
      }
    }

    if (scene.getColorFromMap((int)player.position.x/Scene.resizeFac, (int)player.position.y/Scene.resizeFac) == getCLR(this) && !doneDamage) {

      final float X1 = x;
      final float Y1 = y;

      final float X2 = player.position.x;
      final float Y2 = player.position.y;

      float dX = X2 - X1;

      float dY = Y2 - Y1;

      float angle = atan(dY / dX);

      rotation = (float) Math.toDegrees(angle);

      if (X2 > X1) {
        rotation = 180+rotation;
      }

      status = OgerStatus.Charging;
    } else if (scene.getColorFromMap((int)player.position.x/Scene.resizeFac, (int)player.position.y/Scene.resizeFac) == getCLR(this)) {
    } else {
      doneDamage = false;
      if (status == OgerStatus.Charging) {
        status = OgerStatus.Walking;
      }
    }

    switch(status) {
    case Turning:
      //println( newRotation + " " + rotation + " " + (newRotation - rotation) + " " + rotationFelocity);
      //Check wich side to turn
      rotation += rotationFelocity * DungeonPanic.delta/10;

      if (rotation < 0) {
        rotation = rotation + 360;
      }
      if (rotation > 360) {
        rotation = rotation - 360;
      }
      if (rotation-newRotation < 1f && rotation-newRotation > -1f) {
        status = OgerStatus.Walking;
      }

      if (isInHitBox(player.position.x, player.position.y)) {       
        player.jump.jump();
        hitBy=true;
        if (!scene.invincible)
        {
          gameManager.getCurrentScene().totalLives--;
          player.currentLives--;
          scene.invincible = true;
          player.invincibleTimer = gameManager.getCurrentScene().getTimeSpent();
        }
      }

      break;
    case Walking: 
      double xIncr = Math.sin(Math.toRadians(rotation-90)) * (DungeonPanic.delta/10) * walkSpeed;
      double yIncr = Math.cos(Math.toRadians(rotation-90)) * (DungeonPanic.delta/10) * walkSpeed;

      x += xIncr;
      y -= yIncr;

      boolean resetPos = false;

      for (PVector pvector : collisionPoints) {
        if (isColliding(scene, (int) (pvector.x + x), (int) (pvector.y + y))) {
          resetPos = true;
          break;
        }
      }

      if (isInHitBox(player.position.x, player.position.y)) {
        resetPos = true;

        player.jump.jump();
        hitBy=true;
        if (!scene.invincible)
        {
          gameManager.getCurrentScene().totalLives--;
          player.currentLives--;
          scene.invincible = true;
          player.invincibleTimer = gameManager.getCurrentScene().getTimeSpent();
        }
      }

      if (resetPos) {

        x -= xIncr;
        y += yIncr;

        status = OgerStatus.Turning;
        setNewRotation(random(360));
      }


      break;
    case Charging: 


      double xIncr2 = Math.sin(Math.toRadians(rotation-90)) * (DungeonPanic.delta/10) * walkSpeed * 2.5f;
      double yIncr2 = Math.cos(Math.toRadians(rotation-90)) * (DungeonPanic.delta/10) * walkSpeed * 2.5f;

      x += xIncr2;
      y -= yIncr2;

      boolean resetPos2 = false;

      for (PVector pvector : collisionPoints) {
        if (isColliding(scene, (int) (pvector.x + x), (int) (pvector.y + y))) {
          resetPos = true;
          break;
        }
      }

      if (isInHitBox(player.position.x, player.position.y)) {
        resetPos2 = true;

        player.jump.jump();
        hitBy=true;
        if (!doneDamage) {
          doneDamage = true;
          if (!scene.invincible)
          {
            gameManager.getCurrentScene().totalLives--;
            player.currentLives--;
            scene.invincible = true;
            player.invincibleTimer = gameManager.getCurrentScene().getTimeSpent();
          }
        }
      }

      if (resetPos2) {

        x -= xIncr2;
        y += yIncr2;

        status = OgerStatus.Turning;
        setNewRotation(random(360));
        doneDamage=true;
      }
      break;
    case Idle:

      break;
    }
  }

  int getCLR(Enemy enemy)
  {
    if (enemy instanceof LargeEnemy)
    {
      return Scene.largeEnemyTerretoryCLR;
    }
    if (enemy instanceof MediumEnemy)
    {
      return Scene.mediumEnemyTerretoryCLR;
    }
    if (enemy instanceof SmallEnemy)
    {
      return Scene.smallEnemyTerretoryCLR;
    }
    return Scene.largeEnemyTerretoryCLR;
  }

  public boolean isColliding(Scene scene, int x, int y) {
    color tileColor = scene.getColorFromMap((int) x/ Scene.resizeFac, (int) y / Scene.resizeFac);
    return tileColor != getCLR(this);
  }

  public boolean isInHitBox(float x, float y) {
    boolean inBox = false;
    if (x > hitBoxCoords[0].x + this.x && y > hitBoxCoords[0].y + this.y && x < hitBoxCoords[1].x + this.x && y < hitBoxCoords[1].y + this.y) {
      inBox=true;
    }
    return inBox;
  }

  public void setNewRotation(float newRotation) {
    int rotationSpeed = 10;
    this.newRotation = newRotation;
    if (newRotation - rotation < 180) {//Right turn
      rotationFelocity = (float) (rotationSpeed );
    } else {//Left turn
      rotationFelocity = (float)(-rotationSpeed);
    }
  }
}

class EnemyTile {

  int x, y; //These coords are acording to the preview image basically they are never above 100 each

  public EnemyTile(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

enum OgerStatus {
  Charging, Walking, Turning, Idle
}

public class LargeEnemy extends Enemy
{
  LargeEnemy(Scene scene, ArrayList<EnemyTile> tiles, PImage enemyTexture)
  {
    super(scene, tiles, enemyTexture);

    this.walkSpeed = 10;
    this.health = 10;
    this.knockBack = 1.5;
  }
}

public class MediumEnemy extends Enemy
{
  MediumEnemy(Scene scene, ArrayList<EnemyTile> tiles, PImage enemyTexture)
  {
    super(scene, tiles, enemyTexture);

    this.walkSpeed = 7.5;
    this.health = 3;
    this.knockBack = 1.25;
  }
}

public class SmallEnemy extends Enemy
{
  SmallEnemy(Scene scene, ArrayList<EnemyTile> tiles, PImage enemyTexture)
  {
    super(scene, tiles, enemyTexture);

    this.walkSpeed = 6;
    this.health = 1;
    this.knockBack = 1;
  }
}

public class LargeEnemyTile extends EnemyTile
{
  LargeEnemyTile(int x, int y)
  {
    super(x, y);
  }
}

public class MediumEnemyTile extends EnemyTile
{
  MediumEnemyTile(int x, int y)
  {
    super(x, y);
  }
}

public class SmallEnemyTile extends EnemyTile
{
  SmallEnemyTile(int x, int y)
  {
    super(x, y);
  }
}
