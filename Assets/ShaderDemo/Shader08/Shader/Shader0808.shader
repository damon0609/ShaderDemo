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
                float3 lightDir:TEXCOORD0;
                float3 viewDir:TEXCOORD1;
                float4 uv:TEXCOORD2;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.uv.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                o.uv.zw = v.uv.xy*_Bump_ST.xy+_Bump_ST.zw;//uv的平移和缩放

                float3 binormal = cross(normalize(v.tangent.xyz),normalize(v.normal))*v.tangent.w;
                float3x3 rotation = float3x3(v.tangent.xyz,binormal,v.normal);

                o.lightDir = mul(rotation,ObjSpaceLightDir(v.vertex)).xyz;//将顶点转换到光源空间
                o.viewDir = mul(rotation,ObjSpaceViewDir(v.vertex)).xyz;//将顶点转换成观察空间
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float3 tangentLightDir = normalize(i.lightDir);
                float3 tangentViewDir = normalize(i.viewDir);

                fixed4 packedNormal = tex2D(_Bump,i.uv.zw);//对法线纹理进行采样
                fixed3 tangentNormal = UnpackNormal(packedNormal);//像素法线进行反映射

                tangentNormal.xy*=_BumpScale;
                tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy,tangentNormal.xy)));

                fixed3 albedo = tex2D(_MainTex,i.uv.xy).rgb*_MainColor;
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*albedo;

                fixed3 diffuse = _LightColor0.rgb*albedo*max(0,dot(tangentNormal,tangentLightDir));//漫反射光照模型
                fixed3 halfDir = normalize(tangentLightDir+tangentViewDir);
                fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(0,dot(tangentNormal,halfDir)),_Gloss);//高光反射模型

                return fixed4(albedo+diffuse+specular,1.0);

            }
            ENDCG
        }
    }
}
