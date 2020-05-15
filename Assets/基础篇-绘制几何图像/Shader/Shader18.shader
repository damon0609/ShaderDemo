//屏幕随着时间变暗变亮

Shader "Unlit/Shader18"
{
    Properties{
        _MainText("MainTex",2D)="white"{}
    }
    SubShader{
        Pass{
            
            Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Opaque" }
            Blend SrcAlpha OneMinusSrcAlpha // standard alpha blending
            
            CGPROGRAM
            #pragma vertex vert  
            #pragma fragment frag 
            #include "UnityCG.cginc"
            
            struct vertexInput {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            struct vertexOutput {
                float4 pos : SV_POSITION;
                float2 uv:TEXCOORD0; 
            };

            sampler2D _MainText;
            fixed4 _MainText_ST;

            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;
                output.pos = UnityObjectToClipPos(input.vertex);
                output.uv = TRANSFORM_TEX(input.uv,_MainText);
                return output;
            }
            
            float4 frag(vertexOutput input) : COLOR
            {
                fixed4 col = tex2D(_MainText,input.uv);
                float value = _SinTime.w;
                col.a = value;
                return col;
            }
            ENDCG
        }
    }
}
