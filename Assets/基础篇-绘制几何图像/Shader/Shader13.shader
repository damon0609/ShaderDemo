Shader "Unlit/Shader13"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Radius("Radius",Range(0,1)) = 0.5
        _Denisty("Denisty",Range(0,1)) =0.5
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }

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
            fixed _Radius;
            fixed _Denisty;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // fixed2 dir = fixed2(0.5,0.5)-i.uv;
                // fixed2 scale = fixed2(_ScreenParams.x/_ScreenParams.y,1);
                // float dis = length(dir*scale);
                // if(dis<_Radius)
                // {
                //     fixed target =  0.299*col.r+0.587*col.g+0.114*col.b;
                //     fixed4 gray = fixed4(target,target,target,1);
                //     col = lerp(col,gray,_Denisty);
                // }

                if(i.uv.x<=_SinTime.z)
                {
                    fixed target =  0.299*col.r+0.587*col.g+0.114*col.b;
                    fixed4 gray = fixed4(target,target,target,1);
                    col = lerp(col,gray,_Denisty);
                }
                return col;
            }
            ENDCG
        }
    }
}
