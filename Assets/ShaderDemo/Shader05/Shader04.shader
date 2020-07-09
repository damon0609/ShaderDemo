Shader "Unlit/Shader04"
{
    Properties
    {
        _Center("Center",Vector) = (0.5,0.5,0,0)
        _Color("Color",Color) = (0.5,0.5,0.5,1)
        _Width("Width",float)=0.5
        _Height("Height",float) = 0.5
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

            fixed4 _Color;
            fixed _Height;
            fixed _Width;
            fixed4 _Center;

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
                if(abs(_Center.x-i.uv.x)<=_Width/2&&abs(_Center.y-i.uv.y)<=_Height/2)
                {
                    col =_Color;
                }
                return col;
            }
            ENDCG
        }
    }
}
