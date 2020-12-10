// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/12/Shader1202"
{
    Properties
    {
    }
    SubShader
    {
        Pass
        {
            ZWrite On ZTest Always Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            struct appdata{
                float4 vertex:POSITION;
                fixed2 uv:TEXCOORD0;
                uint vid:SV_VERTEXID;
            };

            struct v2f{ 
                fixed4 pos:SV_POSITION;
                fixed4 col:TEXCOORD0;
                fixed2 uv:TEXCOORD1;
            };

            sampler2D _CameraDepthTexture;
            uniform float4x4 vcol;
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.col = vcol[v.vid];
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,i.uv));
                fixed3 col = _WorldSpaceCameraPos.xyz+i.col*(depth*_ProjectionParams.w);

                // Float depth = Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,i.uv));
                // fixed3 col = _WorldSpaceCameraPos.xyz+i.col*depth;
                return fixed4(col,1);
            }
            ENDCG
        }
    }
}
