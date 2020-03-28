final float EPS = 0.001;

class Ray {
  Vec origin;
  Vec dir;

  Ray (Vec origin, Vec dir) {
    this.dir = dir.normalize();
    this.origin = origin.add(this.dir.scale(EPS));
  }
}
