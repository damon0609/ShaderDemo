Shader "Unlit/Shader07"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MaskTex("Mask",Color) =(1,1,1,1)
    }

    CGINCLUDE
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
    fixed4 _MaskTex;

    v2f vert (appdata v)
    {
        v2f o;
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
        o.uv=mul(float2x2(cos(_Time.y),0,sin(_Time.y),0),o.uv);
        return o;
    }

    fixed4 frag (v2f i) : SV_Target
    {
        fixed4 col1 = tex2D(_MainTex, i.uv);
        if(length(i.uv - fixed2(0.5,0.5))<=0.1)
        {
            col1=fixed4(0,0,0,1);
        }
        return col1;
    }
    ENDCG

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Blend SrcAlpha OneMinusSrcAlpha   
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            ENDCG
        }
    }
}
