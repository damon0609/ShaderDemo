Shader "Unlit/Shader01"
{
    Properties
    {
        _Width("Width",float) = 0.1
        _LineColor("LineColor",Color) = (1,1,1,1)
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

           float _Width;
           fixed4 _LineColor;
           float _Test;

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
                for(half m = 0.1;m<=1;m+=0.1)
                {
                    half radius = _Width/2;
                    if(abs(m-i.uv.x)<=radius||abs(m-i.uv.y)<=radius)
                    {
                        col =_LineColor;
                    }
                }
                return col;
            }
            ENDCG
        }
    }
}
