// https://youtu.be/kyQP4t_wOGI



final float gravity = 10;
final int quality = 20;
final float dt = 0.4/quality; 

final float stiffness = 50.;
final float damping =1;
final float len = 30;

final float minSelfCollisionDist = 0.7;

float time = 0;

SoftBody body = new SoftBody();

Vector2[] s1Points = {pt(290,300), pt(400,400), pt(395, 420), pt(175, 380), pt(170, 360), pt(250,350)};
Shape s1 = new Shape(s1Points); // center

Vector2[] s2Points = {pt(30,550), pt(600,550), pt(600, 590), pt(0,590), pt(0, 0), pt(31, 0)};
Shape s2 = new Shape(s2Points); // ground

Vector2[] s3Points = {pt(50, 110), pt(400, 140), pt(400, 160), pt(45, 130)};
Shape s3 = new Shape(s3Points); // top

Vector2[] s4Points = {pt(25, 600), pt(125, 600), pt(130, 620), pt(20, 620)};
Shape s4 = new Shape(s4Points); // lift

Vector2[] s5Points = {pt(151,501), pt(201, 499), pt(200,560), pt(150, 560)};
Shape s5 = new Shape(s5Points); // bump

Vector2[] s6Points = {pt(581,550), pt(580, 0), pt(600,0), pt(600, 550)};
Shape s6 = new Shape(s6Points); // right wall


Shape[] shapes = {s1, s2, s4, s5, s6};
void setup(){
  size(600,600);
  
}
boolean dragging = false;
MassPoint massDragging;
Vector2 dragOffset;
void draw(){
  background(27,49,35);
  
  
  
  for(int i = 0; i < shapes.length; i++) {
    shapes[i].draw();
  }
  
  MassPoint dragP = body.nearestMass();
  if(dist(dragP.p.x, dragP.p.y, mouseX, mouseY) < 30) {
    noStroke();
    fill(255,0,0);
    ellipse(dragP.p.x, dragP.p.y, 10,10);
    if(mousePressed && !dragging) {
      dragging = true;
      massDragging = dragP;
      dragOffset = new Vector2(dragP.p.x-mouseX, dragP.p.y-mouseY);
    }
  }
  if(!mousePressed) dragging = false;
  
  
  for(int i = 0; i < quality; i++) {
    time += dt;
    updatePlatform(sin(radians(time*2))*150+430);
    if(dragging) {
      massDragging.p = new Vector2(mouseX, mouseY).add(dragOffset);
      massDragging.np = new Vector2(mouseX, mouseY).add(dragOffset);
      massDragging.v = new Vector2(0,0);
      massDragging.nv = new Vector2(0,0);
      massDragging.f = new Vector2(0,0);
      massDragging.nf = new Vector2(0,0);
    }
    body.update();
  }
  body.draw();
  
  
  println(frameRate);
  fill(255);stroke(255);
  text(mouseX + ", " + mouseY, mouseX, mouseY);
}
void updatePlatform(float y) {
  for(int i = 0; i < s4Points.length; i++) {
    if(i < 2) {
      s4Points[i] = new Vector2(s4Points[i].x, y);
    } else {
      s4Points[i] = new Vector2(s4Points[i].x, y+300);
    }
  }
  shapes[2] = new Shape(s4Points);
}
