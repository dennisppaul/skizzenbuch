PVector fDirection = new PVector();
PVector fNormal = new PVector();
float fDirectionAngle;
float fDot;

void setup() {
    size(1024, 768);
    stroke(0);
    textFont(createFont("Courier", 12));

    fDirectionAngle = 0;
    update_direction();
}

void update_direction() {
    fDirection.set(cos(fDirectionAngle), sin(fDirectionAngle));
    fDirection.mult(100);
}

void draw() {
    fDirectionAngle += 0.01f;
    update_direction();

    fNormal.set(PVector.sub(new PVector().set(mouseX, mouseY), new PVector().set(width / 2, height / 2)).normalize());
    PVector mReflectedDirection = reflect(fDirection, fNormal);

    /* draw */
    background(255);

    noStroke();
    fill(0);
    text(fDot, 10, 20);

    translate(width / 2, height / 2);

    stroke(0, 0, 0);
    final float s = 50;
    line(0, 0, fNormal.x * s, fNormal.y * s);
    line(0, 0, -fNormal.y * s * 0.5, fNormal.x * s * 0.5);

    stroke(255, 0, 0);
    line(0, 0, fDirection.x, fDirection.y);

    if (fDot > 0) {
        stroke(0, 255, 0); // green if reflected on *frontface*
    } else {
        stroke(191); // grey if reflected on *backface*
    }
    line(0, 0, mReflectedDirection.x, mReflectedDirection.y);
}

PVector reflect(PVector pDirection, PVector pNormal) {
    // r = e - 2 (e.n) n :: ( | n | = 1 )
    // with e :: direction
    //      r :: reflection
    //      n :: normal
       
    PVector n = new PVector().set(pNormal).normalize();
    PVector e = new PVector().set(pDirection);
    float d = PVector.dot(e, n); // d > 0 = frontface, d < 0 = backface
    fDot = d;
    n.mult(2 * d);
    PVector r = PVector.sub(n, e); // @todo why are they flipped?
    return r;
}
