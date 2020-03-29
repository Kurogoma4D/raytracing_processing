final int DEPTH_MAX = 10;
final float VACUUM_REFRACTIVE_INDEX = 1.0;

class Scene {
  ArrayList<Intersectable> objList = new ArrayList<Intersectable>();
  ArrayList<Light> lightList = new ArrayList<Light>();
  Spectrum color_sky = new Spectrum(0.7, 0.7, 0.7);

  Scene() {
  }

  void addIntersectable (Intersectable obj) {
    this.objList.add(obj);
  }

  void addLight (Light light) {
    this.lightList.add(light);
  }

  void setSkyColor (Spectrum newColor) {
    color_sky = newColor;
  }

  Spectrum trace (Ray ray, int depth) {
    if (DEPTH_MAX < depth) return BLACK;

    Intersection intersect = findNearestIntersection(ray);
    if (!intersect.hit()) return color_sky;

    Material m = intersect.material;
    float dot = intersect.n.dot(ray.dir);
    
    if (dot < 0) {
      Spectrum col = interactSurface(ray.dir, intersect.p, intersect.n, m, VACUUM_REFRACTIVE_INDEX / m.refractiveIndex, depth);
      return col.add(m.emissive.scale(-dot));
    } else {
      return interactSurface(ray.dir, intersect.p, intersect.n.neg(), m, m.refractiveIndex / VACUUM_REFRACTIVE_INDEX, depth);
    }
  }

  Spectrum interactSurface (Vec rayDir, Vec p, Vec n, Material m, float eta, int depth) {
    float ks = m.reflective;
    float kt = m.refractive;

    float t = random(0.0, 1.0);

    if (t < ks) {
      Vec r = rayDir.reflect(n);
      Spectrum c = trace(new Ray(p, r), depth + 1);
      return c.mul(m.diffuse);
    } else if (t < ks + kt) {
      Vec r = rayDir.refract(n, eta);
      Spectrum c = trace(new Ray(p, r), depth + 1);
      return c.mul(m.diffuse);
    } else {
      Vec r = n.randomHemisphere();
      Spectrum li = trace(new Ray(p, r), depth + 1);

      Spectrum fr = m.diffuse.scale(1.0 / PI);
      float factor = 2.0 * PI * n.dot(r);
      Spectrum l = li.mul(fr).scale(factor);

      return l;
    }
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
      if (visible(p, lightPos)) {
        float r = v.len();
        float factor = dot / (4 * PI * r * r);
        return lightPower.scale(factor).mul(diffuseColor);
      }
    }
    return BLACK;
  }

  boolean visible(Vec org, Vec target) {
    Vec v = target.sub(org).normalize();
    Ray shadowRay = new Ray(org, v);

    for (Intersectable obj : objList) {
      if (obj.intersect(shadowRay).t < v.len()) return false;
    }

    return true;
  }
}
