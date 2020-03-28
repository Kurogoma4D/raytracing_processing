final float NO_HIT = Float.POSITIVE_INFINITY;

Vec eye = new Vec(0, 0, 7);
Vec sphereCenter = new Vec(0, 0, 0);
float sphereRadius = 1;

Vec lightPos = new Vec(-10, 10, 10);
//float lightPower = 2000;
Spectrum lightPower = new Spectrum(4000, 4000, 4000);

Vec secondLight = new Vec(0, 10, 20);
Spectrum secondLightPower = new Spectrum(3500, 3500, 3500);

Spectrum diffuseColor = new Spectrum(1, 0.5, 0.25);

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

  Material mtlSphere = new Material(new Spectrum(0.1, 0.5, 0.9));
  //mtlSphere.reflective = 0.6;
  mtlSphere.refractive = 0.9;
  mtlSphere.refractiveIndex = 1.5;

  scene.addIntersectable(new Sphere(new Vec(0, 0, 0), 1, mtlSphere));

  Material mtlFloor1 = new Material(new Spectrum(0.5, 0.5, 0.5));
  Material mtlFloor2 = new Material(new Spectrum(0.2, 0.2, 0.2));

  scene.addIntersectable(
    new CheckedObj(new Plane(
    new Vec(0, -1, 0), 
    new Vec(0, 1, 0), 
    mtlFloor1
    ), 
    1, mtlFloor2
    )
    );
  
  Material mtlWall = new Material(new Spectrum(0.5, 0.5, 0.5));
  
  scene.addIntersectable(
    new TexturedObj(
      new Plane(new Vec(0, 0, -5), new Vec(0, 0, 1), mtlWall),
      background,
      10,
      new Vec(-5, -5, 0),
      new Vec(1, 0, 0),
      new Vec(0, 1, 0)
    )
  );

  scene.addLight(new Light(
    new Vec(100, 100, 100), 
    new Spectrum(800000, 800000, 800000)
    ));
}

Ray calcPrimaryRay (int x, int y) {
  float imagePlane = height;

  float dx = x + 0.5 - width / 2;
  float dy = -(y + 0.5 - height / 2);
  float dz = -imagePlane;

  return new Ray(eye, new Vec(dx, dy, dz).normalize());
}

color calcPixelColor (int x, int y) {
  Ray ray = calcPrimaryRay(x, y);
  Spectrum sp = scene.trace(ray, 0);
  return sp.toColor();
}
