PVector position = new PVector();
PVector direction = new PVector();
float r;

void setup() {
    size(1024, 768);
    background(255);
    frameRate(60);
    noStroke();

    reset();
}

void draw() {
    for (int i=0; i < 10; i++) {
        drawLine();
    }
}

void reset() {

    position.x = random(width); 
    position.y = random(height);

    int i = 0;
    color mColor = get((int)position.x, (int)position.y);
    while (i < 10000 && brightness (get ( (int)position.x, (int)position.y)) != 0) {
        position.x = random(width); 
        position.y = random(height);
        i++;
    }

    r = random(-PI, PI);
    direction.x = sin(r);
    direction.y = cos(r);
}

void drawLine() {

    direction.x += random(-0.01, 0.01);
    direction.y += random(-0.01, 0.01);

    int x = (int)position.x;
    int y = (int)position.y;
    position.x += direction.x;
    position.y += direction.y;

    if (x == (int)position.x && y == (int)position.y) {
        return;
    }

    if (position.x <= 0 || position.x >= width || position.y <= 0 || position.y >= height) {
        reset();
    } 

    color mColor = get((int)position.x, (int)position.y);
    if (brightness(mColor) == 0) {
        reset();
    } else {
        set((int)position.x, (int) position.y, color(0));
    }
}

/* i think i got this code from somewhere but cannot remember from where … hmmm */
