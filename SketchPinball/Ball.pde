class Ball {

  Body body;
  float r;

  Ball(float x, float y, float pRadius, PVector pDirection) {
    r = pRadius;
    makeBody(new Vec2(x, y), pDirection);
  }

  void killBody() {
    box2d.destroyBody(body);
  }

  boolean done() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if (pos.y > height+r) {
      killBody();
      return true;
    }
    return false;
  }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(0, 127, 255);
    noStroke();

    ellipse(0, 0, r*2, r*2);
    popMatrix();
  }

  void makeBody(Vec2 center, PVector pDirection) {
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    CircleShape circle = new CircleShape();
    circle.m_radius = box2d.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = circle;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.5;

    // Attach fixture to body
    body.createFixture(fd);

    // Give it some initial random velocity
    body.setLinearVelocity(new Vec2(-pDirection.x, pDirection.y));
    //body.setAngularVelocity(random(-5, 5));
  }
}
