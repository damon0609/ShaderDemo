Shader "Unlit/Shader05"
{
    Properties
    {
        _Center("Center",Vector) = (0.5,0.5,0,0)
        _Color("Color",Color) = (0.5,0.5,0.5,1)
        _Width("Width",float)=0.5
        _Height("Height",float) = 0.5
        _Radius("Raduis",float) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
                fixed4 col:COLOR;
            };

            fixed4 _Color;
            fixed _Height;
            fixed _Width;
            fixed4 _Center;
            fixed _Radius;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.col = fixed4(1,1,1,1);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed2 cirLeftTop = fixed2(_Center.x-_Width/2+_Radius,_Center.y+_Height/2-_Radius);
                fixed2 cirLeftBottom = fixed2(_Center.x-_Width/2+_Radius,_Center.y-_Height/2+_Radius);
                
                fixed2 cirRightTop = fixed2(_Center.x+_Width/2-_Radius,_Center.y+_Height/2-_Radius);
                fixed2 cirRightBottom = fixed2(_Center.x+_Width/2-_Radius,_Center.y-_Height/2+_Radius);

                if(distance(i.uv,cirLeftTop)<=_Radius||distance(i.uv,cirLeftBottom)<=_Radius|| distance(i.uv,cirRightTop)<=_Radius || distance(i.uv,cirRightBottom)<=_Radius )
                {
                    i.col = _Color;
                }

                if(abs(_Center.x-i.uv.x)<=_Width/2&&abs(_Center.y-i.uv.y)<=_Height/2)
                {
                    i.col =_Color;
                }

                return i.col;
            }
            ENDCG
        }
    }
}
