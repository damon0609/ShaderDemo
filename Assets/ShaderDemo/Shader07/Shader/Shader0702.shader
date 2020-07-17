Shader "Custom/07/Shader0702"
{
    Properties
    {
        _Diffuse("Diffuse",Color)=(1,1,1,1)
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
                float3 col : COLOR;
                float4 pos : SV_POSITION;
            };

            float4 _Diffuse;

            //逐顶点的漫反射模型
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                
                float3 normal = normalize(UnityObjectToWorldNormal(v.normal));//物体的世界坐标下的法线方向
                float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);//灯光世界坐标系空间下的方向

                float3 diffuse = _Diffuse * _LightColor0.rgb * saturate(dot(normal,worldLightDir)); //漫反射的值
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                o.col = diffuse + ambient; 
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(i.col,1.0);
            }
            ENDCG
        }
    }
}
