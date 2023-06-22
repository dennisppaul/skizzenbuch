#version 330 core

uniform mat4 transform;
uniform float height_near_plane;
uniform float point_size;
layout (location = 0) in vec4 point_position;

void main() {
  gl_Position = transform * vec4(point_position.xyz, 1.0);
  gl_PointSize = (height_near_plane * point_size) / gl_Position.w;
}
