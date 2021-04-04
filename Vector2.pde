class Vector2 {
  float x, y, d;
  Vector2(float x, float y) {
    this.x = x;
    this.y = y;
    d = sqrt(x*x + y*y);
  }
  Vector2() {
    this.x = 0;
    this.y = 0;
    d = 0;
  }
  Vector2 normalized() {
    return new Vector2(x/d, y/d);
  }
  Vector2 subtract(Vector2 b) {
    return new Vector2(x - b.x, y - b.y);
  }
  Vector2 add(Vector2 b) {
    return new Vector2(x + b.x, y + b.y);
  }
  Vector2 multiply(float b) {
    return new Vector2(x*b, y*b);
  }
  Vector2 divide(float b) {
    return new Vector2(x/b, y/b);
  }
  float dot(Vector2 b) {
    return x*b.x + y*b.y;
  }
  Vector2 reflect(Vector2 wallN) { // input: wallNormal
    wallN = wallN.normalized();
    //Vector2 wallN = new Vector2(-wall.y, wall.x);
    return this.subtract(wallN.multiply(2*wallN.dot(this)));
  }
  Vector2 project(Vector2 b) {
    return b.multiply(dot(b)/(b.d*b.d));
  }
  Vector2 copy() {
    return new Vector2(x, y);
  }
  String toString() {
    return "<" + x + "," + y + ">";
  }
  
}
Vector2 pt(float x, float y) {
  return new Vector2(x, y);
}
