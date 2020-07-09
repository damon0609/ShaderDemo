//屏幕随着时间变暗变亮

Shader "Unlit/Shader004"
{
    Properties{
        _Color1("Color1",Color) = (0,0,0,1)
        _Color2("Color2",Color) = (1,1,1,1)
       
    }
    SubShader{
        Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True"}
        Pass{
            
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert  
            #pragma fragment frag 
            #include "UnityCG.cginc"
            
            struct vertexInput {
                float4 vertex : POSITION;
                float2 uv:TEXCOORD;
            };
            struct vertexOutput {
                float4 pos : SV_POSITION;
                float2 uv:TEXCOORD;
            };
            float4 _Color1;
            float4 _Color2;

            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;
                output.pos = UnityObjectToClipPos(input.vertex);
                output.uv = input.uv;
                return output;
            }
            float4 frag(vertexOutput input) : COLOR
            {
                float result = length(input.uv - fixed2(0.5,0.5))*2;
                fixed4 col = smoothstep(_Color1,_Color2,result);
                col.a = 1 - step(1,result);
                return col;
            }
            ENDCG
        }
    }
}
