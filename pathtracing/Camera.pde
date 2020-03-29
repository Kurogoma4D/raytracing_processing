class Camera {
  Vec eye, origin, xaxis, yaxis;

  void lookAt(Vec eye, Vec target, Vec up, float fov, int width, int height) {
    this.eye = eye;
    float imagePlane = (height / 2) / tan(fov / 2);
    Vec v = target.sub(eye).normalize();
    xaxis = v.cross(up).normalize();
    yaxis = v.cross(xaxis);
    Vec center = v.scale(imagePlane);
    origin = center
      .sub(xaxis.scale(0.5 * width))
      .sub(yaxis.scale(0.5 * height));
  }
  
  Ray ray(float x, float y) {
    Vec p = origin.add(xaxis.scale(x)).add(yaxis.scale(y));
    Vec dir = p.normalize();
    return new Ray(eye, dir);
  }
}
