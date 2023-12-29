#if defined(SHADERGRAPH_PREVIEW)
#else
    #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
#endif

void MainLightInformation_float(float3 WorldPos, out float3 Direction, out float3 Color, out float DistanceAttenuation, out float ShadowAttenuation)
{
    #if SHADERGRAPH_PREVIEW
        Direction = float3(0.5, 0.5, 0);
        Color = 1;
        DistanceAttenuation = 1;
        ShadowAttenuation = 1;
    #else
        #if SHADOWS_SCREEN
            float4 clipPos = TransformWorldToHClip(WorldPos);
            float4 shadowCoord = ComputeScreenPos(clipPos);
        #else
            float4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
    #endif

    Light mainLight = GetMainLight(shadowCoord);
    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAttenuation = mainLight.distanceAttenuation;

    #if !defined(_MAIN_LIGHT_SHADOWS) || defined(_RECEIVE_SHADOWS_OFF)
        ShadowAttenuation = 1.0;
    #endif

    #if SHADOWS_SCREEN
        ShadowAttenuation = SampleScreenSpaceShadowmap(shadowCoord);
    #else
        ShadowSamplingData shadowSamplingData = GetMainLightShadowSamplingData();
        float shadowStrength = GetMainLightShadowStrength();
        ShadowAttenuation = SampleShadowmap(shadowCoord, TEXTURE2D_ARGS(_MainLightShadowmapTexture, sampler_MainLightShadowmapTexture), shadowSamplingData, shadowStrength, false);
    #endif

    #endif
}

void MainLightInformation_half(float3 WorldPos, out half3 Direction, out half3 Color, out half DistanceAttenuation, out half ShadowAttenuation)
{
    #if SHADERGRAPH_PREVIEW
        Direction = half3(0.5, 0.5, 0);
        Color = 1;
        DistanceAttenuation = 1;
        ShadowAttenuation = 1;
    #else
        #if SHADOWS_SCREEN
            half4 clipPos = TransformWorldToHClip(WorldPos);
            half4 shadowCoord = ComputeScreenPos(clipPos);
        #else
            half4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
    #endif

    Light mainLight = GetMainLight(shadowCoord);
    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAttenuation = mainLight.distanceAttenuation;

    #if !defined(_MAIN_LIGHT_SHADOWS) || defined(_RECEIVE_SHADOWS_OFF)
        ShadowAttenuation = 1.0h;
    #endif

    #if SHADOWS_SCREEN
        ShadowAttenuation = SampleScreenSpaceShadowmap(shadowCoord);
    #else
        ShadowSamplingData shadowSamplingData = GetMainLightShadowSamplingData();
        half shadowStrength = GetMainLightShadowStrength();
        ShadowAttenuation = SampleShadowmap(shadowCoord, TEXTURE2D_ARGS(_MainLightShadowmapTexture, sampler_MainLightShadowmapTexture), shadowSamplingData, shadowStrength, false);
    #endif

    #endif
}

void DirectSpecular_float (float3 Specular, float Smoothness, float3 Direction, float3 Color, float3 WorldNormal, float3 WorldView, out float3 Out)
{
    #if SHADERGRAPH_PREVIEW
        Out = 0;
    #else
        Smoothness = exp2(10 * Smoothness + 1);
        WorldNormal = normalize(WorldNormal);
        WorldView= SafeNormalize(WorldView);
        Out = LightingSpecular(Color, Direction, WorldNormal, WorldView, float4(Specular, 0), Smoothness);
    #endif
}

void DirectSpecular_half (half3 Specular, half Smoothness, half3 Direction, half3 Color, half3 WorldNormal, half3 WorldView, out half3 Out)
{
    #if SHADERGRAPH_PREVIEW
        Out = 0;
    #else
        Smoothness = exp2(10 * Smoothness + 1);
        WorldNormal = normalize(WorldNormal);
        WorldView= SafeNormalize(WorldView);
        Out = LightingSpecular(Color, Direction, WorldNormal, WorldView, half4(Specular, 0), Smoothness);
    #endif
}