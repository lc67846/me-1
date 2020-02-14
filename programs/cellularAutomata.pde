CA cell;
int tick = 0,rate=20000;
void setup() {
  cell = new CA();
  fullScreen();
  background(245);
  frameRate(rate);
}
void draw() {
  if (cell.generation==height||mousePressed) {
    background(245);
    tick++;
    cell.ruleset = new int[]{Math.round(random(0, 1)),Math.round(random(0, 1)),Math.round(random(0, 1)),Math.round(random(0, 1)),Math.round(random(0, 1)),Math.round(random(0, 1)),Math.round(random(0, 1)),Math.round(random(0, 1)),};
    cell.generation=0;
  }
  cell.display();
  cell.nextGeneration();
  fill(255);
  rect(0,0,width/6,width/6);
  fill(255,0,0);
  text(tick,width/12-width/24,width/12);
  text(""+cell.ruleset[0]+cell.ruleset[1]+cell.ruleset[2]+cell.ruleset[3]+cell.ruleset[4]+cell.ruleset[5]+cell.ruleset[6]+cell.ruleset[7],(width)/12,width/12);
}
class CA {
  int[] cells;
  int[] ruleset = {Math.round(random(0, 1)),Math.round(random(0, 1)),Math.round(random(0, 1)),Math.round(random(0, 1)),Math.round(random(0, 1)),Math.round(random(0, 1)),Math.round(random(0, 1)),Math.round(random(0, 1)),};
  int generation;
  CA() {
    cells = new int[width];
    for (int i = 0; i<width; i++)cells[i]=0;
    cells[width/2]=1;
    generation=0;
  }
  void nextGeneration() {
    generation++;
    for (int i = 1; i<width-1; i++) {
      int left = cells[i-1];
      int middle = cells[i];
      int right = cells[i+1];
      cells[i] = rules(left, middle, right);
    }
  }
  void display() {
    for (int i=0; i<width; i++) {
      if (cells[i]==1)stroke(0);
      else stroke(255);
      point(i, generation);
    }
  }
  int rules(int l, int m, int r) {
    String binaryNum = ""+l+m+r;
    int index = Integer.parseInt(binaryNum, 2);
    return ruleset[index];
  }
}
