Shader "Unlit/Shader02"
{
    Properties
    {
        _Point("OriginPos",Vector)= (0.5,0.5,0,0)
        _Radius("Radius",float) = 0.5
        _Color("Color",Color) = (1,1,1,1)
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
            fixed2 _Point;
            fixed _Radius;
            fixed4 _Color;
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
                if(distance(i.uv,_Point)<_Radius)
                {
                    col = _Color;
                }
                return col;
            }
            ENDCG
        }
    }
}
