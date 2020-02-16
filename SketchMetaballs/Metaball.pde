class Metaball {

  public PVector position;

  public float strength;

  public float radius;

  public Metaball(PVector thePosition, float theStrength, float theRadius) {
    position = new PVector().set(thePosition);
    strength = theStrength;
    radius = theRadius;
  }
}
