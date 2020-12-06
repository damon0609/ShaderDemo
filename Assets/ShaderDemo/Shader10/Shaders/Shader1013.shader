// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/10/Shader1013"
{
    Properties
    {
        _MainTex("MainTex",2D) = "white"{}
        _Color("TargetColor",Color)=(1,1,1,1)
        _Threshold("Threshold",Range(0,1))=0.1
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
            uniform float3 worldPos;
            sampler2D _MainTex;
            sampler2D _MainTex_ST;
            fixed4 _Color;
            fixed _Threshold;
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;

                float3 localPos = mul(unity_WorldToObject,worldPos);
                float2x2 uvMatrix = float2x2(1,0,0,1);
                o.uvPos =  mul(uvMatrix,localPos).xy;
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float2 dir = i.uv-fixed2(0.5,0.5) - i.uvPos;
                if(length(dir)<_Threshold)
                {
                    return _Color;
                }
                fixed4 originColor = tex2D(_MainTex,i.uv);
                return originColor;
            }
            ENDCG
        }
    }
}
