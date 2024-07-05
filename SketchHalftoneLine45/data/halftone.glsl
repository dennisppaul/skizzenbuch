#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform vec2 resolution;
uniform sampler2D tex0;
uniform float maxLineWidth;
uniform float frequency;

void main() {
  vec2 uv = gl_FragCoord.xy / resolution.xy;
  uv.x = 1.0 - uv.x;
  uv.y = 1.0 - uv.y;
  vec4 color = texture2D(tex0, uv);
  
  float brightness = dot(color.rgb, vec3(0.299, 0.587, 0.114));
  
  // Rotate the coordinates by 45 degrees
  float angle = radians(45);
  vec2 rotatedUV = vec2(
    uv.x * cos(angle) - uv.y * sin(angle),
    uv.x * sin(angle) + uv.y * cos(angle)
  );
  
  // Calculate line width based on brightness
  float lineWidth = mix(maxLineWidth, 0.0, brightness);
  
  // Create lines based on rotated coordinates and frequency
  float line = step(fract(rotatedUV.x * frequency), lineWidth / frequency);
  
  // Determine the color of the current fragment
  vec3 finalColor = mix(vec3(1.0), vec3(0.0), line);
  
  gl_FragColor = vec4(finalColor, 1.0);
}