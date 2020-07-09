Shader "Unlit/Shader012"
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
                float2 worldPos:TEXCOORD;
            };

            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            uniform int _PointLength = 0; //点的个数
            uniform float3 _Positions[20];//坐标点
            uniform float2 _Properies[20];//半径和透明度
            
            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;
                output.pos = UnityObjectToClipPos(input.vertex);
                output.worldPos = mul(unity_ObjectToWorld,input.vertex);
                return output;
            }
            float4 frag(vertexOutput input) : COLOR
            {
                fixed4 col = fixed4(1,1,1,1);
                half h;
                for(int i=0;i<_PointLength;i++)
                {
                    half d = distance(input.worldPos,_Positions[i]);
                    half r = _Properies[i].x;
                    half r1 = 1-saturate(d/r);
                    h+=r1*_Properies[i].y;
                }
                h = saturate(h);//限制在0-1
                col = tex2D(_MainTex,fixed2(h,0.5));
                return col;
            }
            ENDCG
        }
    }
    Fallback "Diffuse"

}
