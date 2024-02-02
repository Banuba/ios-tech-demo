#include <bnb/glsl.frag>
#include "shaders/soften.glsl"
#include "shaders/skin_color.glsl"

BNB_IN(0) vec4 var_uv;



BNB_DECLARE_SAMPLER_2D(2, 3, glfx_BACKGROUND);

BNB_DECLARE_SAMPLER_2D(0, 1, glfx_SKIN_MASK);

#define YUV2RGB_RED_CrV 1.402
#define YUV2RGB_GREEN_CbU 0.3441
#define YUV2RGB_GREEN_CrV 0.7141
#define YUV2RGB_BLUE_CbU 1.772

vec4 rgba2yuva (vec4 rgba)
{
	vec4 yuva = vec4(0.);

	yuva.x = rgba.r * 0.299 + rgba.g * 0.587 + rgba.b * 0.114;
	yuva.y = rgba.r * -0.169 + rgba.g * -0.331 + rgba.b * 0.5 + 0.5;
	yuva.z = rgba.r * 0.5 + rgba.g * -0.419 + rgba.b * -0.081 + 0.5;
	yuva.w = rgba.a;

	return yuva;
}

void main()
{
    float mask = BNB_TEXTURE_2D(BNB_SAMPLER_2D(glfx_SKIN_MASK), var_uv.zw).x;
    vec4 softened = soften(BNB_PASS_SAMPLER_ARGUMENT(glfx_BACKGROUND), var_uv.xy, js_soften.x);
    vec4 colored = skin_color(softened, BNB_PASS_SAMPLER_ARGUMENT(glfx_SKIN_MASK), var_uv.zw, js_color);

    bnb_FragColor = vec4(colored.rgb, mask);
}
