// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/10/Shader1009"
{
    Properties
    {
    }
    SubShader
    {
        Tags {"Queue"="Geometry"}
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
                fixed2 uv:TEXCOORD;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed2 uv:TEXCOORD;
            };

            sampler2D _CameraDepthTexture;
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,i.uv);
                float linearD = Linear01Depth(d)*10;
                return fixed4(linearD,linearD,linearD,1);
            }
            ENDCG
        }
    }
}
