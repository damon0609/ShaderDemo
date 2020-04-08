Shader "Unlit/Shader03"
{
    Properties
    {
        _Rate("Rate",float) = 1
        _OffsetY("OffsetY",float)=0
        _Width("Width",float) = 0.01
        _Interval("Interval",float) = 0.01
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
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

            fixed _Rate;
            fixed _OffsetY;
            fixed _Width;
            fixed _Interval;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = fixed4(1,1,1,1);
                for(fixed m=0;m<=1;m+=_Interval)
                {
                    fixed x = m;
                    fixed y = _Rate*x+_OffsetY;
                    if(i.uv.x>=x&&i.uv.y>=y&&i.uv.x<x+_Width&&i.uv.y<y+_Width)
                    {
                        col = fixed4(0.1,0.1,0.1,1);
                    }
                }
                return col;
            }
            ENDCG
        }
    }
}
