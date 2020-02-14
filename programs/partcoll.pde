ArrayList<drop> drops = new ArrayList<drop>();
crater setPiece;
PVector mouse;
void setup() {
  mouse=new PVector(0, 0);
  setPiece = new crater();
  fullScreen();
}


void draw() {
  background(245);
  fill(0);
  text("This is a simulation meant to copy the properties of fluids in the real world.\n Oil, having high viscosity won't stick around too long, slipping over the edge.\n Sludge, however is too slow, and will more often than not seep into the earth below.\n Water is the middleground between the two fluids.\n If any of the three fluids is left to stagnate, it will seep into the earth and rejoin the aquifer below.\n Feel free to grab any of the handles on the mountain and watch as the particles react to the changes", width/20, height/20);
  mouse.set(mouseX, mouseY);

  setPiece.update();
  if (!setPiece.colliding(mouse.x, mouse.y)) {
    if (frameCount % 6 == 0) drops.add(new Water(mouse));
    if (frameCount % 6 == 1) drops.add(new Sludge(mouse));
    if (frameCount % 6 == 2) drops.add(new Oil(mouse));
  }
  for (drop p : drops) {
    PVector gravAcc = new PVector(0, 0.2);
    PVector gravity = gravAcc.copy().mult(p.mass);
    p.applyForce(gravity);
    if (setPiece.colliding(p.location.x, p.location.y)) {
      p.velocity.mult(-.7);//allows particles to seep into the ground, like in real life
    };
    if (setPiece.colliding(p.location.x-p.diameter/2, p.location.y))p.velocity.add(p.vis, 0);//l/r coll
    if (setPiece.colliding(p.location.x+p.diameter/2, p.location.y))p.velocity.add(-p.vis, 0);

    if (setPiece.colliding(p.location.x, p.location.y-p.diameter/2))p.velocity.add(p.vis, 0);//u/d coll
    if (setPiece.colliding(p.location.x, p.location.y+p.diameter/2))p.velocity.add(-p.vis, 0);
    p.update();
  }
}


class crater {
  PVector[] verts=new PVector[5];
  float d=20.0;
  crater() {
    verts[0]=new PVector(width/2+width/6, height/2-height/4);
    verts[1]=new PVector(width/2, height/2);
    verts[2]=new PVector(width/2-width/6, height/2-height/4);
    verts[3]=new PVector(width/2-width/3, height/2+height/4);
    verts[4]=new PVector(width/2+width/3, height/2+height/4);
  }
  void update() {
    for (int i=0; i<verts.length; i++) {
      if ((mouse.copy().sub(verts[i])).mag()<d&&mousePressed) {
        fill(255, 0, 0);
        ellipse(verts[i].x, verts[i].y, d, d);
        verts[i].add(mouse.copy().sub(verts[i]));
      } else {
        fill(0, 0, 255);
        ellipse(verts[i].x, verts[i].y, d, d);
      }
    }
    fill(0);
    beginShape();
    vertex(verts[0].array());
    vertex(verts[1].array());
    vertex(verts[2].array());
    vertex(verts[3].array());
    vertex(verts[4].array());
    endShape(CLOSE);
  }
  boolean colliding(float x, float y) {
    int prev=verts.length-1;
    boolean returns=false;
    for (int i = 0; i < verts.length; i++) {
      if ((((verts[i].y <= y) && (y < verts[prev].y)) ||((verts[prev].y <= y) && (y < verts[i].y))) &&(x < (verts[prev].x - verts[i].x) * (y - verts[i].y) / (verts[prev].y - verts[i].y) + verts[i].x)) {
        returns=!returns;
      }
      prev=i;
    }
    return returns;
  }
}

class drop {
  PVector location, velocity, acceleration;
  color c;
  float lifespan, age, diameter, mass, angle, vis;
  drop(PVector l) {
    location = l.copy();
    velocity = new PVector(random(-2, 2), random(-5, 0));
    acceleration = new PVector(0, 0);
    diameter = random(5, 15);
    mass = diameter / 5.0;
    age = 0;
    lifespan = 60;
  }

  void display() {
    stroke(0);
    fill(c, lifespan);
    ellipseMode(CENTER);
    pushMatrix();
    translate(location.x, location.y);
    rotate(angle);
    ellipse(0, 0, diameter, diameter);
    popMatrix();
  }

  void update() {
    move();
    display();
    age++;
  }

  void move() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void applyForce(PVector f) {
    PVector a = f.copy().div(mass);
    acceleration.add(a);
  }

  boolean isDead() {
    if (age > lifespan) return true;
    return false;
  }
}

class Water extends drop {
  //median viscosity
  Water(PVector l) {
    super(l);
    c = color(0, 0, 255);
    vis=.5;
  }
}
class Sludge extends drop {
  //Low viscosity
  Sludge(PVector l) {
    super(l);
    c = color(108, 98, 20);
    vis=.001;
  }
}
class Oil extends drop {
  //High Viscosity
  Oil(PVector l) {
    super(l);
    c = color(223, 223, 64);
    vis=1;
  }
}
