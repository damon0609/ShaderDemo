Shader "Unlit/Shader08"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ScaleFactor("ScaleFactor",Range(0,1))=0.5
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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _pos;
            fixed _ScaleFactor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed2 dir =(_pos.xy + fixed2(0.5,0.5))-i.uv;
                fixed4 col = tex2D(_MainTex, i.uv+dir*_ScaleFactor);
                return col;
            }
            ENDCG
        }
    }
}
