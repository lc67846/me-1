void setup() {
  size(500,500);
}

void draw() {
  noiseDetail(8);

  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float n = map(noise(x/100.0, y/100.0), 0, 1, 0, 255);
      float waterlevel = 120;
      color c = color(0);
      color darkblue = color(20, 20, 150);
      color lightblue = color(100, 100, 255);
      float waterfrac = pow(1 - (waterlevel - n) / waterlevel, 7);
      if (n < waterlevel) c = lerpColor(darkblue, lightblue, waterfrac);

      color grass = color(20, 200, 20);
      color mountains = color(100, 60, 30);
      float landfrac = pow((n - waterlevel) / (255-waterlevel), .21);
      if (n >= waterlevel) c = lerpColor(grass, mountains, landfrac);

      pixels[x + y*width] =  c;
    }
  }

  updatePixels();
} 
