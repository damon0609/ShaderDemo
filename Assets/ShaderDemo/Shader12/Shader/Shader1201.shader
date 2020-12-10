// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/12/Shader1201"
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
            struct v2f{ 
                fixed4 pos:SV_POSITION;
                fixed2 uv:TEXCOORD0;
                fixed2 uvPos:TEXCOORD1;
            };
            
            sampler2D _CameraDepthTexture;
            uniform float4x4 _CameraProjectionToWorld;
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                //这里得出的是ndc.z的值
                float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,i.uv);

                //这里的ndc坐标也需要琢磨 -- ndc坐标还需要进行转换才能成为真正的屏幕坐标
                float4 worldPos =mul(_CameraProjectionToWorld,float4(i.uv*2-1,depth,1));
                //这里的推导过程需要多看
                worldPos /=worldPos.w;
                return worldPos;
            }
            ENDCG
        }
    }
}
