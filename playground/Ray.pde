class Ray {
  Vec origin;
  Vec dir;
  
  Ray (Vec origin, Vec dir) {
    this.origin = origin;
    this.dir = dir.normalize();
  }
}
