// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/10/Shader1011"
{
    Properties
    {
        _MainTex("Tex",2D) = "white"{}
    }
    SubShader
    {
        Tags {"Queue"="Geometry" "RenderType"="Geen"}
        Pass
        {
            ZTest LEqual
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                fixed2 uv:TEXCOORD0;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed2 uv:TEXCOORD0;
            };
            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv,_MainTex);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex,i.uv);
                return fixed4(0,1,0,1);
            }
            ENDCG
        }
    }

    SubShader{
        Tags{"Queue"="Geometry" "RenderType"="Red"}
        Pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            struct appdata
            {
                float4 vertex : POSITION;
                fixed2 uv:TEXCOORD0;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
                fixed2 uv:TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv,_MainTex);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex,i.uv);
                return fixed4(1,0,0,1);
            }
            ENDCG
        }
    }
}
