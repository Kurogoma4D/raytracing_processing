final float NO_HIT = Float.POSITIVE_INFINITY;

Vec eye = new Vec(0, 0, 5);
Vec sphereCenter = new Vec(0, 0, 0);
float sphereRadius = 1;

Vec lightPos = new Vec(-10, 10, 10);
//float lightPower = 2000;
Spectrum lightPower = new Spectrum(4000, 4000, 4000);

Vec secondLight = new Vec(0, 10, 20);
Spectrum secondLightPower = new Spectrum(3500, 3500, 3500);

Spectrum diffuseColor = new Spectrum(1, 0.5, 0.25);

void setup () {
  size(800, 800);
  frameRate(60);
}

void draw () {
  for (int y = 0; y < height; y ++) {
    for (int x = 0; x < width; x ++) {
      color c = calcPixelColor(x, y);
      set(x, y, c);
    }
  }

  lightPos.x = (float(mouseX) / width - 0.5) * 20;
  lightPos.y = -(float(mouseY) / height - 0.5) * 20;
}

float intersectRaySphere (Vec rayOrigin, Vec rayDir, Vec sphereCenter, float sphereRadius) {
  Vec v = rayOrigin.sub(sphereCenter);
  float b = rayDir.dot(v);
  float c = v.dot(v) - sq(sphereRadius);
  float d = b * b - c;

  if ( d >= 0 ) {
    float s = sqrt(d);
    float t = -b - s;
    if (t <= 0) t = -b + s;
    if (0 < t) {
      return t;
    }
  }

  return NO_HIT;
}

Vec calcPrimaryRay (int x, int y) {
  float imagePlane = height;

  float dx = x + 0.5 - width / 2;
  float dy = -(y + 0.5 - height / 2);
  float dz = -imagePlane;

  return new Vec(dx, dy, dz).normalize();
}

color calcPixelColor (int x, int y) {
  Vec rayDir = calcPrimaryRay(x, y);

  float t = intersectRaySphere(eye, rayDir, sphereCenter, sphereRadius);
  if (t == NO_HIT) return color(0, 0, 0);

  Vec p = eye.add(rayDir.scale(t));
  Vec n = p.sub(sphereCenter).normalize();

  Spectrum firstColor = diffuseLighting(p, n, lightPos, diffuseColor, lightPower);
  Spectrum secondColor = diffuseLighting(p, n, secondLight, diffuseColor, secondLightPower);

  return firstColor.add(secondColor).toColor();
}

Spectrum diffuseLighting(Vec p, Vec n, Vec lightPos, Spectrum diffuseColor, Spectrum lightPower) {
  Vec v = lightPos.sub(p);
  Vec lightDir = v.normalize();

  float dot = n.dot(lightDir);

  if (dot > 0) {
    float r = v.len();
    float factor = dot / (4 * PI * r * r);
    return lightPower.scale(factor).mul(diffuseColor);
  } else {
    return BLACK;
  }
}
