package de.hfkbremen.mesh;

import processing.core.PVector;

public class Triangle {

    public final PVector a;
    public final PVector b;
    public final PVector c;

    public Triangle(PVector pA, PVector pB, PVector pC) {
        this();
        a.set(pA);
        b.set(pB);
        c.set(pC);
    }

    public Triangle() {
        a = new PVector();
        b = new PVector();
        c = new PVector();
    }
}
