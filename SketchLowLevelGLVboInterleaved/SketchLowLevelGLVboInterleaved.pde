// Draws a triangle using low-level OpenGL calls.

import java.nio.*;

PImage mImage;
PShader sh;
float[] attribs;
FloatBuffer attribBuffer;
int attribVboId;

final static int VERT_CMP_COUNT = 4; // vertex component count (x, y, z, w) -> 4
final static int TEXCOORD_CMP_COUNT = 4; // texcoord component count (u, v, w, ) -> 2
final static int CLR_CMP_COUNT = 4;  // color component count (r, g, b, a) -> 4

public void setup() {
  size(640, 360, P3D);

  mImage = loadImage("button_b.png");
  sh = loadShader("frag.glsl", "vert.glsl");
  
  attribs = new float[( VERT_CMP_COUNT + TEXCOORD_CMP_COUNT + CLR_CMP_COUNT ) * 3];
  attribBuffer = allocateDirectFloatBuffer(attribs.length);

  PGL pgl = beginPGL();

  IntBuffer intBuffer = IntBuffer.allocate(1);
  pgl.genBuffers(1, intBuffer);

  attribVboId = intBuffer.get(0);

  endPGL();
}

public void draw() {

  PGL pgl = beginPGL();

  background(0);

  // The geometric transformations will be automatically passed
  // to the shader.
  rotate(frameCount * 0.01f, width, height, 0);

  updateGeometry();
  sh.bind();

  // get "vertex" attribute location in the shader
  final int vertLoc = pgl.getAttribLocation(sh.glProgram, "vertex");
  // enable array for "vertex" attribute
  pgl.enableVertexAttribArray(vertLoc);

  // get "vertex" attribute location in the shader
  final int texcoordLoc = pgl.getAttribLocation(sh.glProgram, "texCoord");
  // enable array for "texCoord" attribute
  pgl.enableVertexAttribArray(texcoordLoc);

  // get "color" attribute location in the shader
  final int colorLoc = pgl.getAttribLocation(sh.glProgram, "color");
  // enable array for "color" attribute
  pgl.enableVertexAttribArray(colorLoc);

  final int stride       = (VERT_CMP_COUNT + TEXCOORD_CMP_COUNT + CLR_CMP_COUNT) * Float.BYTES;
  final int vertexOffset =                   0 * Float.BYTES;
  final int texcoordOffset  =                VERT_CMP_COUNT * Float.BYTES;
  final int colorOffset  =                   (VERT_CMP_COUNT + TEXCOORD_CMP_COUNT) * Float.BYTES;

  // bind VBO
  pgl.bindBuffer(PGL.ARRAY_BUFFER, attribVboId);
  // fill VBO with data
  pgl.bufferData(PGL.ARRAY_BUFFER, Float.BYTES * attribs.length, attribBuffer, PGL.DYNAMIC_DRAW);
  // associate currently bound VBO with "vertex" shader attribute
  pgl.vertexAttribPointer(vertLoc, VERT_CMP_COUNT, PGL.FLOAT, false, stride, vertexOffset);
  // associate currently bound VBO with "texCoord" shader attribute
  pgl.vertexAttribPointer(texcoordLoc, TEXCOORD_CMP_COUNT, PGL.FLOAT, false, stride, texcoordOffset);
  // associate currently bound VBO with "color" shader attribute
  pgl.vertexAttribPointer(colorLoc, CLR_CMP_COUNT, PGL.FLOAT, false, stride, colorOffset);
  // unbind VBO
  pgl.bindBuffer(PGL.ARRAY_BUFFER, 0);

  sh.set("tex0", mImage);
  texture(mImage);
  
  pgl.drawArrays(PGL.TRIANGLES, 0, 3);

  // disable arrays for attributes before unbinding the shader
  pgl.disableVertexAttribArray(vertLoc);
  pgl.disableVertexAttribArray(texcoordLoc);
  pgl.disableVertexAttribArray(colorLoc);

  sh.unbind();

  endPGL();
}

void updateGeometry() {
  int i=0;
  // Vertex 1
  attribs[i++] = 0;
  attribs[i++] = 0;
  attribs[i++] = 0;
  attribs[i++] = 1;

  // TexCoord 1
  attribs[i++] = 0;
  attribs[i++] = 0;
  attribs[i++] = 1;
  attribs[i++] = 1;

  // Color 1
  attribs[i++] = 1;
  attribs[i++] = 0;
  attribs[i++] = 0;
  attribs[i++] = 1;

  // Vertex 2
  attribs[i++] = width/2;
  attribs[i++] = 0;
  attribs[i++] = 0;
  attribs[i++] = 1;

  // TexCoord 2
  attribs[i++] = mImage.width;
  attribs[i++] = 0;
  attribs[i++] = 1;
  attribs[i++] = 1;

  // Color 2
  attribs[i++] = 0;
  attribs[i++] = 1;
  attribs[i++] = 0;
  attribs[i++] = 1;

  // Vertex 3
  attribs[i++] = width/2;
  attribs[i++] = height/2;
  attribs[i++] = 0;
  attribs[i++] = 1;

  // TexCoord 3
  attribs[i++] = mImage.width;
  attribs[i++] = mImage.height;
  attribs[i++] = 1;
  attribs[i++] = 1;

  // Color 3
  attribs[i++] = 0;
  attribs[i++] = 0;
  attribs[i++] = 1;
  attribs[i++] = 1;

  attribBuffer.rewind();
  attribBuffer.put(attribs);
  attribBuffer.rewind();
}

FloatBuffer allocateDirectFloatBuffer(int n) {
  return ByteBuffer.allocateDirect(n * Float.BYTES).order(ByteOrder.nativeOrder()).asFloatBuffer();
}