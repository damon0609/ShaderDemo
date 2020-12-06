// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/10/Shader1012"
{
    Properties
    {
    }
    SubShader
    {
        Pass
        {
            ZWrite Off ZTest Always Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            struct v2f{ 
                fixed4 pos:SV_POSITION;
                fixed2 uv:TEXCOORD0;
            };
            sampler2D _CameraDepthNormalsTexture;
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_CameraDepthNormalsTexture,i.uv);//未解码


                //解码
                // float4 depthNormal = SAMPLE_RAW_DEPTH_TEXTURE(_CameraDepthNormalsTexture,i.uv);
                //zw记录的是法线信息，xy记录的是深度信息
                //有数字信息转换成纹理信息RG代表的是法线信息
                // return DecodeFloatRG(depthNormal.zw);
            }
            ENDCG
        }
    }
}
