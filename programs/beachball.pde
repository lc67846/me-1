ArrayList<beachBall> beachballs = new ArrayList<beachBall>();
ocean pl;
void setup() {
  fullScreen(P3D);
  pl = new ocean(width/2, height/2, -100, 500, 200, 500);
  noStroke();
}
void draw() {
  background(255);
  camera(100, -400.0+mouseY, 420.0, pl.x, pl.y, pl.z, 0.0, 1.0, 0.0);
  arrows(new PVector(pl.x, pl.y, pl.z));
  lights();
  fill(0);
  pl.update();
  if (mousePressed&&beachballs.size()<15&&frameCount%30==0) {
    beachballs.add(new beachBall(new PVector(pl.x+mouseX-250, pl.y-pl.h, pl.z+mouseY-250)));
  }
  //begin cursor
  pushMatrix();
  if ((pl.x+mouseX)>pl.x&&(pl.x+mouseX)<pl.x+500&&(pl.z+mouseY)>pl.z&&(pl.z+mouseY)<pl.z+500)fill(0, 255, 0);
  else fill(255, 0, 0);
  translate(pl.x+mouseX-250, pl.y-pl.h, pl.z+mouseY-250);
  box(40);
  noFill();
  stroke(0);
  box(40, pl.y, 40);
  noStroke();
  popMatrix();
  stroke(0, 0, 255);
  line(pl.x+mouseX-250, pl.y-pl.h, pl.z+mouseY-250, pl.x, pl.y-pl.h, pl.z);
  stroke(0, 255, 0);
  line(pl.x+mouseX-250, pl.y-pl.h, pl.z+mouseY-250, pl.x, pl.y, pl.z);
  noStroke();
  //end cursor
  PVector gravity = new PVector(0, 0.1, 0);
  for (beachBall b : beachballs) {
    if (beachballs.size()>1)b.scan();
    if (b.watercollision(pl)) {
      PVector drag=b.velocity.copy().normalize().rotate(radians(180));
      drag.mult(0.00005*pl.l*(b.density*b.density)*b.velocity.mag()*b.velocity.mag());
      b.applyForce(drag);
    } else {
      gravity.copy().mult(b.mass);
      b.applyForce(gravity);
    }
    b.update();
  }
}
class beachBall {
  PVector location, velocity, acceleration;
  float mass, density, radius;
  color cl;
  beachBall(PVector start) {
    cl=color(random(0, 255), random(0, 255), random(0, 255));
    location=start.copy();
    velocity=new PVector(0, 0, 0);
    acceleration=new PVector(0, 0, 0);
    density=random(10, 15);
    mass=density/2;
    radius=20;
  }
  void update() {
    pushMatrix();
    velocity.add(acceleration);

    location.add(velocity);
    acceleration.mult(0);
    fill(0, 255, 0);
    translate(location.x, location.y, location.z);
    sphere(2*radius);
    popMatrix();
  }
  boolean watercollision(ocean p) {
    float x = location.x;
    float y = location.y;
    float z = location.z;
    if (x>p.x-p.l && x<p.x+p.l&&y>p.y-p.w && y<p.y+p.w&& z>p.z-p.h &&z<p.z+p.h)return true;
    return false;
  }
  void scan() {
    for (beachBall other : beachballs) {//TOFIX
      PVector distVect = PVector.sub(other.location, location);
      if (distVect.mag() < 2*radius) {
        PVector offset = distVect.copy().normalize().mult((2*radius-distVect.mag())/2.0);//distance to add between balls, note the add and sub below
        other.location.add(offset);
        location.sub(offset);
        float sin = sin(distVect.heading());
        float cos = cos(distVect.heading());//collision limit 2d because heading is a 2d only command per the processing wiki page on it :(
        PVector ov=other.velocity;
        PVector PosTempOther=new PVector(cos * distVect.x + sin * distVect.y, cos * distVect.y - sin * distVect.x);//active ball temp position
        PVector VelTempThis = new PVector(cos * velocity.x + sin * velocity.y, cos * velocity.y - sin * velocity.x); 
        PVector VelTempOther = new PVector(cos * ov.x + sin * ov.y, cos * ov.y - sin * ov.x);
        PVector VecFinThis = new PVector(((mass - other.mass) * VelTempThis.x + 2 * other.mass * VelTempOther.x) / (mass + other.mass), VelTempThis.y);//a few equations from my physics textbook last year ;)
        PVector VecFinOther = new PVector(((other.mass - mass) * VelTempOther.x + 2 * mass * VelTempThis.x) / (mass + other.mass), VelTempOther.y);
        PVector posFinOther=new PVector(cos * PosTempOther.x+VecFinOther.x - sin * PosTempOther.y, cos * PosTempOther.y + sin * PosTempOther.x+VecFinOther.x);
        other.location.add(posFinOther.x, posFinOther.y);//push changes to other location
        location.add(cos * -1 * sin, cos * sin * VecFinThis.x);//push changes to our location
        velocity.set(cos * VecFinThis.x - sin * VecFinThis.y, cos * VecFinThis.y + sin * VecFinThis.x);//push changes to our velocity
        ov.set(cos * VecFinOther.x - sin * VecFinOther.y, cos * VecFinOther.y + sin * VecFinOther.x);//push changes to other velocity
      }
    }
  }
  void applyForce(PVector force) {
    PVector a = force.copy().div(mass);
    acceleration.add(a);
  }
}
class ocean {
  float x, y, z, l, w, h;
  ocean(float _x, float _y, float _z, float _l, float _w, float _h) {
    x=_x;
    y=_y;
    z=_z;
    l=_l;
    w=_w;
    h=_h;
  }
  void update() {
    pushMatrix();
    noFill();
    stroke(0);
    translate(x, y-100, z);
    box(l, w, h);
    noStroke();
    popMatrix();
  }
}
void arrows(PVector origin) {
  background(255);
  pushMatrix();
  translate(origin.x, origin.y);
  stroke(255, 0, 0);
  line(-origin.x, 0, origin.x, 0);
  stroke(0, 255, 0);
  line(0, origin.y, 0, -origin.y);
  stroke(0, 0, 255);
  line(0, 0, origin.z, 0, 0, -origin.z);
  popMatrix();
  noStroke();
}
