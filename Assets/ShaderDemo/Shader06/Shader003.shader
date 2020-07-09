//屏幕随着时间变暗变亮

Shader "Unlit/Shader004"
{
    Properties{
        _Color1("Color1",Color) = (0,0,0,1)
        _Color2("Color2",Color) = (1,1,1,1)
        _Radius("Radius",Range(0,1))=0.5
        
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
                //加色系 颜色的加法运算符合加色系，颜色相加后会变亮朝白色

                fixed4 col = fixed4(1,1,1,1);
                float r1 = length(input.uv-fixed2(0,0.5));
                col *= ((1-step(_Radius,r1))*_Color1);

                float r2 = length(input.uv-fixed2(1,0.5));
                col += ((1-step(_Radius,r2))*_Color2);
                return col;
            }
            ENDCG
        }
    }
}
