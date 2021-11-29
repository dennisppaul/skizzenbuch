PShader mWhiteNoiseShader;

void setup() {
    size(1024, 768, P3D);
    noStroke();
    mWhiteNoiseShader = loadShader("WhiteNoiseFrag.glsl");
    mWhiteNoiseShader.set("u_resolution", 0.1, 0.1);
}

void draw() {
    mWhiteNoiseShader.set("u_resolution", random(1, 1000.0), random(1, 1000.0));
    shader(mWhiteNoiseShader);
    rect(0, 0, width, height);
}

/* WhiteNoiseFrag.glsl:
 
 uniform vec2 u_resolution;
 
 float random (vec2 st) {
 return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
 }
 
 void main() {
 vec2 st = gl_FragCoord.xy/u_resolution.xy;
 float rnd = random(st);
 gl_FragColor = vec4(vec3(rnd),1.0);
 }
 
 */
 
