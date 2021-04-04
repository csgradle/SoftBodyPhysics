class SoftBody {
  MassPoint[] points;
  Spring[] springs;
  SoftBody() {    
    int w = 3, h = 5;

    points = new MassPoint[w*h];
    float mass = 15;
    for(int y = 0; y < w; y++) {
      for(int x = 0; x < h; x++) {
        points[x+y*h] = new MassPoint(new Vector2(x*len+250, y*len+30), mass);
      }
    }
    //points[0] = new MassPoint(new Vector2(300, 100), mass);
    //points[1] = new MassPoint(new Vector2(320, 100), mass);
    //points[2] = new MassPoint(new Vector2(320, 80), mass);
    //points[3] = new MassPoint(new Vector2(300, 80), mass);
    
   
    springs = new Spring[(h-1)*(w-1)*4 + (h-1) + (w-1)];
    
    int index = 0;
    for(int y = 0; y < w-1; y++) {
      for(int x = 0; x < h-1; x++) {
        springs[index] = new Spring(points[x+y*h],points[(x+1)+y*h],stiffness,len,damping);
        springs[index+1] = new Spring(points[x+y*h],points[x+(y+1)*h],stiffness,len,damping);
        springs[index+2] = new Spring(points[x+y*h],points[(x+1)+(y+1)*h],stiffness,len * sqrt(2),damping);
        springs[index+3] = new Spring(points[(x+1)+y*h],points[x+(y+1)*h],stiffness,len * sqrt(2),damping);
        index += 4;
      }
    }
    for(int y = 0; y < w-1; y++) {
      springs[index] = new Spring(points[(h-1)+y*h], points[(h-1)+(y+1)*h], stiffness, len, damping);
      index++;
    }
    for(int x = 0; x < h-1; x++) {
      springs[index] = new Spring(points[x+(w-1)*h], points[(x+1)+(w-1)*h], stiffness, len, damping);
      index++;
    }
    
    //springs[0] = new Spring(points[0], points[1], stiffness, len, damping);
    //springs[1] = new Spring(points[1], points[2], stiffness, len, damping);
    //springs[2] = new Spring(points[2], points[3], stiffness, len, damping);
    //springs[3] = new Spring(points[3], points[0], stiffness, len, damping);
    //springs[4] = new Spring(points[1], points[3], stiffness, len, damping);
    //springs[5] = new Spring(points[2], points[0], stiffness, len, damping);
  }
  void update() {
    for(int i = 0; i < points.length; i++) {
      points[i].frameReset();
    }
    for(int i = 0; i < springs.length; i++) {
      springs[i].update();
    }
    if(minSelfCollisionDist > 0.01) {
      for(int i = 0; i < points.length; i++) {
        for(int n = i+1; n < points.length; n++) {
          selfCollide(points[i], points[n]);
        }
      }
    }
    for(int i = 0; i < points.length; i++) {
      points[i].update();
    }
    for(int i = 0; i < points.length; i++) {
      points[i].collision();
    }
    
    for(int i = 0; i < points.length; i++) {
      points[i].push();
    }
  }
  void draw() {
    for(int i = 0; i < springs.length; i++) {
      springs[i].draw();
    }
    for(int i = 0; i < points.length; i++) {
      //points[i].draw();
      
    }
  }
  void selfCollide(MassPoint a, MassPoint b) {
    float selfCollisionDist = len*minSelfCollisionDist;
    float d = dist(a.p.x, a.p.y, b.p.x, b.p.y);
    if(d < 0.01) return;
    if(d < selfCollisionDist) {
      float overlap = selfCollisionDist-d;
      Vector2 dir = b.p.subtract(a.p).normalized();
      a.np = a.np.add(dir.multiply(-overlap/2));
      b.np = b.np.add(dir.multiply(overlap/2));
      
      a.nv = a.nv.reflect(dir.multiply(-1));
      b.nv = b.nv.reflect(dir);
      
      
    }
  }
  MassPoint nearestMass() {
    float nearestD = 100000;
    MassPoint nearestPoint = new MassPoint();
    for(int i = 0; i < points.length; i++) {
      float d = dist(points[i].p.x, points[i].p.y, mouseX, mouseY);
      if(d < nearestD) {
        nearestD = d;
        nearestPoint = points[i];
      }
    }
    return nearestPoint;
  }
}
