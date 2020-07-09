//屏幕随着时间变暗变亮

Shader "Unlit/Shader002"
{
    Properties{
        _Color("Color",Color) = (1,1,1,1)
        _MainText("MainTex",2D)="white"{}
        _Background("Background",2D)="white"{}
        _ScrollX("ScrollX",float) =1
        _Scroll2X("Scroll2X",float)=2
        _Multipier("Multipier",float)=1
    }
    SubShader{
        Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Opaque" }
        Pass{
            
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert  
            #pragma fragment frag 
            #include "UnityCG.cginc"
            
            struct vertexInput {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };
            struct vertexOutput {
                float4 pos : SV_POSITION;
                float4 uv:TEXCOORD0; 
            };

            sampler2D _MainText;
            fixed4 _MainText_ST;

            sampler2D _Background;
            fixed4 _Background_ST;

            float _ScrollX;
            float _Scroll2X;
            float _Multipier;
            float4 _Color;

            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;
                output.pos = UnityObjectToClipPos(input.vertex);
                output.uv.xy = TRANSFORM_TEX(input.uv,_MainText)+frac(float2(_ScrollX,0)*_Time.y);
                output.uv.zw = TRANSFORM_TEX(input.uv,_Background)+frac(float2(_Scroll2X,0)*_Time.y);
                return output;
            }
            
            float4 frag(vertexOutput input) : COLOR
            {
                fixed4 forebackground = tex2D(_MainText,input.uv.xy);
                fixed4 background = tex2D(_Background,input.uv.zw);
                fixed4 col = lerp(forebackground,background,background.a);
                col.rgb *= _Multipier;
                col.rgb*=_Color.rgb;
                return col;
            }
            ENDCG
        }
    }
}
