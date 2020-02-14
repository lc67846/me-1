boolean band;
ArrayList<bullet> bullets = new ArrayList<bullet>();
ArrayList<enemy> enemies = new ArrayList<enemy>();
ArrayList<Star> starcrawl = new ArrayList<Star>();
int bl=10, psecond, sh=0, lx, wallshade=0;
boolean start=true, gameplay=false, dead=false;
void setup() {
  fullScreen();
  lx=width/8;
  for (int i = 0; i<150; i++)starcrawl.add(new Star());
  noStroke();
}
void draw() {
  collisionHandler();
  guiHandler();
}
void guiHandler() {
  if (start) {
    background(0);
    fill(0, 255, 0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("LINE DEFENDER", width/2, height/10);
    textSize(15);
    text("Use the mouse to control your spaceship and click to fire, you can only fire behind the line. \n Your weapon will help in fending off the invaders attempting to repaint your wall an undesirable color \n click to continue", width/2, height/2);
    if (mousePressed) {
      gameplay=true;
      start=false;
    }
  }

  if (gameplay) {
    propHandler();
    if (wallshade>=255) {
      dead=true;
      gameplay=false;
      bl=10;
      wallshade=0;
    }
  }
  if (dead) {
    for (int i=0; i<bullets.size(); i++)bullets.remove(i);
    for (int i=0; i<enemies.size(); i++)enemies.remove(i);
    background(0);
    fill(0, 255, 0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Game Over", width/2, height/10);
    textSize(15);
    text("Click to try again.", width/2, height/2);
    if (mousePressed) {
      gameplay=true;
      dead=false;
    }
  }
}
void propHandler() {
  background(0);
  if (mousePressed && mouseX<width/8&&bl>0) {
    bullets.add(new bullet(mouseX, mouseY));
    bl--;
  }
  //display scrolling starfield
  for (Star s : starcrawl) {
    s.displayCrawl();
  }
  fill(124, 200, 112);
  text("bullets left: "+bl, width/50, width/50);
  text("line health: "+(255-wallshade), width/50, width/30);
  //draw borderline, change color with var
  fill(wallshade, 255-wallshade, 0);
  rect(lx, 0, width/36, height);
  lx+=.99;
  //draw cursor
  triangle(mouseX+25, mouseY, mouseX-5, mouseY-15, mouseX, mouseY);
  triangle(mouseX+25, mouseY, mouseX-5, mouseY+15, mouseX, mouseY);
  //draw/perform functions of enemies
  for (enemy b : enemies) {
    b.render();
  }
  //draw/perform functions of bullets
  for (bullet i : bullets) {
    i.render();
  }
  //add a few new enemies every few seconds
  if (second()!=psecond)sh=0;
  if (sh<5 && second()%2==0) {
    if (sh==0)psecond=second();
    sh++;
    bl++;
    enemies.add(new enemy(width-(width/50), int(map(randomGaussian(), -6, 6, 0, height))));
  }
}
void collisionHandler() {
  for (int y=enemies.size()-1; y>=0; y--) {
    enemy e = enemies.get(y);
    if (e.loc.x<width/7.5) {
      enemies.remove(y);
      wallshade+=e.health;
    }
    for (int i=bullets.size()-1; i>=0; i--) {
      bullet b = bullets.get(i);
      if (b.location.x>width||b.location.y>height)bullets.remove(i);
      if (b.location.x>e.loc.x-(25+e.health*5)&&b.location.x<e.loc.x&&b.location.y<e.loc.y+(15+e.health*5)&&b.location.y>e.loc.y-(15+e.health*5)) {
        bullets.remove(i);
        e.health--;
        if (e.health==0) { 
          enemies.remove(y);
          bl+=e.health;
        }
      }
    }
  }
}
class enemy {
  color c;
  int health;
  PVector accl, loc, vel;
  enemy(int _x, int _y) {
    loc= new PVector(_x, _y);
    vel=new PVector(0, 0);
    health=int(random(1, 5));
    c=color(map(randomGaussian(), -6, 6, 0, 255), map(randomGaussian(), -6, 6, 0, 255), map(randomGaussian(), -6, 6, 0, 255));
    accl = new PVector(-0.03, 0.0);
  }
  void render() {
    vel.add(accl);
    vel.limit(2);
    loc.add(vel);
    fill(c);
    triangle(loc.x-(25+health*5), loc.y, loc.x+(5+health*5), loc.y-(15+health*5), loc.x, loc.y);
    triangle(loc.x-(25+health*5), loc.y, loc.x+(5+health*5), loc.y+(15+health*5), loc.x, loc.y);
    PVector exhaust = accl.copy().normalize().rotate(radians(180));
    for (int i = 0; i < 5; i++) {
      PVector a = exhaust.copy();
      a.setMag(30*abs(randomGaussian()));
      float shift = 5*randomGaussian();
      a.rotate(radians(shift));
      stroke(c);
      strokeWeight(4);
      point(loc.x+a.x, loc.y+a.y);
      noStroke();
    }
    loc.y+=randomGaussian();
    if (loc.y < 0) loc.y = height/randomGaussian();
    if (loc.y > height) loc.y = height/randomGaussian();
  }
}

class bullet {
  PVector location;
  PVector velocity;
  PVector acceleration;
  bullet(int _x, int _y) {
    location = new PVector(_x, _y);
    velocity = new PVector(50, 0);
    acceleration = new PVector(0.01, 0);
  }

  void render() {
    location.add(velocity);
    velocity.add(acceleration);
    velocity.limit(10);
    fill(255, 0, 0);
    ellipse(location.x, location.y, 10, 10);
  }
}
class Star {
  float x, y, speed;
  Star() {
    x = random(width);
    y = random(height);
    speed=random(0, 10);
  }
  void displayCrawl() {
    fill(255);
    x-=speed;
    if (x<0)x=width;
    ellipse(x, y, 5, 5);
  }
}
