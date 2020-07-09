//屏幕随着时间变暗变亮

Shader "Unlit/Shader008"
{
    Properties{
        _MainTex("MainTex",2D)="white"{}
    }
    SubShader{
        Tags {"RenderType"= "Opaque"  "Queue" = "Transparent"} //queue是负责渲染队列的如果不定义则不可见 //RenderType 指定渲染方式的 
        Pass{
            
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha // 缓冲区的颜色混合

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

            sampler2D _MainTex;
            fixed4 _MainTex_ST;

            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;
                output.pos = UnityObjectToClipPos(input.vertex);
                output.uv = TRANSFORM_TEX(input.uv,_MainTex);

                return output;
            }
            float4 frag(vertexOutput input) : COLOR
            {
                input.uv-=fixed2(0.5,0.5);
                input.uv*=sin(_Time.x*3.14*2)*4;
                
                fixed4 col = tex2D(_MainTex,input.uv);
                return col;
            }
            ENDCG
        }
    }
}
