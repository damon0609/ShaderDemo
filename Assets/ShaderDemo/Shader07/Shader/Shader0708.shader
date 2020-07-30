// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//高光反射模型 也称作镜面反射
Shader "Custom/07/Shader0708"
{
    Properties
    {
        _strength("Strength",Range(0,5))=1
        _Color("Color",Color)=(1,1,1,1)
        _Diffuse("Diffuse",Color)=(1,1,1,1)

    }
    SubShader
    {
        Pass
        {
            Tags{"LightMode"="ForwardBase"}
            Blend SrcAlpha OneMinusSrcAlpha
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
                fixed4 color:COLOR;
            };

            
            float _strength;
            fixed4 _Color;
            fixed4 _Diffuse;
            
            v2f vert (appdata v)
            {
                v2f o;
                v.vertex.xyz +=normalize(v.normal)*(_strength * saturate(_SinTime.z));
                o.pos = UnityObjectToClipPos(v.vertex);

                float3 lightColor = _LightColor0.rgb;//灯光颜色
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 resultDiffuse =normalize(0.5+0.5*dot(lightDir,normalize(v.normal)));

                float3 diffuse = _Diffuse*lightColor*resultDiffuse;

                o.color.rgb = UNITY_LIGHTMODEL_AMBIENT.xyz+_Color+diffuse;
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(i.color.rgb,1);
            }
            ENDCG
        }
    }
}
