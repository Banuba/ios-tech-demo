#include <bnb/glsl.vert>
#include <bnb/decode_int1010102.glsl>
#include<bnb/matrix_operations.glsl>
#define bnb_IDX_OFFSET 0
#ifdef BNB_VK_1
#ifdef gl_VertexID
#undef gl_VertexID
#endif
#ifdef gl_InstanceID
#undef gl_InstanceID
#endif
#define gl_VertexID gl_VertexIndex
#define gl_InstanceID gl_InstanceIndex
#endif

BNB_LAYOUT_LOCATION(3) BNB_IN vec2 attrib_uv;


BNB_OUT(0) vec2 var_uv;
BNB_OUT(1) vec2 var_bg_uv;


void main()
{
	mat3 eye_m = bnb_inverse_trs2d(mat3( 
		right_eye_nn_transform[0].xyz, 
		right_eye_nn_transform[1].xyz, 
		vec3(0.,0.,1.) ) );

	gl_Position = vec4( (vec3(attrib_uv,1.)*eye_m).xy, 0., 1. );
	var_uv = attrib_uv;
	var_bg_uv = gl_Position.xy*0.5 +0.5;
	#ifdef BNB_VK_1
		var_bg_uv.y = 1. - var_bg_uv.y;
	#endif	
}