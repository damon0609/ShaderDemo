﻿Shader "Unlit/Shader09"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _MaskSize;
            fixed _MaskFactor;
            fixed2 _Pos;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 scale = float2(_ScreenParams.x/_ScreenParams.y,1);
                fixed4 col = tex2D(_MainTex, i.uv);
                float2 dir = _Pos -i.uv;
                fixed dis = length(dir*scale);
                // float dis = distance(fixed2(0.5,0.5),i.uv*scale);
                // float value =1-step(_MaskSize,dis);
                float value = smoothstep(_MaskSize+_MaskFactor,_MaskSize,dis);
                return col*fixed4(value,value,value,1);
            }
            ENDCG
        }
    }
}
