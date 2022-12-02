class Mirror {
    PVector position;
    PVector start = new PVector();
    PVector end = new PVector();
    PVector normal = new PVector();
    final float radius = 20;
    float rotation;

    Mirror() {
        position = new PVector(0, 0);
        rotation = 0;
        update();
    }

    void update() {
        start.set(radius * sin(rotation), radius * cos(rotation));
        start.add(position);
        end.set(-radius * sin(rotation), -radius * cos(rotation));
        end.add(position);
        normal.set(sin(rotation - PI/2), cos(rotation - PI/2)); // rotated by 90° or PI/2
    }

    void draw() {
        strokeWeight(2);
        stroke(255);
        line(start.x, start.y, end.x, end.y);

        /* draw normal */
        strokeWeight(1);
        final float mNormalScale = 10;
        line(
            position.x,
            position.y,
            position.x + normal.x * mNormalScale,
            position.y + normal.y * mNormalScale
            );
    }
}
