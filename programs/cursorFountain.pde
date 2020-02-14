ArrayList<Ball> balls = new ArrayList<Ball>();
Liquid water;
void setup() {
  fullScreen();
  water = new Liquid(0, 0.7*height, width, height, 0.1, color(0, 0, 255, 150));
}
void draw() {
  background(245);
  if (frameCount % 3 == 0) {
    PVector start = new PVector(mouseX, mouseY);
    PVector vel = new PVector(randomGaussian(), -(2+abs(2*randomGaussian())));
    balls.add(new Ball(start, vel));
  }
  PVector gravity = new PVector(0, 0.2);
  for (Ball b : balls) {
    gravity.copy().mult(b.mass);
    b.applyForce(gravity);
    PVector drag=b.velocity.copy().normalize().rotate(radians(180));
    drag.mult(0.05*water.l*(b.d*b.d)*b.velocity.mag()*b.velocity.mag());
    if(b.inside(water))b.applyForce(drag);
    b.update();
  }
  water.display();
}
class Ball {
  PVector location, velocity, acceleration;
  float mass, d;
  color c;
  Ball(PVector start, PVector _velocity) {
    c=color(random(0, 255), random(0, 255), random(0, 255));
    location=start.copy();
    velocity=_velocity.copy();
    acceleration=new PVector(0, 0);
    d=random(5, 15);
    mass=d/2;
  }
  void move() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  void checkedges() {
    if (location.x<0)location.x=width;
    if (location.y>height) {
      location.y=height;
      velocity.y=-0.5*velocity.y;
    }
  }
  void display() {
    ellipse(location.x, location.y, d, d);
  }
  boolean inside(Liquid l){
    float x = location.x;
    float y = location.y;
    if(x>l.x && x<l.w+l.w && y>l.y && y<l.y+l.h)return true;
    return false;
  }
  void update() {
    move();
    display();
    checkedges();
  }
  void applyForce(PVector force) {
    PVector a = force.copy().div(mass);
    acceleration.add(a);
  }
}
class Liquid {
  float x, y, w, h, l;
  color c;
  Liquid(float _x, float _y, float _w, float _h, float _l, color _c) {
    x=_x;
    y=_y;
    w=_w;
    h=_h;
    l=_l;
    c=_c;
  }
  void display() {
    fill(c);
    rectMode(CORNER);
    noStroke();
    rect(x,y,w,h);
  }
}
