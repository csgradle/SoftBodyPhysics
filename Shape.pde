class Shape {
  Vector2[] points;
  Vector2 boundMin;
  Vector2 boundMax;
  Shape(Vector2[] points) {
    this.points = points;
    boundMin = new Vector2(10000,10000);
    boundMax = new Vector2(-10000,-10000);
    for(int i = 0; i < points.length; i++) {
      float x = points[i].x;
      float y = points[i].y;
      if(x < boundMin.x) boundMin.x = x;
      if(x > boundMax.x) boundMax.x = x;
      if(y < boundMin.y) boundMin.y = y;
      if(y > boundMax.y) boundMax.y = y;
    }
  }
  void draw() {
    noFill();
    stroke(255);
    strokeWeight(2);
    beginShape();
    for(Vector2 p : points) {
      vertex(p.x, p.y);
    }
    endShape(CLOSE);
  }
  Vector2 inShape(Vector2 p) {
    int hits = 0;
    for(int i = 0; i < points.length; i++) {
      if(p.x < boundMax.x && p.x > boundMin.x && p.y > boundMin.y && p.y < boundMax.y) {
        boolean intersected = isIntersect(
            new Vector2(-200, p.y), 
            new Vector2(200+p.x, 0), 
            points[i], 
            points[(i+1)%points.length].subtract(points[i]), true);
            
        //boolean intersected2 = isIntersect(
        //    new Vector2(p.x, -200), 
        //    new Vector2(0, 200+p.y), 
        //    points[i], 
        //    points[(i+1)%points.length].subtract(points[i]), false);
            
        if(intersected) {
          hits++;
        }
      }
    }
    if(hits %2 == 1) {
      float closestDist = 100000;
      Vector2 closestPos = new Vector2();
      for(int i = 0; i < points.length; i++) {
        Vector2 b = points[(i+1)%points.length].subtract(points[i]);
        Vector2 projection = p.subtract(points[i]).project(b); // project p onto line
        if(projection.dot(b) < 0 || projection.d > b.d) continue;
        float d = points[i].add(projection).subtract(p).d; // distance from point to projection
        if(d < closestDist) {
          closestDist = d;
          closestPos = points[i].add(projection).subtract(p); 
        }
      }
      return closestPos; // returns the direction normal from point origin to where the projection is
    }
    return new Vector2(0,0);
  }
  boolean isIntersect(Vector2 o1, Vector2 d1, Vector2 o2, Vector2 d2, boolean isHorizontal) {
    // o1 and d1 should be the line segment for horizontal/vertical
    float t;
    Vector2 intersect;
    if(isHorizontal) {
      t = (o1.y-o2.y) / (d2.y/d2.d);
      intersect = o2.add(d2.normalized().multiply(t));
      if(t < d2.d && t > 0 
        && ( (intersect.x > o1.x && intersect.x < o1.x + d1.x)
        || (intersect.x < o1.x && intersect.x > o1.x + d1.x) )
        ) {
        return true;
      }
    } else {
      t = (o1.x-o2.x) / (d2.x/d2.d);
      intersect = o2.add(d2.normalized().multiply(t));
      if(t < d2.d && t > 0 
        && ( (intersect.y > o1.y && intersect.y < o1.y + d1.y)
        || (intersect.y < o1.y && intersect.y > o1.y + d1.y) )
        ) {
        return true;
      }
    }
    
    return false;
  }

}
