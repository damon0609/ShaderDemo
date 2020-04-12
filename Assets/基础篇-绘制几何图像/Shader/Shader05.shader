Shader "Unlit/Shader05"
{
    Properties
    {
        _Center("Center",Vector) = (0.5,0.5,0,0)
        _Color("Color",Color) = (0.5,0.5,0.5,1)
        _Width("Width",Range(0,0.5)) = 0.5
        _Height("Height",Range(0,0.5)) = 0.5
        _Radius("Raduis",Range(0,0.5)) = 0.1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha   
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
                o.uv = v.uv-fixed2(0.5,0.5);
                o.col = fixed4(1,1,1,0);
                return o;
            }
            bool circle(fixed2 p,fixed2 o,fixed radius)
            {
                return distance(p,o)<=radius;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed w = _Width/2;
                fixed h = _Height/2;
                fixed2 leftTop = fixed2(_Center.x-w,_Center.y+h);
                fixed2 leftBottom = fixed2(_Center.x-w,_Center.y-h);
                fixed2 rightTop = fixed2(_Center.x+w,_Center.y+h);
                fixed2 rightBottom = fixed2(_Center.x+w,_Center.y-h);
                if(circle(i.uv,leftTop,_Radius)||circle(i.uv,leftBottom,_Radius)
                ||circle(i.uv,rightTop,_Radius)||circle(i.uv,rightBottom,_Radius))
                {
                    i.col = _Color;
                }               
                if(abs(i.uv.x-_Center.x)<=w+_Radius&&abs(i.uv.y-_Center.y)<=h
                ||abs(i.uv.y-_Center.y)<=h+_Radius&&abs(i.uv.x -_Center.x)<=w)
                {
                    i.col = _Color;
                }
                
                // if(circle(i.uv,fixed2(0.4,0.4),_Radius)||circle(i.uv,leftTop,_Radius)||
                // circle(i.uv,fixed2(-0.4,-0.4),_Radius)||circle(i.uv,fixed2(0.4,-0.4),_Radius))
                // {
                    //     i.col = _Color;
                // }
                // if(i.uv.x>=-0.5&&i.uv.x<=0.5&&i.uv.y>=-0.4&&i.uv.y<=0.4||
                // i.uv.y>=-0.5&&i.uv.y<=0.5&&i.uv.x>=-0.4&&i.uv.x<=0.4)
                // {
                    //     i.col = _Color;
                // }

                return i.col;
            }
            ENDCG
        }
    }
}
