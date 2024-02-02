#include <bnb/glsl.vert>

BNB_LAYOUT_LOCATION(0) BNB_IN vec3 attrib_pos;
BNB_LAYOUT_LOCATION(1) BNB_IN vec2 attrib_uv;

BNB_OUT(0) vec4 var_uv;

#define CYL_STRIP_SIZE 34
#define V_BORDER 0.181231


void main()
{
    vec4 v = vec4( attrib_pos.xyz, 1. );
    mat2 ori = mat2(bnb_camera_orientation.xy, bnb_camera_orientation.zw);

    gl_Position = bnb_MVP * v;

    float i = attrib_uv.x;
    float j = attrib_uv.y;

    vec2 ts = bnb_tex_nails5_tex_st.xy;

    var_uv.xy = vec2( 1.-i, (1.-j)*(1.-V_BORDER*2.) + V_BORDER );   // TODO: <<<< Check this texture inverse
    var_uv.zw = (ori * (gl_Position.yx/gl_Position.w))*0.5+0.5; // TODO use correct transformation here

    var_uv.y = ((var_uv.y*2.-1.)*ts.x)*0.5+0.5;
    var_uv.xy = ((var_uv.xy*2.-1.)/ts.y)*0.5+0.5;
}