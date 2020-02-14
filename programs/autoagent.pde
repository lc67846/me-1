Vehicle joe;
Target target;

void setup() {
  fullScreen();
  joe = new Vehicle(new PVector(width/2, height/2));
  target = new Target();
}


void draw() {
  background(245);

  target.update();

  joe.seek(target.location);
  joe.update();
  if (joe.reached(target)) target.randomize();
}


class Target {
  PVector location, velocity, acceleration;
  float mass;

  Target() {
    randomize();
  }

  void randomize() {
    location = new PVector( random(0.1*width, 0.9*width), random(0.1*height, 0.9*height) );
    velocity = PVector.random2D();
    acceleration = new PVector(0, 0);
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

  void display() {
    fill(0);
    text("x", location.x, location.y);
  }

  void update() {
    move();
    display();
  }
}

class Vehicle {
  PVector location, velocity, acceleration;
  float w, h, mass, maxSpeed, maxForce, siren; 

  Vehicle(PVector start) {
    location = start.copy();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = 1;
    maxSpeed = 3;
    maxForce = 0.06; 
    w = 50;
    h = 25;
  }

  boolean reached(Target t ) {
    float d = PVector.sub(t.location, location).mag();
    if (d < 5) return true;
    return false;
  }


  void display() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    rectMode(CENTER);
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

  void update() {
    move();
    display();
    siren = sin(frameCount * velocity.mag() / 10.0);
  }
}
