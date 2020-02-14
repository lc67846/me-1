FlowField ff;
int ds, ns, cs, xOff=0, command=0;
float nfcX[]={}, nfcY[]={};
ArrayList<cell> cells = new ArrayList<cell>();
ArrayList<Food> nuggets = new ArrayList<Food>();
ArrayList<Water> drips = new ArrayList<Water>();

void setup() {
  fullScreen();
  ff = new FlowField(15);
}
void draw() {
  background(#CB3737);
  backgroundScroll();
  fill(255);
  rect(0, 0, width/5, height/8);
  fill(0);
  text("Press the A key to switch to healthy food, s key for unhealthy food and d key for water, then click to deposit the food. Healthy food boosts the nutrient level of the cells the most, and if a cell is still light blue and healthy, it can even reproduce. Unhealthy food has some nutrients, but not much, if cells are undernurtered, they fade and die. Water kills the red malignant cells on contact, however they will come back. Stop them from destroying the digestor cells!", 0, 0, width/5, height/8);
  if (mousePressed) {
    if (command == 2) drips.add(new Water(0, mouseY));
    if (command == 0) nuggets.add(new healthyFood(0, mouseY));
    if (command == 1) nuggets.add(new unhealthyFood(0, mouseY));
  }
  ds=drips.size();
  for (int i=0; i<ds; i++) {
    if (i>=1&&drips.size()>1&&drips.get(i-1).markedForDestruction) {
      drips.remove(i-1);
      ds--;
      i=0;
    }
    drips.get(i).update();
  }
  ns=nuggets.size();
  for (int i=0; i<ns; i++) {
    if (i>=1&&nuggets.size()>1&&nuggets.get(i-1).markedForDestruction) {
      nuggets.remove(i-1);
      ns--;
      i=0;
    }
    nuggets.get(i).update();
  }
  cs=cells.size();
  for (int i=0; i<cells.size(); i++) {//implement cell death
    if (i>=1&&cells.size()>1&&cells.get(i-1).markedForDestruction) {
      cells.remove(i-1);
      cs--;
      i=0;
    }
    if (cells.get(i).getClass()==cell.class) {//mean cells don't play by the rules
      for (Food n : nuggets) {
        cells.get(i).follow(n.f);
        cells.get(i).colliding(n);//food collision
      }
      cells.get(i).update();
    }

    if (cells.get(i).getClass()==meancell.class) {
      cells.get(i).display();
      for (Water w : drips) {
        cells.get(i).collidingW(w);
      }
    }
    cells.get(i).avoid(cells);//both types still use this, but in different ways
  }
  if (nfcX.length>0&&nfcY.length>0) {
    for (int i=nfcY.length-1; i>0; i--) {
      cells.add(new cell(new PVector(nfcX[i]+randomGaussian(), nfcY[i]+randomGaussian())));//new cell next to old parent
      nfcY=shorten(nfcY);
      nfcX=shorten(nfcX);//remove stored position
    }
  }
  int mca=0;
  for (cell r : cells)if (r.getClass()==meancell.class)mca++;
  if (cells.size()>10&&mca<10)cells.add(new meancell(new PVector(random(0, width), random(0, height))));//spawn malignant cells
  if (frameCount % 2 == 0)if (randomGaussian()>0)cells.add(new cell(new PVector(random(0, width), -10))); 
  else cells.add(new cell(new PVector(random(0, width), height+10)));//spawn digestor cells on edge
}
void keyPressed() {
  if (key=='a'||key=='A') {
    command = 0;
  } else if (key=='s'||key=='S') {
    command = 1;
  } else if (key=='d'||key=='D') {
    command = 2;
  }
}
void backgroundScroll() {
  fill(#F284B9);
  for (int i=0; i<12; i++) {
    beginShape();
    vertex(i*width/6+xOff, 0);
    vertex(width/12+i*width/6+xOff, 0);
    vertex(width/7.5+i*width/6+xOff, height/2);
    vertex(width/12+i*width/6+xOff, height);
    vertex(i*width/6+xOff, height);
    vertex(width/9+i*width/6+xOff, height/2);
    endShape(CLOSE);
  }
  xOff-=10;
  if (xOff<-1*width)xOff=0;
}
class FlowField {
  int resolution, numrows, numcols; 
  PVector[][] flow;
  boolean showFlow;
  FlowField(int r) {
    resolution = r;
    numrows = height/resolution;
    numcols = width/resolution;
    flow = new PVector[numrows][numcols];
  }
  PVector lookup(PVector position) {
    int col = int(constrain(position.x/resolution, 0, numcols-1));
    int row = int(constrain(position.y/resolution, 0, numrows-1));
    return flow[row][col];
  }
}


class Food {
  boolean markedForDestruction=false;
  PVector location;
  FlowField f;
  int diameter, nv;
  float mf=1;
  Food(float _x, float _y) {
    location = new PVector(_x, _y);
    diameter=int(random(30, 70));
    f = new FlowField(diameter);
  }
  void update() {
  }
  void setFlow(float magFactor) {
    for (int row = 0; row < f.numrows; row++) {
      for (int col = 0; col < f.numcols; col++) {
        float rowx = row*diameter;
        float coly = col*diameter;
        f.flow[row][col] = new PVector(coly, rowx).sub(location).setMag(1*magFactor).mult(-1);
      }
    }
  }
}
class unhealthyFood extends Food {//some attraction
  unhealthyFood(float _x, float _y) {
    super(_x, _y);
    diameter=int(random(30, 65));//change later
    mf=.5;
    nv=int(random(0, 5));
  }
  void update() {
    super.setFlow(1);//quick fix to make it have the same attraction as healthy foods
    noStroke();
    fill(255, 0, 0);
    ellipse(location.x, location.y, diameter, diameter);
    location.add((70-diameter)/4, randomGaussian()/3);
    if (location.x>width)location.set(0, location.y);
    if (diameter<nv)markedForDestruction=true;
  }
}
class healthyFood extends Food {//most attraction
  healthyFood(float _x, float _y) {
    super(_x, _y);
    diameter=int(random(30, 65));//change later
    mf=1;
    nv=int(random(0, 10));
  }
  void update() {
    super.setFlow(mf);
    noStroke();
    fill(0, 255, 0);
    ellipse(location.x, location.y, diameter, diameter);
    location.add((70-diameter)/4, randomGaussian()/3);
    if (location.x>width)location.set(0, location.y);
    if (diameter<nv)markedForDestruction=true;
  }
}

class Water {//no attraction, also I had to remove this class's extension of food, it shared no properties other than those that were visual.
  int diameter;
  PVector location;
  boolean markedForDestruction=false;
  Water(float _x, float _y) {
    location=new PVector(_x, _y);
    diameter=int(random(30, 65));
  }
  void update() {
    noStroke();
    fill(0, 0, 255);
    ellipse(location.x, location.y, diameter, diameter);
    location.add((70-diameter)/4, 0);
    if (location.x>width)location.set(0, location.y);
    if (frameCount%20==0)diameter--;
    if (diameter<1)markedForDestruction=true;
  }
}

class cell {
  PVector location, velocity, acceleration;
  float mass, maxSpeed, maxForce, nutrients; 
  boolean markedForDestruction=false, reproducing=false, canParent=true;
  cell(PVector start) {
    location = start.copy();
    velocity = new PVector(0, -1);
    acceleration = new PVector(0, 0);
    mass = 1;
    nutrients=mass*2;
    maxSpeed = 5;
    maxForce = .08;
  }

  void display() {
    float s = mass * 15;
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    stroke(0, 135*nutrients, 135*nutrients);
    strokeWeight(10);
    line(s-3*mass, s-3*mass, s, s);
    strokeWeight(1);
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

  void update() {
    if (!reproducing)move();
    else reproduce();
    display();
    if (location.x>width)location.set(0, location.y);
  }
  void colliding(Food f) {
    if (location.copy().sub(f.location).mag()<f.diameter) {//extracts nutrients from food
      f.diameter-=f.nv*2;
      nutrients+=f.nv;
    }
    if (nutrients>10*mass&&canParent) {//second boolean to implement the one child policy
      reproducing = true;
    }
  }
  void reproduce() {
    nfcX=append(nfcX, location.x);
    nfcY=append(nfcY, location.y);
    nutrients-=10*mass;
    canParent=reproducing = false;
  }
  void avoid(ArrayList<cell> avoid) {
    PVector total = new PVector(0, 0);
    for (cell v : avoid) {
      PVector d = PVector.sub(location, v.location);
      if (d.mag() > 0 && d.mag() < 100) {
        PVector f = d.setMag(3*mass / d.mag());
        f.limit(maxForce);//avoids friend cells
        total.add(f);
      }
    }
    applyForce(total);
  }
  void follow(FlowField f) {
    if (nutrients>0) {
      PVector desiredVelocity = f.lookup(location);
      desiredVelocity.setMag(maxSpeed);
      PVector steer = PVector.sub(desiredVelocity, velocity);
      steer.limit(maxForce);
      applyForce(steer);
      if (frameCount % 10 == 0)nutrients-=mass/100;//like real cells, energy is only expended to a noticable degree when they correct course
    } else {
      markedForDestruction=true;
    }
  }
  void collidingW(Water w) {
  }//placeholder class
} 
class meancell extends cell {//vampire cell, steals nutrients
  cell prey;
  meancell(PVector start) {
    super(start);
    maxSpeed = 3;
    maxForce = 0.06;
  }
  void avoid(ArrayList<cell> avoid) {//override avoid to make it target victims instead
    if (prey==null) {
      for (cell v : avoid) {
        if (v.getClass()==cell.class&&v.location.copy().sub(location.copy()).mag()<new PVector(100, 100).mag())prey=v;//find closest
      }
    } else {
      if (prey.markedForDestruction==true) {
        prey=null;
        return;
      }
      PVector desiredVelocity = PVector.sub(prey.location, location);
      desiredVelocity.limit(maxSpeed);
      PVector steer = PVector.sub(desiredVelocity, velocity);
      steer.limit(maxForce);
      acceleration.add(steer.copy().div(mass));
      velocity.add(acceleration);
      location.add(velocity);
      acceleration.mult(0);
      if (caught(prey)) {
        nutrients+=prey.nutrients;//kills it and steals nutrients
        prey.markedForDestruction=true;
        prey=null;
      }
    }
  }
  boolean caught(cell t) {
    float d = PVector.sub(t.location, location).mag();
    if (d < 5) return true;
    return false;
  }
  void collidingW(Water f) {
    if (location.copy().sub(f.location).mag()<f.diameter) {
      markedForDestruction=true;
    }
  }
  void display() {
    float s = mass * 15;
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    stroke(255*nutrients, 0, 0);
    strokeWeight(10);
    line(s-3*mass, s-3*mass, s, s);
    strokeWeight(1);
    popMatrix();
  }
}
