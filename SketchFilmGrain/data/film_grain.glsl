#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform float time;       
uniform float strength;       
uniform int blend_mode;       

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(void) {
    vec2 uv = vertTexCoord.st;
    vec4 color = texture(texture, uv);
    
    float x = (uv.x + 4.0 ) * (uv.y + 4.0 ) * (time * 10.0);
	vec4 grain = vec4(mod((mod(x, 13.0) + 1.0) * (mod(x, 123.0) + 1.0), 0.01)-0.005) * strength;
        
    if(blend_mode == 0) {
    	grain = 1.0 - grain;
		gl_FragColor = color * grain;
    } else if (blend_mode == 1) {
 		gl_FragColor = color + grain;
    } else if (blend_mode == 2) {
		gl_FragColor = color - grain;
    }
}
