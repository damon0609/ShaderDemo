Shader "Custom/08/Shader0805"
{
    Properties
    {
        _MainTex("Main Tex",2D)="white"{}

    }
    SubShader
    {
        Tags{"LightModel"="ForwardBase" "RenderType"="Opaque"}
        Stencil
        {
            Ref 0 //参考值
            Comp Equal //全部通过
            Pass IncrSat //将通道的测试的模板值加1
            Fail keep
            ZFail keep
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

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
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct data
            {
                float4 vertex : POSITION;
                fixed2 uv:TEXCOORD;
                fixed4 normal:NORMAL;
            };

            struct outData
            {
                float4 vertex : SV_POSITION;
                fixed2 uv:TEXCOORD;
            };
            
            sampler2D _MainTex;
            fixed4 _MainTex_ST;

            outData vert(data data)
            {
                outData o;
                o.vertex = data.normal*0.01f+data.vertex;
                o.vertex = UnityObjectToClipPos(o.vertex);
                o.uv = TRANSFORM_TEX(data.uv,_MainTex);
                return o;
            }

            fixed4 frag(outData v):SV_TARGET
            {
                fixed4 col = tex2D(_MainTex,v.uv);
                return fixed4(1,1,1,1);
            }

            ENDCG
        }
    }
}
