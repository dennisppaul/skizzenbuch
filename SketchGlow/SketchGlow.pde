Thing mThing;
PShader blur;
PGraphics pg;

/* note, color are slightly bent in shader to increase bloom effect.
 * this effect can be changed in shader with `adjust`. 
 */

void setup() {
    size(1024, 768, P2D);

    blur = loadShader("blur.glsl");
    blur.set("adjust", 0.94);
    pg = createGraphics(width, height, P2D);

    mThing = new Thing();
}

void draw() {
    mThing.position.set(mouseX, mouseY);

    background(0);

    /* draw into offscreen canvas */
    pg.beginDraw();
    pg.background(0);
    pg.fill(255);
    pg.circle(width / 2, height / 2, 200);
    mThing.display(pg);
    pg.endDraw();

    /* draw offscreen canvas */
    blendMode(BLEND);
    image(pg, 0, 0, width, height);
    /* blur offscreen canvas */
    blurCanvas();
    /* draw blurred offscreen canvas */
    blendMode(SCREEN);
    image(pg, 0, 0, width, height);
}

void blurCanvas() {
    if (mousePressed) {
        pg.filter(BLUR, 4);
    } else {
        for (int i=0; i<25; i++) {
            pg.filter(blur);
        }
    }
}

class Thing {
    PVector position = new PVector();
    float radius = 50;

    void display(PGraphics pg) {
        pg.noStroke();
        pg.fill(255, 127, 0);
        pg.circle(position.x, position.y, radius * 2);
        pg.circle(position.x + radius, position.y, radius);
    }
}
