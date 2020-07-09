//屏幕随着时间变暗变亮

Shader "Unlit/Shader010"
{
    Properties{
        _MainTex("MainTex",2D)="white"{}
        _Speed("Speed",float) = 0.5
        _Center("Center",Vector)=(0.5,0.5,0,0)
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
            float _Speed;
            fixed4 _Center;

            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;
                output.pos = UnityObjectToClipPos(input.vertex);
                output.uv = TRANSFORM_TEX(input.uv,_MainTex);
                return output;
            }
            float4 frag(vertexOutput input) : COLOR
            {
                fixed2 uv = _Center.xy - input.uv;
                float radius = radians(_Speed*_Time.z);
                uv = fixed2(uv.x*cos(radius)-uv.y*sin(radius),uv.x*sin(radius) + uv.y*cos(radius));
                uv+=_Center.xy;
                fixed4 col = tex2D(_MainTex,uv);
                return col;
            }
            ENDCG
        }
    }
}
