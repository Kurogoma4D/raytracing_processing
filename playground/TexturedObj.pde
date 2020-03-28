class TexturedObj implements Intersectable {
  Intersectable obj;
  PImage image;
  float size;
  Vec origin;
  Vec uDir;
  Vec vDir;

  Material material;

  TexturedObj (Intersectable obj, PImage image, float size, Vec origin, Vec uDir, Vec vDir) {
    this.obj = obj;
    this.image = image;
    this.size = size;
    this.origin = origin;
    this.uDir = uDir;
    this.vDir = vDir;
  }

  Intersection intersect (Ray ray) {
    Intersection isect = obj.intersect(ray);

    if (isect.hit()) {
      float u = isect.p.sub(this.origin).dot(this.uDir) / this.size;
      u = floor((u - floor(u)) * this.image.width);
      float v = isect.p.sub(this.origin).dot(this.vDir) / this.size;
      v = floor((v - floor(v)) * this.image.height);
      
      color c = this.image.get(int(u), int(v));
      
      Material mtl = new Material(new Spectrum(red(c) / 255.0, green(c) / 255.0, blue(c) / 255.0).mul(isect.material.diffuse));
      mtl.reflective = isect.material.reflective;
      mtl.refractive = isect.material.refractive;
      isect.material = mtl;
    }
    
    return isect;
  }
}
