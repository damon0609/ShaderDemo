//屏幕随着时间变暗变亮

Shader "Unlit/Shader006"
{
    Properties{
        _Color1("Color1",Color) = (1,1,1,1)
        _Color2("Color2",Color) = (1,1,1,1)
        _Size("Radius",Range(0,1))=0.5
        
    }
    SubShader{
        Pass{
            
            ZWrite Off

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
            float _Radius;

            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;
                output.pos = UnityObjectToClipPos(input.vertex);
                output.uv = input.uv;
                return output;
            }
            float4 frag(vertexOutput input) : COLOR
            {
                fixed4 col = fixed4(1,1,1,1);
                col = lerp(_Color1,_Color2,_SinTime.y);
                if(input.uv.x<0.3)
                {
                    col = _Color1;
                }
                if(input.uv.x>0.7)
                {
                    col = _Color2;
                }
                return col;
            }
            ENDCG
        }
    }
}
