// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//高光反射模型 也称作镜面反射
Shader "Custom/07/Shader0709"
{
    Properties
    {
        _MainTex("Main",2D)="white"{}
        _Color("Color",Color)=(1,1,1,1)
        _Diffuse("Diffuse",Color)=(1,1,1,1)
        _Bump("Normal Map",2D)="white"{}
        _BumpScale("BumpScale",float)=1.0
        _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(8.0,256))=20
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
                float4 tangent:TANGENT;
                float4 texcoord:TEXCOORD0;
            };

            struct v2f
            {
                float4 pos:SV_POSITION;
                fixed4 uv:TEXCOORD0;
                float3 lightDir:TEXCOORD1;
                float3 viewDir:TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed4 _Color;
            fixed4 _Diffuse;

            sampler2D _Bump;
            float4 _Bump_ST;

            float _BumpScale;
            float4 _Specular;
            float _Gloss;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv.xy=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                o.uv.zw = v.texcoord.xy*_Bump_ST.xy+_Bump_ST.zw;

                float3 binormal = normalize(cross(v.normal,v.tangent.xyz)*v.tangent.w);//求副切线
                float3x3 tangentWorld = float3x3(normalize(v.normal),normalize(v.tangent.xyz),binormal);//切线空间下的坐标系

                // ObjectSpaceLightDir 模型空间下的光照方向，在将模型空间中的光照方向变换到切线空间
                o.lightDir = mul(tangentWorld,ObjSpaceLightDir(v.vertex));

                //模型空间下的视角方向
                o.viewDir = mul(tangentWorld,ObjSpaceViewDir(v.vertex));
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float3 tangentLightDir = normalize(i.lightDir);
                float3 tangentViewDir = normalize(i.viewDir);

                float4 packedNormal = tex2D(_Bump,i.uv.zw);

                float3 tangentNormal = UnpackNormal(packedNormal);
                tangentNormal.xy*=_BumpScale;
                tangentNormal.z = sqrt(1 - saturate(dot(tangentNormal.xy,tangentNormal.xy)));

                fixed3 albedo = tex2D(_MainTex,i.uv).rgb*_Color.rgb;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;

                fixed3 diffuse = _LightColor0.rgb*albedo*max(0,dot(tangentNormal,tangentLightDir));
                fixed3 halfDir = normalize(tangentLightDir+tangentViewDir);

                fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(0,dot(tangentNormal,halfDir)),_Gloss);

                return fixed4(ambient+diffuse+specular,1.0);

            }
            ENDCG
        }
    }
}
