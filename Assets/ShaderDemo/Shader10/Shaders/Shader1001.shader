Shader "Custom/10/Shader1001"
{
    Properties
    {
        _Angle("Angle",Range(0,360))=60
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        Pass
        {
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float _Angle;
            uniform fixed2 _edges[4];
            uniform int _index;

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
                o.uv = v.uv;
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                // fixed a = clamp(dot(fixed2(1,0),i.uv.xy),0,0.5);
                // fixed result = dot(_edges[_index],normalize(i.uv.xy));
                fixed result = dot(fixed2(0.5,0.5),normalize(i.uv.xy));
                fixed a = 0;
                if(result>=0.7f)
                {
                    a=1;
                }
                fixed4 col = fixed4(1,1,1,a);
                return col;
            }
            ENDCG
        }
    }
}
