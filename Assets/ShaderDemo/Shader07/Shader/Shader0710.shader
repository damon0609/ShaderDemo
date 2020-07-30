// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//高光反射模型 也称作镜面反射
Shader "Custom/07/Shader0710"
{
    Properties
    {
        _Color("Color",Color)=(1,1,1,1)
        _Range("Range",Range(0,1))=0.5
        _Height("Height",float)=0
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
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
                fixed4 color:COLOR;
                fixed4 vertex:TEXCOORD0;
            };
            fixed4 _Color;
            fixed _Range;
            fixed _Height;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = _Color;
                o.vertex = v.vertex;
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                _Height+=0.2;

                fixed temp = abs(i.vertex.y);
                float result = abs(temp-_Range/2);
                if(result<=_Height)
                {
                    discard;
                }
                return i.color;
            }
            ENDCG
        }
    }
}
