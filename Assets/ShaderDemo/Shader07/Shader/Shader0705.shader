// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//高光反射模型 也称作镜面反射
Shader "Custom/07/Shader0705"
{
    Properties
    {
        _Diffuse("Diffuse",Color)=(1,1,1,1)
        _Specular("Specular",Color) =(1,1,1,1)
        _Gloss("Gloss",Range(8.0,255))=20
    }
    SubShader
    {
        Pass
        {
            Tags {"LightMode"="ForwardBase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc" 

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
                float3 color : COLOR;
            };

            float4 _Diffuse;
            float4 _Specular;
            float _Gloss;

            //逐顶点的漫反射模型
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                
                float3 normal = normalize(UnityObjectToWorldNormal(v.vertex).xyz);// 将模型的顶点法线转换程世界空间下的法线
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);//光源的方向
                float3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate( dot(lightDir,normal));

                float3 reflectDir = normalize(reflect(-lightDir,normal));//求光源的反射方向
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz-mul(unity_ObjectToWorld,v.vertex).xyz);
                float3 specular = _LightColor0.rgb* _Specular.rgb*pow(saturate(dot(reflectDir,viewDir)),_Gloss);
                o.color = ambient + diffuse + specular;                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);//灯光世界坐标系空间下的方向

                // float3 halfRe=dot(i.normal,worldLightDir)*0.5+0.5;
                // float3 diffuse = _Diffuse * _LightColor0.rgb * halfRe; //漫反射的值
                // float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                // float3 color = diffuse + ambient; 


                return fixed4(i.color,1.0);
            }
            ENDCG
        }
    }
}
