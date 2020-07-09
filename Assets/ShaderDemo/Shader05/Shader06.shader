Shader "Unlit/Shader06"
{
    Properties
    {
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
            };

            
            fixed4 _Color;
            fixed _Height;
            fixed _Width;
            fixed _Radius;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv- fixed2(0.5,0.5);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = fixed4(1,1,1,0);
                float w = _Width-_Radius;
                float h = _Height-_Radius;
                float rx= fmod(i.uv.x,w);
                float ry = fmod(i.uv.y,h);

                //这里可以绘制矩形
                fixed mx = step(w,abs(i.uv.x));
                fixed my =step(h,abs(i.uv.y));

                fixed mn = step(_Radius,length(fixed2(rx,ry)));
                if(mx*my*mn<=0)
                {
                    col = _Color;
                }
                return col;
            }
            ENDCG
        }
    }
}
