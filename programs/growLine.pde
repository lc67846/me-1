Vehicle joe;

void setup() {
  size(800,600);
  joe = new Vehicle(new PVector(width/2, height/2));
}


void draw() {
  if(frameCount%323==0)background(245);


  joe.seek(new PVector(mouseX,mouseY));
  joe.display();
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

  //boolean reached(Target t ) {
  //  float d = PVector.sub(t.location, location).mag();
  //  if (d < 5) return true;
  //  return false;
  //}


  void display() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    rectMode(CENTER);
    // car body
    fill(150);
    noStroke();
    rect(0, 0, w, h);
    stroke(0);
    popMatrix();
  }

  void seek(PVector target) {
    PVector desiredVelocity = PVector.sub(target, location);
    desiredVelocity.limit(maxSpeed);
    PVector steer = PVector.sub(desiredVelocity, velocity);
    steer.limit(maxForce);
    acceleration.add(steer.copy().div(mass));
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
}
