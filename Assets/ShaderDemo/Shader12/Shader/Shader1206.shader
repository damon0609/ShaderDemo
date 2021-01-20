Shader "Unlit/12/Shader1206"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Diffuse("Diffuse",Color)=(1,1,1,1)
        _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(8,255))=8
    }
    SubShader
    {
        ZWrite Off
        Blend One One

        Pass
        {
            CGPROGRAM
            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag

            #pragma mutil_compile_lightpass
            #pragma exclude_renderers_normal

            #include "UnityCG.cginc"
            #include "UnityDeferredLibrary.cginc"
            #include "UnityGBuffer.cginc"

            sampler2D _CameraGBufferTexture0;
            sampler2D _CameraGBufferTexture1;
            sampler2D _CameraGBufferTexture2;
            sampler2D _CameraGBufferTexture3;


            struct appIn{
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };

            struct appOut{
                float4 vertex:SV_POSITION;//裁切空间下的坐标
                float2 uv:TEXCOORD0;
                float3 ray:TEXCOORD1;
            };

            
            

            
            ENDCG
        }
    }
}
