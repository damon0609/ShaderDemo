Shader "Custom/08/Shader0804"
{
    Properties
    {
        _MainTex("Main Tex",2D)="white"{}

    }
    SubShader
    {
        CGINCLUDE
        #include "UnityCG.cginc"

        sampler2D _MainTex;
        fixed4 _MainTex_ST;

        struct appdata
        {
            float4 vertex : POSITION;
            fixed2 uv:TEXCOORD;
        };

        struct v2f
        {
            float4 vertex : SV_POSITION;
            fixed2 uv:TEXCOORD;
        };
        
        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.uv,_MainTex);
            return o;
        }
        fixed4 frag (v2f i) : SV_Target
        {
            fixed4 col = tex2D(_MainTex,i.uv);
            return col;
        }
        ENDCG
       
        Stencil
        {
            Ref 1 //参考值
            Comp Equal //全部通过
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }
}
