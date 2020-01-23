class Paddle {

  // Our object is two boxes and one joint
  // Consider making the fixed box much smaller and not drawing it
  RevoluteJoint joint;
  Box box1;
  Box box2;

  float mSpeed = PI*2 * 10;

  Paddle(float x, float y, float pAngleMin, float pAngleMax) {

    // Initialize locations of two boxes
    final int mPaddleSize = 5;
    final float mOffset = BOUNDARY_PIXEL_SCALE * mPaddleSize * 0.5 - BOUNDARY_PIXEL_SCALE * 0.5;
    box1 = new Box(x + mOffset, y, BOUNDARY_PIXEL_SCALE * mPaddleSize, BOUNDARY_PIXEL_SCALE, false); 
    box2 = new Box(x, y, BOUNDARY_PIXEL_SCALE, BOUNDARY_PIXEL_SCALE, true); 

    // Define joint as between two bodies
    RevoluteJointDef rjd = new RevoluteJointDef();

    //Vec2 offset = box2d.vectorPixelsToWorld(new Vec2(10, 0));
    //rjd.initialize(box1.body, box2.body, offset);

    //rjd.initialize(box1.body, box2.body, box1.body.getWorldCenter());
    rjd.initialize(box1.body, box2.body, box1.body.getWorldCenter().add(box2d.vectorPixelsToWorld(new Vec2(-mOffset, 0))));

    // Turning on a motor (optional)
    rjd.motorSpeed = mSpeed;       // how fast?
    rjd.maxMotorTorque = 1000.0 * 1000; // how powerful?
    rjd.enableMotor = true;      // is it on?
    rjd.enableLimit = true;
    rjd.lowerAngle = pAngleMin;
    rjd.upperAngle = pAngleMax;

    // There are many other properties you can set for a Revolute joint
    // For example, you can limit its angle between a minimum and a maximum
    // See box2d manual for more

    // Create the joint
    joint = (RevoluteJoint) box2d.world.createJoint(rjd);
    joint.getJointAngle();
  }

  // Turn the motor on or off
  void toggleMotor() {
    joint.enableMotor(!joint.isMotorEnabled());
  }

  boolean motorOn() {
    return joint.isMotorEnabled();
  }

  void turn_left() {
    joint.setMotorSpeed(-mSpeed);
  }

  void turn_right() {
    joint.setMotorSpeed(mSpeed);
  }

  void display() {
    //box2.display();
    box1.display();
  }
}
