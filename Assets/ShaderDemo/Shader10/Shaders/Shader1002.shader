Shader "Custom/10/Shader1002"
{
    Properties
    {
        _Hex("Hex",2D)="white"{}
    }
    SubShader
    {
        Pass
        {
            ZWrite Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform int _point_length;
            uniform float3 _points[100];
            uniform float2 _properties[100];
            sampler2D _Hex;
            fixed4 _Hex_ST;

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
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                half h = 0;
                for(int i=0;i<_point_length;i++)
                {
                    half d = distance(fixed3(0,0,0),_points[i].xyz);
                    half rate = d/_properties[i].x;
                    half h1 = 1-saturate(rate);
                    h=h1*_properties[i].y;
                }
                h = saturate(h);
                fixed4 col = tex2D(_Hex,fixed2(h,0.5));
                return col;
            }
            ENDCG
        }
    }
}
