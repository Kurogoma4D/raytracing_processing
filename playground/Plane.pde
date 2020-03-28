class Plane implements Intersectable {
  Vec n;
  float d;
  Material material;

  Plane (Vec p, Vec n, Material material) {
    this.n = n.normalize();
    this.d = -p.dot(this.n);
    this.material = material;
  }

  Intersection intersect (Ray ray) {
    Intersection intersect = new Intersection();
    float v = this.n.dot(ray.dir);
    float t = -(this.n.dot(ray.origin) + this.d) / v;

    if (0 < t) {
      intersect.t = t;
      intersect.p = ray.origin.add(ray.dir.scale(t));
      intersect.n = this.n;
      intersect.material = this.material;
    }

    return intersect;
  }
}
