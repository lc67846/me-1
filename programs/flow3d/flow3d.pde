FlowField ff;//make lists of flow fields and vehicles
ArrayList<Vehicle> vehicles = new ArrayList<Vehicle>();

int sx,sy,sz;
void setup() {
  sx=int(random(100,400));//create random playfield
  sy=int(random(100,400));
  sz=int(random(100,400));
  size(800,600,P3D);
  ff = new FlowField(15);
  for (int i=0; i<((sx+sy+sz)/30); i++) {
    vehicles.add(new Vehicle(new PVector(int(random(0,sx)), int(random(0,sy)), int(random(0, sz)))));//make vehicles based on size
  }
}

void draw() {
  background(245);
  camera(100+mouseX, -400.0+mouseY, 420.0, 0,0,0, 0.0, 1.0, 0.0);

  if (frameCount % 10 == 0) ff.setFlow();//setflow every now and then
  ff.display();//display flowfield if possible

  for (Vehicle v : vehicles) {
    v.follow(ff);//update all vehicle positions and representations
    v.update();
  }
}

void keyPressed() {
  ff.showFlow =!ff.showFlow;//toggle flowfield
}

class FlowField {
  int resolution, numrows, numcols, numdepth; 
  PVector[][][] flow;//make 3d flow array
  boolean showFlow;

  FlowField(int r) {
    resolution = r;

    numrows = sy/resolution;
    numcols = sx/resolution;//set cols and rows to w,h,d values
    numdepth = sz/resolution;
    flow = new PVector[numrows][numcols][numdepth];//predefine flowfield size(it won't change)
    setFlow();
    showFlow = true;//field starts as visible, can be toggled
  }

  void setFlow() {
    for (int dep = 0; dep < numdepth; dep++) {
      for (int row = 0; row < numrows; row++) {//loop through the flow field's x, y, and z
        for (int col = 0; col < numcols; col++) {
          float phi = map(noise(row/10. + frameCount/150., col/10. + frameCount/160.), 0, 1, 0, PI);//generate 2 noise sources
          float theta = map(noise(row/10. + frameCount/150., col/10. + frameCount/160.), 0, 1, 0, 2*PI);
          flow[row][col][dep] = new PVector(cos(phi), cos(theta)*sin(phi), sin(theta)*sin(phi));//generate 3d angle from noise
        }
      }
    }
  }


  void display() {
    noFill();
    pushMatrix();
    translate((numrows/2)*resolution, (numcols/2)*resolution, (numdepth/2)*resolution);//create bounding box to serve as a vantage point much like a 2d canvas
    //box(numcols*resolution,numrows*resolution,numdepth*resolution);
    popMatrix();
    if (!showFlow)return;//skips if user disables arrows
    stroke(200);
    for (int dep = 0; dep < numdepth; dep++) {
      for (int row = 0; row < numrows; row++) {//loops thru flowfield and shows its properties with arrows
        for (int col = 0; col < numcols; col++) {
          PVector p = flow[row][col][dep];
          pushMatrix();
          translate(col*resolution, row*resolution, dep*resolution);
          rotateX(p.x);
          rotateY(p.y);//move and rotate to the values set in the flow array
          rotateZ(p.z);
          line(-0.3*resolution, 0, 0.3*resolution, 0);
          line(0.3*resolution, 0, 0.1*resolution, 0.2*resolution);//makes a little arrow
          line(0.3*resolution, 0, 0.1*resolution, -0.2*resolution);
          popMatrix();
        }
      }
    }
  }


  PVector lookup(PVector position) {
    int col = int(constrain(position.x/resolution, 0, numcols-1));
    int row = int(constrain(position.y/resolution, 0, numrows-1));
    int dep = int(constrain(position.z/resolution, 0, numdepth-1));//allows vehicle class to lookup cel in flow array and set its rotation to that cel's value
    return flow[row][col][dep];
  }
}





class Vehicle {
  PVector location, velocity, acceleration;
  float mass, maxSpeed, maxForce; 

  Vehicle(PVector start) {
    location = start.copy();//start where position is designated
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = 1;
    maxSpeed = 5;
    maxForce = .08;
  }

  void display() {
    float s = mass * 15;
    pushMatrix();
    translate(location.x, location.y, location.z);
    rotateX(velocity.x);
    rotateY(velocity.y);
    rotateZ(velocity.z);    //move and render a triangle to follow flow fields
    fill(0);
    stroke(0);
    triangle(s/2, 0, -s/2, s*0.2, -s/2, -s*0.2);
    popMatrix();
  }

  void move() {
    velocity.add(acceleration);
    location.add(velocity);//apply forces
    acceleration.mult(0);
    if (location.x > sx) location.x = 0;
    if (location.x < 0) location.x = sx;//stay within bounding box
    if (location.y > sy) location.y = 0;
    if (location.y < 0) location.y = sy;
    if (location.z > sz) location.z = 0;
    if (location.z < 0) location.z = sz;
  }

  void applyForce(PVector f) {
    PVector a = f.copy().div(mass);
    acceleration.add(a);//apply acceleration based on mass
  }


  void update() {
    move();
    display();
  }

  void follow(FlowField f) {
    PVector desiredVelocity = f.lookup(location);
    desiredVelocity.setMag(maxSpeed);
    PVector steer = PVector.sub(desiredVelocity, velocity);//follow flow field by looking up direction at location and conforming to that given direction
    steer.limit(maxForce);
    applyForce(steer);
  }
}
