Shader "Unlit/12/Shader1205"
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
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            Tags {"LightMode"="Deferred"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appIn{
                float4 vertex:POSITION;
                float2 uv:TEXCOORD;
                float3 normal:NORMAL;
            };

            struct appOut{
                float4 vertex:SV_POSITION;//裁切空间下的坐标
                float2 uv:TEXCOORD0;
                float3 worldNormal:TEXCOORD1;
                float3 worldPos:TEXCOORD2;
            };

            struct DeferredOutput{
                float4 gBuffer0:SV_TARGET0;
                float4 gBuffer1:SV_TARGET1;
                float4 gBuffer2:SV_TARGET2;
                float4 gBuffer3:SV_TARGET3;
            };

            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            float4 _Diffuse;
            float4 _Specular;
            float _Gloss;

            appOut vert(appIn i)
            {
                appOut o;
                o.uv = TRANSFORM_TEX(i.uv,_MainTex);
                o.vertex = UnityObjectToClipPos(i.vertex);
                o.worldPos =mul(unity_ObjectToWorld,i.vertex).xyz;
                o.worldNormal=UnityObjectToWorldNormal(i.normal);
                return o;
            };

            DeferredOutput frag(appOut o):SV_TARGET{
                DeferredOutput d;
                float3 color = tex2D(_MainTex,o.uv).rgb;
                d.gBuffer0.rgb = color *_Diffuse.rgb;
                d.gBuffer0.a = 1;
                d.gBuffer1.rgb = _Specular.rgb;
                d.gBuffer1.a = _Gloss/255;
                d.gBuffer2 = fixed4(o.worldNormal*0.5+0.5,1);
                d.gBuffer3 = fixed4(color,1);
                return d;
            }
            
            ENDCG
        }
    }
}
