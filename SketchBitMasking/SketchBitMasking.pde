void setup() {
    int bL = 0b00001111; //  LOW mask (0x0F)
    int bH = 0b11110000; // HIGH mask (0xF0)
    int b  = 0b00110101;
    println("MASK  LOW: " + bL);
    println("MASK HIGH: " + bH);
    println("BYTE: " + ( b ));  // value 
    println("HIGH: " + ( b & bH )); // only HIGH part
    println(" LOW: " + ( b & bL )); // only  LOW part
    int bHL = b & bH;
    int bLH = b & bL;
    println(" HTL: " + ( bHL >> 4 )); // shift HIGH to LOW part
    println(" LTH: " + ( bLH << 4 )); // shift LOW to HIGH part

    println(isBitSet(b, 0));
    println(isBitSet(b, 7));
    printByte(b);
}

boolean isBitSet(int b, int p) {
    int b2 = 1 << p;
    return (b & b2) != 0;
}

void printByte(int b) {
    println(toLiteral(b));
}

String toLiteral(int b) {
    return String.format("%8s", Integer.toBinaryString(b & 0xFF)).replace(' ', '0');
}
