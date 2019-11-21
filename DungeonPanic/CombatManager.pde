class CombatManager {
  PVector bulletPosition = new PVector(width/2, height/2);
  ArrayList<Bullet> bullets = new ArrayList(); 
  int i;
  boolean isKilled = false;
  float cooldown = 0.3;

  int duration = 75;
  float time = 0;

  PImage bulletImage = gameManager.getCurrentScene().textures.bullets[0];
  ShotType shotType = ShotType.NORMAL_SHOT;

  void draw() {
    noStroke();
    handleBullets();
    if (cooldown > 0) {
      cooldown -= DungeonPanic.delta/100;
    }
    if (shotType != ShotType.NORMAL_SHOT)
    {
      time += (DungeonPanic.delta/10.0);

      if (time > duration)
      {
        bulletImage = gameManager.getCurrentScene().textures.bullets[0];
        shotType = ShotType.NORMAL_SHOT;
      }
    }
  }

  void handleBullets() {
    for ( i = bullets.size(); i != 0; ) {
      if ( bullets.get(--i).run() ) {
        bullets.remove(i);
      }
    }
  }
  void keyPressed(Player player) {
    if (key =='a' && DungeonPanic.gameManager.currentGameState == GameState.INGAME && cooldown <= 0)
    {
      gunSound.play();
      gunSound.rewind();

      switch(shotType)
      {
      case NORMAL_SHOT:
        addBullet(player);
        break;
      case SPRAY_SHOT:
        addSprayBullets(player);
        break;
      case SHOT_GUN:
        addShotGunBullets(player);
        break;
      }

      cooldown = 0.3;
    }
  }

  void addBullet(Player player) {
    PVector bulletSpeed = new PVector();
    float speed = 15.0f;
    double xIn = Math.sin(Math.toRadians(player.rotation)) * speed;
    double yIn = Math.cos(Math.toRadians(player.rotation)) * speed;

    bulletSpeed.set((float)xIn, -(float)yIn);
    bullets.add( new Bullet(new PVector(player.position.x + 0, player.position.y + 0), bulletSpeed, speed) );
  }

  void addSprayBullets(Player player)
  {
    float rotation = PI / 15;
    int amount = 5;

    PVector bulletSpeed = new PVector();
    float speed = 15.0f;
    double xIn = Math.sin(Math.toRadians(player.rotation)) * speed;
    double yIn = Math.cos(Math.toRadians(player.rotation)) * speed;

    PVector direction = new PVector((float)xIn, (float)yIn);

    direction.rotate((amount / 2f - 0.5) * rotation);

    for (int i = 0; i < amount; i++)
    {
      bulletSpeed.set(direction.x, -direction.y);
      bullets.add( new Bullet(new PVector(player.position.x + 0, player.position.y + 0), new PVector(bulletSpeed.x, bulletSpeed.y), speed) );

      direction.rotate(-rotation);
    }
  }

  void addShotGunBullets(Player player)
  {
    float rotation = PI / 25;
    int amount = 7;

    PVector bulletSpeed = new PVector();
    float minSpeed = 10.0f;
    float maxSpeed = 15.0f;
    double xIn = Math.sin(Math.toRadians(player.rotation)) * minSpeed;
    double yIn = Math.cos(Math.toRadians(player.rotation)) * minSpeed;

    for (int i = 0; i < amount; i++)
    {
      PVector direction = new PVector((float)xIn, (float)yIn);

      direction.rotate(random(-rotation, rotation));

      bulletSpeed.set(direction.x, -direction.y);
      bullets.add( new Bullet(new PVector(player.position.x + 0, player.position.y + 0), new PVector(bulletSpeed.x, bulletSpeed.y), random(minSpeed, maxSpeed)) );
    }
  }

  class Bullet extends PVector {
    CombatManager manager = new CombatManager();
    float speed;
    boolean fired;
    PVector velocity;
    color bulletColor = #FFFF00;
    Bullet(PVector loc, PVector vel, float speed) {
      super(loc.x, loc.y);
      this.velocity = vel;
      this.speed = speed;
    }

    void display() {
      int bulletSize = 10;
      fill(bulletColor);
      Scene scene = gameManager.getCurrentScene();
      int actualPosX = (int) (width/2+scene.position.x);
      int actualPosY = (int) (height/2+scene.position.y);

      image(bulletImage, actualPosX+x, actualPosY+y, bulletSize, bulletSize);
      //ellipse(actualPosX+x, actualPosY+y, bulletSize, bulletSize);
      Collision(scene, (int)x, (int)y);
    }

    void Collision(Scene scene, int bulletx, int bullety) {

      bullets.get(i);

      color colortiles = scene.getColorFromMap( bulletx/Scene.resizeFac, bullety/Scene.resizeFac);
      if ( colortiles == Scene.wallCLR || colortiles == Scene.wallCLR2 || colortiles == Scene.closedLeverDoorCLR) { // Collision with Tiles
        bullets.remove(i);
      } else 
      {
        for (int j = gameManager.getCurrentScene().enemies.size() - 1; j >= 0; j--) {
          if (gameManager.getCurrentScene().enemies.get(j).isInHitBox(bulletx, bullety)) { //Ogre collision      
            gameManager.getCurrentScene().enemies.get(j).health -= 1;
            if (gameManager.getCurrentScene().enemies.get(j).health == 0) {
              gameManager.getCurrentScene().enemies.remove(j);
            }
            try
            {
              bullets.remove(i);
            }
            catch(Exception e)
            {
              println("You have hit 2 enemies at the same time");
            }
          }
        }
      }
    }

    boolean run() {
      display();

      velocity.normalize();
      velocity.mult((float)(speed * DungeonPanic.delta));
      add(velocity);

      return fired;
    }
  }
}

enum ShotType
{
  NORMAL_SHOT, SPRAY_SHOT, SHOT_GUN;
}
