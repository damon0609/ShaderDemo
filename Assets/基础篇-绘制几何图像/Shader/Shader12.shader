Shader "Unlit/Shader12"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _NoiseTex("Noise",2D) = "white"{}
        _NoiseFactor("NoiseFactor",Range(0,1)) = 0.5 
        _NoiseSize("NoiseSize",Range(0,1))=0.5
    }
    SubShader
    {
        Tags {"Queue"="Transparent"}
        ZWrite Off
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform fixed4 _MainTex_ST;
            uniform sampler2D _NoiseTex;
            uniform float _NoiseFactor;
            uniform float _NoiseSize;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;
            };

            v2f vert(appdata d)
            {
                v2f v;
                v.pos = UnityObjectToClipPos(d.vertex);
                v.uv = TRANSFORM_TEX(d.uv, _MainTex);
                return v;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = fixed4(1,1,1,1);
                col = tex2D(_MainTex,i.uv);
                if(tex2D(_NoiseTex,i.uv).r<_NoiseFactor)
                {
                    discard;
                }
                if(tex2D(_NoiseTex,i.uv).r<_NoiseFactor+_NoiseSize)
                {
                    col = fixed4(0.6,0.2,0.2,1);
                }
                return col;
            }
            ENDCG
        }
    }
}
