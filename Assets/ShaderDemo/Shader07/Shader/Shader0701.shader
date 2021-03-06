﻿Shader "Custom/07/Shader0701"
{
    Properties{
        _Color("Color",Color)=(1,1,1,1)
        _PlaneNormal("PlaneNormal",Vector)=(1,1,1,1)
        _Point("Point",Vector)=(0,0,0,0)
        _RangeArea("RangeArea",Range(0,0.5))=0.1
        _Color02("Color02",Color)=(1,1,1,1)
        _Alpha("Alpha",Range(0,1))=0.2
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
                float4 vertex:TEXCOORD;
            };

            fixed4 _Color;
            fixed3 _PlaneNormal;
            fixed3 _Point;
            float _RangeArea;
            fixed4 _Color02;
            float _Alpha;

            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;
                output.pos = UnityObjectToClipPos(input.vertex);
                output.vertex = input.vertex;
                return output;
            }
            float4 frag(vertexOutput input) : COLOR
            {
                fixed4 col = _Color;
                fixed3 worldPos = mul(unity_ObjectToWorld,input.vertex).xyz;
                fixed3 dir = worldPos-_Point;//计算模型顶点和平面上一点的方向向量  
                float cosQ = dot(normalize(dir),normalize(_PlaneNormal.xyz));
                float dis = length(dir)*cosQ;
                float r =saturate(dis/_RangeArea);
                col=lerp(_Color02,_Color,r);

                if(dis<0)
                {
                    col.a = 0;
                }
                return col;
            }
            ENDCG
        }
    }
    Fallback "Diffuse"

}
