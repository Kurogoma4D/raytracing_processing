class Material {
  Spectrum diffuse;
  float reflective = 0;
  float refractive = 0;
  float refractiveIndex = 1;
  Spectrum emissive = BLACK;
  
  Material (Spectrum diffuse) {
    this.diffuse = diffuse;
  }
}
