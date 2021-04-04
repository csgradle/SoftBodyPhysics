// https://youtu.be/kyQP4t_wOGI



final float gravity = 10;
final int quality = 10;
final float dt = 0.4/quality; 

final float stiffness = 1000.;
final float damping =1;
final float len = 10;

final float minSelfCollisionDist = 0;

final float breakPoint = 1.5;

float time = 0;

SoftBody body = new SoftBody();

Vector2[] s1Points = {pt(290,300), pt(300, 350), pt(400,400), pt(395, 420), pt(175, 380), pt(170, 360), pt(250,350)};
Shape s1 = new Shape(s1Points); // center

Vector2[] s2Points = {pt(40,550), pt(600,550), pt(600, 590), pt(0,590), pt(0, 0), pt(31, 0)};
Shape s2 = new Shape(s2Points); // ground

Vector2[] s3Points = {pt(50, 110), pt(400, 140), pt(400, 160), pt(45, 130)};
Shape s3 = new Shape(s3Points); // top

Vector2[] s4Points = {pt(0, 600), pt(125, 600), pt(130, 620), pt(0, 620)};
Shape s4 = new Shape(s4Points); // lift

Vector2[] s5Points = {pt(151,501), pt(201, 499), pt(200,560), pt(150, 560)};
Shape s5 = new Shape(s5Points); // bump

Vector2[] s6Points = {pt(581,550), pt(580, 0), pt(640,0), pt(599, 641)};
Shape s6 = new Shape(s6Points); // right wall

Vector2[] s7Points = {pt(-21,550), pt(-20, 0), pt(21,0), pt(20, 550)};
Shape s7 = new Shape(s7Points); // left wall

Vector2[] s8Points = {pt(0,550), pt(600, 550), pt(600,650), pt(0, 650)};
Shape s8 = new Shape(s8Points); // ground wall

Vector2[] s9Points = {pt(-1,-50), pt(600, -50), pt(601,10), pt(1, 11)};
Shape s9 = new Shape(s9Points); // roof wall

Shape spike(float x, float y, float w, float h) {
  return new Shape(new Vector2[]{pt(x, y), pt(x+w, y+1), pt(x+w/2, y+h)});
}

//Shape[] shapes = {s1, s2, s4, s5, s6}; // main
Shape[] shapes = {s7, s6, s8, s9, spike(300,400, 30, -90), spike(500,550, 30, -150), spike(200,550, 30, -150), spike(20,550, 30, -30),spike(50,550, 30, -30),spike(80,550, 30, -30),spike(110,550, 30, -30),spike(140,550, 30, -30)}; // spikes
//Shape[] shapes = {s7, s6, s8, s9};
void setup(){
  size(600,600);
  
}
boolean dragging = false;
MassPoint massDragging;
Vector2 dragOffset;
void draw(){
  background(69,27,35);
  
  
  
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
    //updatePlatform(sin(radians(time*2))*150+430);
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
