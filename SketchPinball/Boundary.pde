class Boundary {

  float x;
  float y;
  float w;
  float h;
  Body b;

  Boundary(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    
    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);

    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x, y));
    b = box2d.createBody(bd);

    // Attached the shape to the body using a Fixture
    b.createFixture(sd, 1);
  }

  void display() {
    fill(255);
    noStroke();
    rectMode(CENTER);
    rect(x, y, w, h);
  }

  void killBody() {
    box2d.destroyBody(b);
  }
}
