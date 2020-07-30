// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//高光反射模型 也称作镜面反射
Shader "Custom/07/Shader0706"
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
                float3 worldNormal : TEXCOORD;
                float3 worldVertex:TEXCOORD1;
            };

            float4 _Diffuse;
            float4 _Specular;
            float _Gloss;

          
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal).xyz);
                o.worldVertex = normalize(mul(unity_ObjectToWorld,v.vertex).xyz);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                float3 diffuse = _LightColor0.rgb*_Diffuse.rgb*saturate(dot(lightDir,normalize(i.worldNormal)));//漫反射

                float3 reflectDir = normalize(reflect(-lightDir,normalize(i.worldNormal)));//反射方向

                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz-i.worldVertex.xyz);//观察方向的

                float3 specular = _LightColor0.rgb*_Specular.rgb*pow(saturate(dot(reflectDir,viewDir)),_Gloss);

                float3 color = ambient+ diffuse+specular;

                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
}
