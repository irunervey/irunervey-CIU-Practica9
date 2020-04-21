
#ifdef GL_ES
precision highp float;
#endif

#define PROCESSING_TEXTURE_SHADER
#define pi 3.14159265

uniform sampler2D texture;
uniform vec2 u_resolution;
uniform float u_time;
uniform bool menu;
uniform vec2 u_mouse;

varying vec4 vertTexCoord;

void main() {
	if(!((gl_FragCoord.x > 18 && gl_FragCoord.x < 220)&&(gl_FragCoord.y < u_resolution.y-20 && gl_FragCoord.y > u_resolution.y-140)) && !((gl_FragCoord.x > 18 && gl_FragCoord.x < 120)&&(gl_FragCoord.y < 30 && gl_FragCoord.y > 10)) || !menu&& !((gl_FragCoord.x > 18 && gl_FragCoord.x < 120)&&(gl_FragCoord.y < 30 && gl_FragCoord.y > 10))){
		
		vec2 uv =gl_FragCoord.xy/u_resolution;
		vec2 p = vec2(0.5)-uv;
		vec2 mouse=u_mouse/u_resolution;
	
		float rad = length(p)*1.;
		float ang = atan(p.x,p.y);
		float e = abs(sin(pi+u_time+(sin(ang*900.))));
		gl_FragColor=vec4(e*0.4,mouse.x*0.2,mouse.y,1.0)*texture2D(texture , vertTexCoord.st + vec2(0.0 , 0.0));
	} else{
		gl_FragColor=texture2D(texture , vertTexCoord.st + vec2(0.0 , 0.0)) ;
	}
}