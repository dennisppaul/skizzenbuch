ArrayList<Light> fImageInstances = new ArrayList<>();
PImage fImage;

void setup() {
    size(1024, 768, P3D);
    imageMode(CENTER);
    fImage = loadImage("glow-doto-no-transparent.png");

    for (int i=0; i < 1024; i++) {
        fImageInstances.add(new Light(random(width), random(height), random(255), random(2, 32)));
    }
}

void draw() {
    background(0);
    blendMode(SCREEN);

    tint(255);
    image(fImage, mouseX, mouseY, 64, 64);
    for (Light p : fImageInstances) {
        if (p.postion.x > width * 0.5) {
            tint(p.r, p.g, p.b);
        } else {
            tint(p.brightness);
        }
        image(fImage, p.postion.x, p.postion.y, p.size, p.size);
        /* move */
        p.postion.x += 0.25 + p.size / frameRate;
        if (p.postion.x > width) {
            p.postion.x -= width;
        }
    }
}

void mouseMoved() {
    fImageInstances.add(new Light(mouseX, mouseY, random(255), random(2, 32)));
}

class Light {
    PVector postion = new PVector();
    float brightness;
    float size;
    float r, g, b;

    Light(float x, float y, float brightness, float size) {
        postion.x = x;
        postion.y = y;
        this.brightness = brightness;
        this.size = size;
        r = random(255);
        g = random(255);
        b = random(255);
    }
}
