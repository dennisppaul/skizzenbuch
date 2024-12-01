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

  // Flip the coordinates if necessary
  uv.x = 1.0 - uv.x;
  uv.y = 1.0 - uv.y;

  vec4 color = texture2D(tex0, uv);
  float brightness = dot(color.rgb, vec3(0.299, 0.587, 0.114));
  
  // Calculate the aspect ratio
  float aspectRatio = resolution.x / resolution.y;

  // Rotate the coordinates by 45 degrees accounting for the aspect ratio
  float angle = radians(45.0);
  vec2 centeredUV = uv - 0.5; // Center the coordinates around (0.5, 0.5)
  vec2 scaledUV = vec2(centeredUV.x * aspectRatio, centeredUV.y); // Scale the x coordinate by the aspect ratio
  vec2 rotatedUV = vec2(
    scaledUV.x * cos(angle) - scaledUV.y * sin(angle),
    scaledUV.x * sin(angle) + scaledUV.y * cos(angle)
  );
  rotatedUV = vec2(rotatedUV.x / aspectRatio, rotatedUV.y); // Scale back the x coordinate
  rotatedUV += 0.5; // Translate back to original coordinate system

  // Calculate line width based on brightness
  float lineWidth = mix(maxLineWidth, 0.0, brightness);
  
  // Create lines based on rotated coordinates and frequency
  float line = step(fract(rotatedUV.x * frequency), lineWidth / frequency);
  
  // Determine the color of the current fragment
  vec3 finalColor = mix(vec3(1.0), vec3(0.0), line);
  
  gl_FragColor = vec4(finalColor, 1.0);
}