Shader "Unlit/Shader11"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Cull Off
        ZTest Always
        ZWrite Off
        Fog{Mode off}

        Pass
        {
            CGPROGRAM
            #pragma fragmentoption ARB_precision_hint_fastest 
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform sampler2D _MainTex;
            uniform float _BlurFactor;
            uniform float2 _BlurCenter;

            fixed4 frag (v2f_img i) : SV_Target
            {
                float2 dir = _BlurCenter.xy - i.uv;
                float4 resColor = 0;
                for(int j=0;j<5;++j)
                {
                    float2 uv = i.uv +_BlurFactor*dir*j;
                    resColor +=tex2D(_MainTex,i.uv);
                }
                resColor*=0.2;
                return resColor;
            }
            ENDCG
        }
    }
}
