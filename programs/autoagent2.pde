Vehicle joe;
Target target;

void setup() {
  fullScreen();
  joe = new Vehicle(new PVector(width/2, height/2));
  target = new Target();
}


void draw() {
  background(245);

  //target.display();

  joe.wander();
  joe.update();
}


class Target {
  PVector location;

  Target() {
  }

  void display() {
    fill(0);
    text("x", location.x, location.y);
  }
}

class Vehicle {
  PVector location, velocity, acceleration;
  float w, h, mass, maxSpeed, maxForce, siren; 
  PVector p;
  PVector oldTarget, newTarget;

  Vehicle(PVector start) {
    location = start.copy();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = 1;
    maxSpeed = 3;
    maxForce = 0.06; 
    w = 50;
    h = 25;
    p = PVector.random2D();
  }

  void display() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    rectMode(CENTER);
    //carrot on stick
    noFill();
    stroke(0, 0, 255);
    line(0, 0, 200, 0);
    stroke(255, 0, 0);
    line(0,0,newTarget.copy().limit(30).x,newTarget.copy().limit(30).y);
    stroke(0, 255, 0);
    line(newTarget.copy().limit(30).x,newTarget.copy().limit(30).y,200,0);
    stroke(0);
    ellipseMode(CENTER);
    ellipse(200, 0, 60, 60);
    ellipseMode(CORNER);
    // tires
    fill(0);
    rect(-0.3*w, 0.5*h, w*0.3, h*0.2);
    rect( 0.3*w, 0.5*h, w*0.3, h*0.2);
    rect(-0.3*w, -0.5*h, w*0.3, h*0.2);
    rect( 0.3*w, -0.5*h, w*0.3, h*0.2);
    // car body
    fill(150);
    noStroke();
    rect(0, 0, w, h);
    stroke(0);
    // headlights
    rect(w/2, -0.2*h, w*0.03, h*0.2);
    rect(w/2, 0.2*h, w*0.03, h*0.2);
    // lights for headlights
    fill(255, 255, 0, 100);
    noStroke();
    triangle(w/2, -0.2*h, w/2+w, -0.7*h, w/2+w, 0.3*h);
    triangle(w/2, 0.2*h, w/2+w, -0.3*h, w/2+w, 0.7*h);
    // flashy light siren thingy
    fill(255, 0, 0, map(siren, -1, 1, 0, 255));
    ellipse(0, 0, w*0.07, w*0.07);
    popMatrix();
  }

  void move() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    if (location.x > width) location.x = 0;
    if (location.x < 0) location.x = width;
    if (location.y > height) location.y = 0;
    if (location.y < 0) location.y = height;
  }

  void applyForce(PVector f) {
    PVector a = f.copy().div(mass);
    acceleration.add(a);
  }

  void seek(PVector target) {
    PVector desiredVelocity = PVector.sub(target, location);
    desiredVelocity.limit(maxSpeed);
    PVector steer = PVector.sub(desiredVelocity, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }

  void wander() {
    float z, r;

    z= 500;
    r = 10;
    oldTarget = PVector.add(location, velocity.copy().setMag(z));  
    p.rotate(0.1*randomGaussian()).setMag(r);
    newTarget = PVector.add(oldTarget, p);
    seek(newTarget);
  }

  void update() {
    move();
    display();
    siren = sin(frameCount * velocity.mag() / 10.0);
  }
}
