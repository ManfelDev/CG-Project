void MainLightInformation_float(out float3 Direction, out float3 Color)
{
    #if SHADERGRAPH_PREVIEW
        Direction = float3(0.5, 0.5, 0);
        Color = 1;
    #else
        Light mainLight = GetMainLight();
        Direction = mainLight.direction;
        Color = mainLight.color;
    #endif
}

void MainLightInformation_half(out half3 Direction, out half3 Color)
{
    #if SHADERGRAPH_PREVIEW
        Direction = half3(0.5, 0.5, 0);
        Color = 1;
    #else
        Light mainLight = GetMainLight();
        Direction = mainLight.direction;
        Color = mainLight.color;
    #endif
}