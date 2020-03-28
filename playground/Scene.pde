final int DEPTH_MAX = 10;
final float VACUUM_REFRACTIVE_INDEX = 1.0;

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

  Spectrum trace (Ray ray, int depth) {
    if (DEPTH_MAX < depth) return BLACK;

    Intersection intersect = findNearestIntersection(ray);
    if (!intersect.hit()) return BLACK;

    Material m = intersect.material;
    Spectrum l = BLACK;

    if (intersect.n.dot(ray.dir) < 0) {
      float ks = m.reflective;
      if (0 < ks) {
        Vec r = ray.dir.reflect(intersect.n);
        Spectrum c = trace(new Ray(intersect.p, r), depth + 1);
        l = l.add(c.scale(ks).mul(m.diffuse));
      }
      
      float kt = m.refractive;
      if (0 < kt) {
        Vec r = ray.dir.refract(intersect.n, VACUUM_REFRACTIVE_INDEX / m.refractiveIndex);
        Spectrum c = trace(new Ray(intersect.p, r), depth + 1);
        l = l.add(c.scale(kt).mul(m.diffuse));
      }

      float kd = 1.0 - ks;
      if (0 < kd) {
        Spectrum c = lighting(intersect.p, intersect.n, intersect.material);
        l = l.add(c.scale(kd));
      }
    } else {
      Vec r = ray.dir.refract(intersect.n.neg(), m.refractiveIndex / VACUUM_REFRACTIVE_INDEX);
      l = trace(new Ray(intersect.p, r), depth + 1);
    }

    return l;
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
