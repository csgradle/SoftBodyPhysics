class Spring{
  MassPoint A, B;
  boolean broken;
  float ks, L, kd; // stiffness, rest length, damping factor
  Spring(MassPoint a, MassPoint b, float ks, float L, float kd) {
    A=a; B=b; this.ks=ks; this.L=L; this.kd=kd;
    broken = false;
  }
  float getForce() {
    float fs = (B.p.subtract(A.p).d - L) * ks; // force of spring
    float fd = B.p.subtract(A.p).dot(B.v.subtract(A.v))*kd; // force of dampening
    
    return fs + fd;
  }
  void update() {
    if(broken) return;
    float force = getForce();
    Vector2 fA = B.p.subtract(A.p).normalized().multiply(force); 
    Vector2 fB = A.p.subtract(B.p).normalized().multiply(force); 
    A.nf = A.nf.add(fA);
    B.nf = B.nf.add(fB);
    float d = dist(A.p.x, A.p.y, B.p.x, B.p.y);
    if((d > L*breakPoint || d < breakPoint/L) && massDragging != A && massDragging != B) broken = true;
  }
  void draw() {
    if(broken) return;
    float d = abs(L-dist(A.p.x, A.p.y, B.p.x, B.p.y));
    stroke(255, 255-d*30, 255-d*40); strokeWeight(1);
    line(A.p.x, A.p.y, B.p.x, B.p.y);
  }
}
