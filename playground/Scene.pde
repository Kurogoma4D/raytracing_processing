class Scene {
  ArrayList<Intersectable> objList = new ArrayList<Intersectable>();
  ArrayList<Light> lightList = new ArrayList<Light>();

  Scene() {
  }

  void addIntersectable (Intersectable obj) {
    this.objList.add(obj);
  }

  void addLight (Light light) {
    this.lightList.add(light);
  }

  Spectrum trace (Ray ray) {
    Intersection intersect = findNearestIntersection(ray);
    if (!intersect.hit()) return BLACK;

    return lighting(intersect.p, intersect.n, intersect.material);
  }

  Intersection findNearestIntersection(Ray ray) {
    Intersection intersect = new Intersection();

    for (Intersectable obj : objList) {
      Intersection tempIntersect = obj.intersect(ray);
      if (tempIntersect.t < intersect.t) intersect = tempIntersect;
    }
    return intersect;
  }

  Spectrum lighting (Vec p, Vec n, Material m) {
    Spectrum L = BLACK;

    for (Light light : lightList) {
      Spectrum c = diffuseLighting(p, n, m.diffuse, light.pos, light.power);
      L = L.add(c);
    }

    return L;
  }

  Spectrum diffuseLighting (Vec p, Vec n, Spectrum diffuseColor, Vec lightPos, Spectrum lightPower) {
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
}
