#include <bnb/glsl.frag>
#include <bnb/lut.glsl>

#define TEETH_WHITENING
#define teethWhiteningCoeff 1.0
#define EYES_WHITENING
#define eyesWhiteningCoeff 0.5
#define EYES_HIGHLIGHT
#define SOFT_LIGHT_LAYER
#define NORMAL_LAYER
#define SOFT_SKIN
#define skinSoftIntensity 0.7
#define SHARPEN_TEETH
#define teethSharpenIntensity 0.2
#define SHARPEN_EYES
#define eyesSharpenIntensity 0.3
#define PSI 0.1



BNB_IN(0) vec3 maskColor;
BNB_IN(1) vec4 var_uv_bg_uv;


BNB_DECLARE_SAMPLER_2D(10, 11, glfx_BACKGROUND);

BNB_DECLARE_SAMPLER_LUT(2, 3, lookupTexEyes);

BNB_DECLARE_SAMPLER_LUT(0, 1, lookupTexTeeth);

#if defined(EYES_HIGHLIGHT)

BNB_DECLARE_SAMPLER_2D(8, 9, tex_highlight);
#endif
#ifdef SOFT_LIGHT_LAYER

BNB_DECLARE_SAMPLER_2D(4, 5, tex_softLight);
#endif
#ifdef NORMAL_LAYER

BNB_DECLARE_SAMPLER_2D(6, 7, tex_normalMakeup);
#endif

#ifdef GLFX_OCCLUSION
BNB_IN(2) vec2 glfx_OCCLUSION_UV;
#endif

#define textureLookup BNB_TEXTURE_LUT

vec3 whitening(vec3 originalColor, float factor, BNB_DECLARE_SAMPLER_LUT_ARGUMENT(lookup)) {
    vec3 color = textureLookup(originalColor, BNB_PASS_SAMPLER_ARGUMENT(lookup));
    return mix(originalColor, color, factor);
}

vec3 sharpen(vec3 originalColor, float factor) {
    const float dx = 1.0 / 960.0;
    const float dy = 1.0 / 1280.0;
    
    vec3 total = 5.0 * originalColor
    - BNB_TEXTURE_2D(BNB_SAMPLER_2D(glfx_BACKGROUND), vec2(var_uv_bg_uv.z-dx, var_uv_bg_uv.w-dy)).xyz
    - BNB_TEXTURE_2D(BNB_SAMPLER_2D(glfx_BACKGROUND), vec2(var_uv_bg_uv.z+dx, var_uv_bg_uv.w-dy)).xyz
    - BNB_TEXTURE_2D(BNB_SAMPLER_2D(glfx_BACKGROUND), vec2(var_uv_bg_uv.z-dx, var_uv_bg_uv.w+dy)).xyz
    - BNB_TEXTURE_2D(BNB_SAMPLER_2D(glfx_BACKGROUND), vec2(var_uv_bg_uv.z+dx, var_uv_bg_uv.w+dy)).xyz;

    vec3 result = mix(originalColor, total, factor);
    return clamp(result, 0.0, 1.0);
}

