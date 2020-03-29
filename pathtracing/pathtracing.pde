final float NO_HIT = Float.POSITIVE_INFINITY;
final int SAMPLES = 100;

Vec eye = new Vec(0, 0, 7);

PImage background;

Scene scene = new Scene();

void setup () {
  size(800, 800);
  frameRate(60);
  background = loadImage("displacement.png");
  initScene();
  noLoop();
}

void draw () {
  for (int y = 0; y < height; y ++) {
    for (int x = 0; x < width; x ++) {
      color c = calcPixelColor(x, y);
      set(x, y, c);
    }
  }
}

void initScene() {

  scene.addIntersectable(
    new Sphere(new Vec(-2.2, 0, 0), 
    1, 
    new Material(new Spectrum(0.7, 0.3, 0.9)))
    );

  scene.addIntersectable(
    new Sphere(new Vec(0, 0, 0), 
    1, 
    new Material(new Spectrum(0.9, 0.7, 0.3)))
    );

  scene.addIntersectable(
    new Sphere(new Vec(2.2, 0, 0), 
    1, 
    new Material(new Spectrum(0.3, 0.3, 0.7)))
    );

  Material mtlFloor = new Material(new Spectrum(0.9, 0.9, 0.9));

  scene.addIntersectable(
    new Plane(
    new Vec(0, -1, 0), 
    new Vec(0, 1, 0), 
    mtlFloor)
    );
}

Ray calcPrimaryRay (int x, int y) {
  float imagePlane = height;

  float dx = x + 0.5 - width / 2;
  float dy = -(y + 0.5 - height / 2);
  float dz = -imagePlane;

  return new Ray(eye, new Vec(dx, dy, dz).normalize());
}

color calcPixelColor (int x, int y) {
  Spectrum sum = BLACK;

  for (int i = 0; i < SAMPLES; i++) {
    Ray ray = calcPrimaryRay(x, y);
    sum = sum.add(scene.trace(ray, 0));
  }

  return sum.scale(1.0 / SAMPLES).toColor();
}
