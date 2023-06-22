#version 330 core

uniform sampler2D point_texture;

out vec4 color;

void main() {
  color = texture(point_texture, gl_PointCoord);
}
