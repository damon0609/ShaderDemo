Shader "Unlit/CustomShader"
{
    Properties
    {
    }
    SubShader
    {
        Tags {"RenderType"="Opaque"}
        Pass
        {
            ZTest LEqual
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv:TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv:TEXCOORD;
            };

            uniform sampler2D _CustomDepthNormalsTexture;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv= v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //解码后的纹理
                float4 depthNormal = SAMPLE_RAW_DEPTH_TEXTURE(_CustomDepthNormalsTexture,i.uv);
                return DecodeFloatRG(depthNormal.zw);

                // return tex2D(_CustomDepthNormalsTexture,i.uv);
            }
            ENDCG
        }
    }
    Fallback Off
}
