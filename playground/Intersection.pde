class Intersection {
  float t = NO_HIT;
  Vec p;
  Vec n;
  Material material;

  Intersection() {
  }

  boolean hit() { 
    return this.t != NO_HIT;
  }
}

interface Intersectable {
  Intersection intersect(Ray ray);
}
