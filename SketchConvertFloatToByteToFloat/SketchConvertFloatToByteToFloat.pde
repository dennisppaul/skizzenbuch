import java.nio.ByteBuffer;

void setup() {
    println(byteToFloat32(new byte[]{64, 73, 6, 37}));
    printArray(float32ToByte(3.141f));
}

float byteToFloat32(byte[] b) {
    return ByteBuffer.wrap(b).getFloat();
}


byte[] float32ToByte(float f) {
    return ByteBuffer.allocate(4).putFloat(f).array();
}
