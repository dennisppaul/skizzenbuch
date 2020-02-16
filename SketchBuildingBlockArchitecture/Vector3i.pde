static class Vector3i {

  final int x, y, z;

  Vector3i(int pX, int pY, int pZ) {
    x = pX;
    y = pY;
    z = pZ;
  }

  Vector3i(Vector3i pV) {
    x = pV.x;
    y = pV.y;
    z = pV.z;
  }

  public String toString() {
    return x + ", " + y + ", " + z;
  }

  static Vector3i add(Vector3i v0, Vector3i v1) {
    return new Vector3i(v0.x + v1.x, v0.y + v1.y, v0.z + v1.z);
  }
}