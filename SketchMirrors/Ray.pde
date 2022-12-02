class Ray {
    float intensity = 1.0;
    float fall_off = 0.95;
    float beam_width = 4;
    PVector position = new PVector();
    PVector direction = new PVector(1, 0);
    boolean draw_hit_point = false;

    PVector fLastHitPoint = null;
    Ray fChildRay;

    void setOrigin(PVector p) {
        position.set(p);
    }

    void setDirection(PVector d) {
        direction.set(d);
    }

    void clear() {
        if (fChildRay != null) {
            fChildRay.clear();
        }
        fChildRay = null;
    }

    void draw() {
        if (fChildRay != null) {
            fChildRay.draw();
        }
        float mIntensityAlpha = intensity * 255;
        float mIntensityWidth = 1 + intensity * beam_width;
        stroke(255, 0, 0, mIntensityAlpha);
        if (fLastHitPoint != null) {
            strokeWeight(mIntensityWidth);
            line(
                position.x,
                position.y,
                fLastHitPoint.x,
                fLastHitPoint.y
                );
            strokeWeight(1);
            if (draw_hit_point) {
                stroke(255);
                noFill();
                circle(fLastHitPoint.x, fLastHitPoint.y, 10);
            }
        } else {
            final float mDefaultLength = width;
            line(
                position.x,
                position.y,
                position.x + direction.x * mDefaultLength,
                position.y + direction.y * mDefaultLength
                );
        }
    }

    void update(ArrayList<Mirror> pMirrors) {
        PVector mClosestHitPoint = null;
        float mClosestDistance = Float.MAX_VALUE;
        Mirror mHitMirror = null;
        for (Mirror m : pMirrors) {
            PVector mCurrentHitPoint = cast(m);
            if (mCurrentHitPoint != null) {
                float mCurrentDistance = PVector.dist(position, mCurrentHitPoint);
                if (mCurrentDistance < mClosestDistance && mCurrentDistance > m.radius) {
                    mClosestDistance = mCurrentDistance;
                    mClosestHitPoint = mCurrentHitPoint;
                    mHitMirror = m;
                }
            }
        }

        if (mClosestHitPoint != null && mHitMirror != null) {
            fLastHitPoint = mClosestHitPoint;
            fChildRay = new Ray();
            fChildRay.intensity = intensity * fall_off;
            fChildRay.setOrigin(mClosestHitPoint);
            fChildRay.setDirection(reflect(direction, mHitMirror.normal));
            fChildRay.update(pMirrors);
        } else {
            fChildRay = null;
            fLastHitPoint = null;
        }
    }

    PVector reflect(PVector pDirection, PVector pNormal) {
        // r = e - 2 (e.n) n :: ( | n | = 1 )
        // with e :: direction
        //      r :: reflection
        //      n :: normal
        PVector n = new PVector().set(pNormal).normalize();
        PVector e = new PVector().set(pDirection);
        float d = PVector.dot(e, n);    // d > 0 = frontface, d < 0 = backface
        n.mult(2 * d);
        PVector r = PVector.sub(e, n);
        return r;
    }

    PVector cast(Mirror node) {
        float x1 = node.start.x;
        float y1 = node.start.y;
        float x2 = node.end.x;
        float y2 = node.end.y;

        float x3 = position.x;
        float y3 = position.y;
        float x4 = position.x + direction.x;
        float y4 = position.y + direction.y;

        float den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);
        if (den == 0) {
            return null;
        }

        float t =   ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den;
        float u = - ((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den;

        if (t > 0 && t < 1 && u > 0) {
            PVector pt = new PVector();
            pt.x = x1 + t * (x2 - x1);
            pt.y = y1 + t * (y2 - y1);
            return pt;
        } else {
            return null;
        }
    }
}
