#include <bnb/glsl.frag>

BNB_DECLARE_SAMPLER_2D(0, 1, nail_tex);
BNB_DECLARE_SAMPLER_2D(2, 3, nail_segm);
BNB_IN(0) vec4 var_uv;

void main()
{
	vec4 c = BNB_TEXTURE_2D(BNB_SAMPLER_2D(nail_tex), var_uv.xy);
    float r = BNB_TEXTURE_2D(BNB_SAMPLER_2D(nail_segm), var_uv.zw).x;
    c.a *= r;

    bnb_FragColor = c;
}
