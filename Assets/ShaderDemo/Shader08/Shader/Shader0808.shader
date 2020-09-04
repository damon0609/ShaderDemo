Shader "Custom/08/Shader0808"
{
    Properties
    {
        _MainColor("Color",Color)=(1,1,1,1)
        _MainTex("MainTex",2D) = "white"{}
        _Bump("Bump",2D) = "white"{}
        _BumpScale("BumpScale",float)=1
        _Specular("Specular",Color) = (1,1,1,1)
        _Gloss("Gloss",Range(8,255))=20
    }
    SubShader
    {
        Tags{"Queue"="Geometry" "LightMode" = "ForwardBase"}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _MainColor;

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Bump;
            float4 _Bump_ST;

            float _BumpScale;
            fixed4 _Specular;
            float _Gloss;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal:NORMAL;
                float4 tangent:TANGENT;
                float4 uv:TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 uv:TEXCOORD0;
                float4 row0:TEXCOORD1;
                float4 row1:TEXCOORD2;
                float4 row2:TEXCOORD3;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.uv.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                o.uv.zw = v.uv.xy*_Bump_ST.xy+_Bump_ST.zw;//uv的平移和缩放

                float3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                float3 worldNormal  = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityWorldToObjectDir(v.tangent).xyz;//将切线转换到世界空间下
                float3 worldBinormal = cross(worldNormal,worldTangent)*v.tangent.w;//计算出副切线的

                //世界空间下的切线矩阵
                o.row0 = float4(worldTangent.x,worldBinormal.x,worldNormal.x,worldPos.x);
                o.row1 = float4(worldTangent.y,worldBinormal.y,worldNormal.y,worldPos.y);
                o.row2 = float4(worldTangent.z,worldBinormal.z,worldNormal.z,worldPos.z);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float3 worldPos = float3(i.row0.w,i.row1.w,i.row2.w);

                fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));

                fixed4 packedNormal = tex2D(_Bump,i.uv.zw);//对法线纹理进行采样
                fixed3 bump = UnpackNormal(packedNormal);//像素法线进行反映射

                bump.xy*=_BumpScale;
                bump.z = sqrt(1.0 - saturate(dot(bump.xy,bump.xy)));

                bump = normalize(half3(dot(i.row0.xyz,bump),dot(i.row1.xyz,bump),dot(i.row2.xyz,bump)));//将切线从物体坐标转换到世界坐标系



                fixed3 albedo = tex2D(_MainTex,i.uv.xy).rgb*_MainColor;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;

                fixed3 diffuse = _LightColor0.rgb*albedo*max(0,dot(bump,lightDir));//漫反射光照模型
                fixed3 halfDir = normalize(lightDir+viewDir);
                fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(0,dot(bump,halfDir)),_Gloss);//高光反射模型

                return fixed4(albedo+diffuse+specular,1.0);

            }
            ENDCG
        }
    }
}
