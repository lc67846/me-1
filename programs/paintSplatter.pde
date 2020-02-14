ArrayList<splat> splats = new ArrayList<splat>();
void setup() {
  fullScreen();
  background(245);
  fill(0);
  text("click to make a paintsplat!",50,50);
}
void draw() {
  if (mousePressed) {
    splats.add(new splat(mouseX, mouseY));
    splats.get(splats.size()-1).populate();
  }
  for (splat i : splats)i.render();
}
class splat {
  ArrayList<dribble> dribbles = new ArrayList<dribble>();
  ArrayList<dot> dots = new ArrayList<dot>();
  ArrayList<ray> rays = new ArrayList<ray>();
  int x, y;
  splat(int _x, int _y) {
    x=_x;
    y=_y;
  }
  void populate() {
    int r=int(random(0, 255)), g=int(random(0, 255)), b=int(random(0, 255));
    for (int i=0; i<int(random(90, 150)); i++) {
      rays.add(new ray(mouseX, mouseY, mouseX+numseg(randomGaussian(), 10000), mouseY+numseg(randomGaussian(), 10000), r, g, b, int(random(0, 10))));
      for (int v =0; v<5; v++)dots.add(new dot(mouseX, mouseY, r, g, b, int(random(0, 10))));//produce more dots than any other type
      dribbles.add(new dribble(mouseX+numseg(randomGaussian(), 10000), mouseY+numseg(randomGaussian(), 10000), r, g, b, int(random(0, 10))));
    }
  }
  void render() {
    for (ray i : rays)i.render();
    for (dot i : dots)i.render();
    for (dribble i : dribbles)i.render();
  }
  int numseg(float in, int f) {
    return int((in*1000000)/f);//make it large and truncate for more randomness
  }
  class ray {//so rays render above dribbles
    int x1, y1, x2, y2, r, g, b, w;
    ray(int _x1, int _y1, int _x2, int _y2, int _r, int _g, int _b, int _w) {
      x1=_x1;
      y1=_y1;
      x2=_x2;
      y2=_y2;
      r=_r;
      g=_g;
      b=_b;
      w=_w;
    }
    void render() {
      strokeWeight(w);
      stroke(r, g, b);
      line(x1, y1, x2, y2);
    }
  }
  class dot {
    float x, y, s, a, rad;
    int r, g, b, w;
    dot(int _x, int _y, int _r, int _g, int _b, int _w) {
      x=_x;
      y=_y;
      s=int(abs(randomGaussian()));
      r=_r-50;
      g=_g-50;
      b=_b-50;
      w=_w;
      a=random(0, 360);
      rad=60*randomGaussian();
    }
    void render() {
      strokeWeight(w);
      stroke(r, g, b, 100*abs(int(x+y)));
      fill(r, g, b);//preserve color
      ellipse(x+ rad*cos(radians(a)), y+ rad*sin(radians(a)), s, s);//just like a dribble, but stationary, and tighter in scope
    }
  }
  class dribble {
    float x, y, s;
    int r, g, b, w;
    dribble(int _x, int _y, int _r, int _g, int _b, int _w) {
      x=_x;
      y=_y;
      s=int(abs(randomGaussian()));
      r=_r;
      g=_g;
      b=_b;
      w=_w;
    }
    void render() {
      strokeWeight(w);
      fill(r, g, b, 100*abs(int(x+y)));//preserve color
      ellipse(x, y, s, s);
      y++;
      if (s<=0)s=0;
      else s=s-.01;
      x=x+(randomGaussian()/2);//add wobbling of droplet, like in real life
    }
  }
}
