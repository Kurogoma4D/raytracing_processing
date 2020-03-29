final float NO_HIT = Float.POSITIVE_INFINITY;
final int SAMPLES = 100;

Scene scene = new Scene();
Camera camera = new Camera();
int y = 0;

void setup () {
  size(800, 800);
  frameRate(60);
  initScene();
  initCamera();
}

void draw () {
  for (int x = 0; x < width; x ++) {
    color c = calcPixelColor(x, y);
    set(x, y, c);
  }
  y++;
  if (y >= height) noLoop();
}

void initScene() {
  scene.setSkyColor(new Spectrum(0.8, 0.86, 0.95));

  Material mtl1 = new Material(new Spectrum(0.7, 0.3, 0.9));
  scene.addIntersectable(
    new Sphere(new Vec(-2.2, 0, 0), 
    1, mtl1)
    );

  Material mtl2 = new Material(new Spectrum(0.9, 0.7, 0.3));
  mtl2.reflective = 0.8;
  scene.addIntersectable(
    new Sphere(new Vec(0, 0, 0), 
    1, mtl2)
    );

  Material mtl3 = new Material(new Spectrum(0.3, 0.3, 0.7));
  mtl3.refractive = 0.8;
  mtl3.refractiveIndex = 1.5;
  scene.addIntersectable(
    new Sphere(new Vec(2.2, 0, 0), 
    1, mtl3)
    );
  
  Material mtlLight = new Material(new Spectrum(0.0, 0.0, 0.0));
  mtlLight.emissive = new Spectrum(30.0, 20.0, 10.0);
  scene.addIntersectable(
    new Sphere(new Vec(0, 4, 0),
    1, mtlLight)
    );

  Material mtlFloor1 = new Material(new Spectrum(0.9, 0.9, 0.9));
  Material mtlFloor2 = new Material(new Spectrum(0.4, 0.4, 0.4));
  scene.addIntersectable(
    new CheckedObj(
    new Plane(new Vec(0, -1, 0), new Vec(0, 1, 0), mtlFloor1), 
    1, 
    mtlFloor2
    ));
}

void initCamera() {
  camera.lookAt(
    new Vec(0, 0, 7.0), 
    new Vec(0.0, 0.0, 0.0), 
    new Vec(0.0, 1.0, 0.0), 
    radians(60.0), 
    width, 
    height);
}

Ray calcPrimaryRay (int x, int y) {  
  return camera.ray(x + random(-0.5, 0.5), y + random(-0.5, 0.5));
}

color calcPixelColor (int x, int y) {
  Spectrum sum = BLACK;

  for (int i = 0; i < SAMPLES; i++) {
    Ray ray = calcPrimaryRay(x, y);
    sum = sum.add(scene.trace(ray, 0));
  }

  return sum.scale(1.0 / SAMPLES).toColor();
}
