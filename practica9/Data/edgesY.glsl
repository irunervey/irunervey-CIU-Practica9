#ifdef GL_ES
precision mediump f loa t ;
precision mediump int ;
#endif
#define PROCESSING_TEXTURE_SHADER
uniform sampler2D texture ;
uniform vec2 texOffset ;
varying vec4 vertColor ;
uniform vec2 resolution;
uniform bool menu;
varying vec4 vertTexCoord ;
void main( void ) {

	vec2 uv=gl_FragCoord.xy / resolution.xy;
	if(!((gl_FragCoord.x > 18 && gl_FragCoord.x < 220)&&(gl_FragCoord.y < resolution.y-20 && gl_FragCoord.y > resolution.y-140)) && !((gl_FragCoord.x > 18 && gl_FragCoord.x < 120)&&(gl_FragCoord.y < 30 && gl_FragCoord.y > 10)) || !menu&& !((gl_FragCoord.x > 18 && gl_FragCoord.x < 120)&&(gl_FragCoord.y < 30 && gl_FragCoord.y > 10))){
	
	vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s , -texOffset.t ) ;
	vec2 tc2 = vertTexCoord.st + vec2(+ texOffset.s , -texOffset.t ) ;
	vec2 tc3 = vertTexCoord.st + vec2(-texOffset.s , 0.0) ;
	vec2 tc5 = vertTexCoord.st + vec2(+ texOffset.s , 0.0) ;
	vec2 tc6 = vertTexCoord.st + vec2(-texOffset.s , +texOffset.t ) ;
	vec2 tc8 = vertTexCoord.st + vec2(+ texOffset.s , +texOffset.t ) ;
	
	vec4 col0 = texture2D( texture , tc0 ) ;
	vec4 col2 = texture2D( texture , tc2 ) ;
	vec4 col3 = texture2D( texture , tc3 ) ;
	vec4 col5 = texture2D( texture , tc5 ) ;
	vec4 col6 = texture2D( texture , tc6 ) ;
	vec4 col8 = texture2D( texture , tc8 ) ;
	vec4 sum = ( -col0 + col2 - col3*2. + col5*2. - col6 + col8)/8. ;
	gl_FragColor = vec4 (sum.rgb , 1.0) * vertColor ;
	
	} else{
		gl_FragColor=texture2D( texture , vertTexCoord.st + vec2( 0.0 , 0.0) ) ;
	}
}