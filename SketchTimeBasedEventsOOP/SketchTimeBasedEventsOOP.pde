color mBoxFillColor = color(255);
EventProducer mEventProducer;

void settings() {
  size(1024, 768);
}

void setup() {
  mEventProducer = new EventProducer(this, "change_box_fill_color");

  strokeWeight(15.0);
  strokeJoin(MITER);
}

void draw() {
  background(50);

  noStroke();
  fill(mBoxFillColor);
  rect(width/4, height/4, width/2 * mEventProducer.duration(), height/2);

  noFill();
  stroke(255);
  rect(width/4, height/4, width/2, height/2);

  mEventProducer.update(1.0 / frameRate);
}

void change_box_fill_color() {
  int r = round(random(0, 2)) * 127;
  int g = (r + 127) % 255;
  int b = (g + 127) % 255;
  mBoxFillColor = color(r, g, b);
}

void mousePressed() {
  mEventProducer.interval(1.0 + 2.0 * (float)mouseX/(float)width);
  mEventProducer.reset();
}
