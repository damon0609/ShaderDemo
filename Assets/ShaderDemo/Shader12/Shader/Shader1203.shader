// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/12/Shader1203"
{
    Properties
    {
        _MixTex("MixTex",2D)="white"{}
        _grayIns("gray",Range(0,1))=0.5
        _Radius("Radius",Range(0,1))=0.5
    }
    SubShader
    {
        Pass
        {
            ZWrite On ZTest Always Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"


            struct appdata{
                float4 vertex:POSITION;
                fixed2 uv:TEXCOORD0;
            };

            struct v2f{ 
                fixed4 pos:SV_POSITION;
                fixed2 uv:TEXCOORD1;
            };

            sampler2D _ScreenImage;
            fixed _grayIns;
            fixed _Radius;
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed rate = _ScreenParams.x/_ScreenParams.y;
                fixed4 col01 = tex2D(_ScreenImage,i.uv);
                fixed4 finalColor = col01;


                fixed grayColor = col01.r*0.299 + col01.g*0.587+col01.b*0.114;
                fixed4 gray=fixed4(grayColor,grayColor,grayColor,1);
                
                // fixed4 finalColor = lerp(col01,fixed4(grayColor,grayColor,grayColor,1),_grayIns);

                fixed2 dir = fixed2(0.5,0.5)-i.uv;
                dir.x*=rate;
                if(length(dir)<_Radius)
                {
                    finalColor = col01;
                }
                else{
                    finalColor = gray;
                }

                return finalColor;
            }
            ENDCG
        }
    }
}