vec3 softSkin(vec3 originalColor, float factor) {
    vec3 screenColor = originalColor;

    const float dx = 4.5 / 960.0;
    const float dy = 4.5 / 1280.0;
    
    vec3 nextColor0 = BNB_TEXTURE_2D(BNB_SAMPLER_2D(glfx_BACKGROUND), vec2(var_uv_bg_uv.z-dx, var_uv_bg_uv.w-dy)).xyz;
    vec3 nextColor1 = BNB_TEXTURE_2D(BNB_SAMPLER_2D(glfx_BACKGROUND), vec2(var_uv_bg_uv.z+dx, var_uv_bg_uv.w-dy)).xyz;
    vec3 nextColor2 = BNB_TEXTURE_2D(BNB_SAMPLER_2D(glfx_BACKGROUND), vec2(var_uv_bg_uv.z-dx, var_uv_bg_uv.w+dy)).xyz;
    vec3 nextColor3 = BNB_TEXTURE_2D(BNB_SAMPLER_2D(glfx_BACKGROUND), vec2(var_uv_bg_uv.z+dx, var_uv_bg_uv.w+dy)).xyz;
    
    float intensity = screenColor.g;
    vec4 nextIntensity = vec4(nextColor0.g, nextColor1.g, nextColor2.g, nextColor3.g);
    vec4 lg = nextIntensity - intensity;
    
    vec4 curr = max(0.367 - abs(lg * (0.367*0.6/(1.41*PSI))), 0.);
    
    float summ = 1.0 + curr.x + curr.y + curr.z + curr.w;
    screenColor += (nextColor0 * curr.x + nextColor1 * curr.y + nextColor2 * curr.z + nextColor3 * curr.w);
    screenColor = screenColor * (factor / summ);
    
    screenColor = originalColor*(1.-factor) + screenColor;
    return screenColor;
}

float softlight_blend_1ch(float a, float b)
{
   return ((1.-2.*b)*a+2.*b)*a;
}

vec3 blendSoftLight(vec3 base, vec3 blend) {
    return vec3(softlight_blend_1ch(base.r,blend.r),softlight_blend_1ch(base.g,blend.g),softlight_blend_1ch(base.b,blend.b));
}

void main()
{
#ifdef GLFX_OCCLUSION
    float oclusion = BNB_TEXTURE_2D(BNB_SAMPLER_2D(glfx_OCCLUSION), glfx_OCCLUSION_UV).x;

    if (oclusion <= 0.0001)
        discard;
#endif

    vec3 res = BNB_TEXTURE_2D(BNB_SAMPLER_2D(glfx_BACKGROUND), var_uv_bg_uv.zw).xyz;
    
#ifdef SOFT_SKIN
    res = softSkin(res, maskColor.r * skinSoftIntensity);
#endif
    
#if defined(TEETH_WHITENING) || defined(SHARPEN_TEETH)
    if( maskColor.g > 1./255. )
    {
#ifdef SHARPEN_TEETH
        float sharp_factor = maskColor.g * teethSharpenIntensity;
        res = sharpen(res, sharp_factor);
#endif
    
#if defined(TEETH_WHITENING)
        float teeth_factor = maskColor.g;
        res = whitening(res, teeth_factor, BNB_PASS_SAMPLER_ARGUMENT(lookupTexTeeth));
#endif
    }
#endif
    
#ifdef SHARPEN_EYES
    res = sharpen(res, maskColor.b * eyesSharpenIntensity);
#endif
    
#if defined(EYES_WHITENING)
    res = whitening(res, maskColor.b * eyesWhiteningCoeff, BNB_PASS_SAMPLER_ARGUMENT(lookupTexEyes));
#endif
    
#if defined(EYES_HIGHLIGHT)
    res = res + BNB_TEXTURE_2D(BNB_SAMPLER_2D(tex_highlight), var_uv_bg_uv.xy ).xyz;
#endif

   vec2 uvh = vec2(abs(2.0 * (var_uv_bg_uv.x - 0.5)),var_uv_bg_uv.y);

#ifdef SOFT_LIGHT_LAYER
    res.xyz = blendSoftLight( res.xyz, BNB_TEXTURE_2D(BNB_SAMPLER_2D(tex_softLight), uvh ).xyz );
#endif

#ifdef NORMAL_LAYER
    vec4 makeup2 = BNB_TEXTURE_2D(BNB_SAMPLER_2D(tex_normalMakeup), var_uv_bg_uv.xy );
    res.xyz = mix( res.xyz, makeup2.xyz, makeup2.w );
#endif

    bnb_FragColor = vec4(res,1.);

#ifdef GLFX_OCCLUSION
    bnb_FragColor.a = oclusion;
#endif
}