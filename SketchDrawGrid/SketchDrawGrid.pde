PVector A = new PVector();
PVector B = new PVector();
PVector C = new PVector();
PVector D = new PVector();

void setup() {
  size(1024, 768);
  frameRate(30);

  A.x = 2;
  A.y = 4;

  B.x = 10;
  B.y = 5;

  C.x = 12;
  C.y = 11;

  D.x = 3;
  D.y = 10;
}

void draw() {
  background(50);

  translate(0, height);
  scale(1, -1);
  scale(20, 20);
  
  stroke(255, 127);
  drawGrid();
  
  stroke(255);
  
  strokeWeight(4.0/20.0);
  point(A.x, A.y);
  point(B.x, B.y);
  point(C.x, C.y);
  point(D.x, D.y);

  strokeWeight(1.0/20.0);
  line(A.x, A.y, B.x, B.y);
  line(B.x, B.y, C.x, C.y);
  line(C.x, C.y, D.x, D.y);
  line(D.x, D.y, A.x, A.y);
}

void drawGrid() {
  strokeWeight(1.0/20.0);
  for (int x=0; x < 20; x++) {
    for (int y=0; y < 20; y++) {
      point(x, y);
    }
  }
}
