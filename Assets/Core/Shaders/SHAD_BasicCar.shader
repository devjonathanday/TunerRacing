Shader "Cars/Basic"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Base Paint Texture", 2D) = "white" {}
        _AccentTex ("Accent Texture", 2D) = "white" {}
        _TextureFilter ("Texture Filter", 2D) = "white" {}
        _Glossiness ("Gloss Map", 2D) = "white" {}
        _Metallic ("Metallic", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _AccentTex;
        sampler2D _TextureFilter;
        sampler2D _Glossiness;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_AccentTex;
            float2 uv_TextureFilter;
            float2 uv_Glossiness;
        };

        fixed4 _Color;
        fixed4 _Metallic;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Base paint texture is multiplied by paint color
            // Gloss and Metallic use R channel from 0-1 range
            fixed4 paint = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed4 accent = tex2D (_AccentTex, IN.uv_AccentTex);
            fixed4 filter = tex2D (_TextureFilter, IN.uv_TextureFilter);
            fixed4 gloss = tex2D (_Glossiness, IN.uv_Glossiness);

            o.Albedo = paint.rgb + accent.rgb;
            o.Albedo = (paint.rgb * step(0.5f, filter.r)) + (accent.rgb * step(filter.r, 0.5f));
            // Metallic and smoothness come from slider variables
            o.Smoothness = gloss.r;
            o.Metallic = _Metallic;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
