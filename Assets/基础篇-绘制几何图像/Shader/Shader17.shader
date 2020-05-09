﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Shader17"
{
    Properties{
        _Color("Color", Color) = (1, 1, 1, 0.5)
    }
    SubShader{
        Tags{ "Queue" = "Transparent" }
        // draw after all opaque geometry has been drawn
        Pass{
            ZWrite Off // don't occlude other objects
            Blend SrcAlpha OneMinusSrcAlpha // standard alpha blending
            //==float4 result = fragment_output.aaaa * fragment_output + (float4(1.0, 1.0, 1.0, 1.0) - fragment_output.aaaa) * pixel_color;
            
            CGPROGRAM
            
            #pragma vertex vert  
            #pragma fragment frag 
            
            #include "UnityCG.cginc"
            
            uniform float4 _Color; // define shader property for shaders
            
            struct vertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };
            struct vertexOutput {
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD;
                float3 viewDir : TEXCOORD1;
            };
            
            vertexOutput vert(vertexInput input)
            {
                vertexOutput output;
                
                float4x4 modelMatrix = unity_ObjectToWorld;//模型世界空间矩阵 可以将模型的顶点有模型空间变换到世界空间 float3 pos = mul(unity_ObjectToWorld,input.vertex).xyz;
                float4x4 modelMatrixInverse = unity_WorldToObject;//模型的逆矩阵
                
                output.normal = normalize(UnityObjectToWorldNormal(input.normal));//将模型的法线由模型空间转换到世界空间中
                output.viewDir = normalize(UnityWorldSpaceViewDir(mul(unity_ObjectToWorld,input.vertex).xyz));

                output.pos = UnityObjectToClipPos(input.vertex);

                return output;
            }
            
            float4 frag(vertexOutput input) : COLOR
            {
                //为什么在顶点着色器程序中已经将这两个向量归一化了，在此为什么还要归一化？
                //1>首先，在顶点程序中归一化是因为要在任何它们之间的方向上进行或多或少的插值
                //2>在此处又进行一次插值是因为，上面的插值过程会将归一化的值扭曲
                float3 normalDirection = normalize(input.normal);
                float3 viewDirection = normalize(input.viewDir);
                
                float newOpacity = min(1.0, _Color.a / abs(dot(viewDirection, normalDirection)));
                return float4(_Color.rgb, newOpacity);
            }
            ENDCG
        }
    }
}
