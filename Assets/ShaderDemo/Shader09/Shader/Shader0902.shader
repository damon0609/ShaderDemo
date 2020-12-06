Shader "Custom/09/Shader0902"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Intensity("Intensity",Range(0,1))=0.5
    }
    SubShader
    {
        Tags {"RenderType"="Opaque"  "Queue"="Transparent"}
        
        CGPROGRAM
        #pragma surface surf Lambert alpha

        sampler2D _MainTex;
        float _Intensity;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN,inout SurfaceOutput o) 
        {
           half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = _Intensity;
        }
        ENDCG
    }
    Fallback "Diffuse"
}
