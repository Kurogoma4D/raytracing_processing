class Sphere implements Intersectable {
  Vec center;
  float radius;
  Material material;

  Sphere (Vec center, float radius, Material material) {
    this.center = center;
    this.radius = radius;
    this.material = material;
  }

  Intersection intersect(Ray ray) {
    Intersection intersect = new Intersection();
    Vec v = ray.origin.sub(this.center);
    float b = ray.dir.dot(v);
    float c = v.dot(v) - sq(this.radius);
    float d = b * b - c;

    if ( d >= 0 ) {
      float s = sqrt(d);
      float t = -b - s;
      if (t <= 0) t = -b + s;
      if (0 < t) {
        intersect.t = t;
        intersect.p = ray.origin.add(ray.dir.scale(t));
        intersect.n = intersect.p.sub(this.center).normalize();
        intersect.material = this.material;
      }
    }
    
    return intersect;
  }
}
