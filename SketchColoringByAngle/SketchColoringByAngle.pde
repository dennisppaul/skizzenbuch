final static int NUM_AGENTS_X = 55;
final static int NUM_AGENTS_Y = 41;
final static float AGENT_SPACE = 18.0f;
final static float AGENT_SIZE = 4.0f;
MAgent[][] mAgents = new MAgent[NUM_AGENTS_X][NUM_AGENTS_Y];
MAgent mCenter = new MAgent();

void settings() {
    size(1024, 768);
}

void setup() {
    colorMode(HSB, 255);
    for (int x=0; x<mAgents.length; x++) {
        for (int y=0; y<mAgents[x].length; y++) {
            mAgents[x][y] = new MAgent();
            mAgents[x][y].position.set(x - (NUM_AGENTS_X-1) / 2.0, y - (NUM_AGENTS_Y-1) / 2.0);
            mAgents[x][y].position.mult(AGENT_SPACE);
        }
    }
}

void draw() {
    background(50);
    translate(width/2, height/2);

    PVector mMouse = new PVector().set(mouseX-width/2, mouseY-height/2);
    PVector mDirection = PVector.sub(mMouse, mCenter.position).normalize();
    mCenter.direction.set(mDirection);

    final float DIRECTION_SCALE = 50;
    stroke(255);
    line(mCenter.position.x + mCenter.direction.x * DIRECTION_SCALE,
        mCenter.position.y + mCenter.direction.y * DIRECTION_SCALE,
        mCenter.position.x,
        mCenter.position.y);

    noStroke();
    for (int x=0; x<mAgents.length; x++) {
        for (int y=0; y<mAgents[x].length; y++) {
            MAgent a = mAgents[x][y];
            a.update(mCenter);
            PVector p = a.position;
            fill(a.m_color);
            ellipse(p.x, p.y, AGENT_SIZE*2 * a.scale + 2, AGENT_SIZE*2 * a.scale + 2);
        }
    }
}

class MAgent {
    PVector position = new PVector();
    PVector direction = new PVector(0, 1);
    color m_color = color(255);
    float scale = 1;

    void update(MAgent a) {
        PVector mDirection = PVector.sub(a.position, position);
        float mAngle = PVector.angleBetween(mDirection, a.direction);
        float mAngleNorm = mAngle / PI;
        mAngleNorm = pow(mAngleNorm, 10);
        m_color = color(55 + 200 * mAngleNorm, 255, 255);
        scale = mAngleNorm * 2 + 0.3;
    }
}
