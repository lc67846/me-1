float r, time;
color white = color(245, 245, 245);
color blue = color(10, 10, 255);
color orange = color(255, 165, 0);
color brown = color(70, 56, 30);
color black = color(0, 0, 0);
void setup() {
  fullScreen();
}

void draw() {
  drawSky();
  drawClouds();
  drawMountain(100, 200, 0);
  drawMountain(150, 150, 1);
  drawMountain(200, 100, 2);
  drawMountain(255, 50, 3);
  fill(255);
  rect(0,0,200,50);
  fill(0);
  text("click to regenerate.",20,20);
}
void drawClouds() {
  time+=.1;
  loadPixels();
  for (float x = 0; x<width; x++) {
    for (float y = 0; y<height; y++) {
      float n = noise(time+ x/100.0, y/100.0);
      color b = lerpColor(blue, orange, map(y, 0, height, 0, 1));
      color c = lerpColor(lerpColor(white, b, map(y, 0, height/4, 0, 1)), b, n);
      pixels[int(y*width+x)]=color(c);
    }
  }
  updatePixels();
}
void drawSky() {
  for (int y = 0; y<=height; y++) {
    color c = lerpColor(blue, orange, map(y, 0, height, 0, 1));
    stroke(c);
    line(0, y, width, y);
  }
}
void mousePressed() {
  r = random(0, 1000);
}
void drawMountain(int shade, int disp, int seq) {
  for (int x = 0; x<=width; x++) {
    float n = noise((r+(x+width*seq)/500.0));
    float ystart = map(n, 0, 1, 0, height);
    stroke(brown, shade);
    if (ystart>=(height/2))drawGrass(int(x), int((ystart+disp)), brown, shade);//so that grass grows only where rain would collect
    line(x, ystart+disp, x, height);
  }
}
void drawGrass(int x, int y, color br, int shade) {
  stroke(10, 245, 10, shade);
  for (int i=0; i<int(random(0, 30)); i++) {
    line((x-abs(randomGaussian()*2)), (y-abs(randomGaussian()*2)), (x+abs(randomGaussian()*2)), (y+abs(randomGaussian()*2)));
  }
  stroke(br, shade);
}
