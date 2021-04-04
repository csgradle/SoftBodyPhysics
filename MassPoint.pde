class MassPoint {
  Vector2 p, v, f; // official vectors: position, velocity, force
  Vector2 np, nv, nf; // update vectors
  float mass;
  
  MassPoint(Vector2 p, float m) {
    this.p = p;
    this.v = new Vector2();
    this.f = new Vector2();
    this.np = p;
    this.nv = v;
    this.nf = f;
    this.mass = m;
  }
  MassPoint() {
    
  }
  void frameReset() {
    nf = new Vector2();
    
  }
  void update() {
    
    nf = nf.add(new Vector2(0, gravity));
    nv = nv.add( nf.multiply(dt).divide(mass));
    np = np.add(nv.multiply(dt));
  }
  void push() {
    f = nf.copy();
    v = nv.copy();
    p = np.copy();
    
  }
  void collision() {
    for(Shape shape : shapes) {
      Vector2 intersection = shape.inShape(p);
      if(intersection.x != 0 && intersection.y != 0) {
        Vector2 coord1 = p.add(intersection).add(intersection.normalized().multiply(5));
        Vector2 coord2 = p.add(intersection).add(intersection.normalized().multiply(-5));
        stroke(0,255,0); strokeWeight(2);
        line(coord1.x, coord1.y, coord2.x, coord2.y);
        
        np = p.add(intersection);
        nv = nv.reflect(intersection);
        break;
      }
    }
  }
  
  void draw() {
    

    fill(255,0,0);noStroke();
    ellipse(p.x, p.y, 8, 8);
  }
}
