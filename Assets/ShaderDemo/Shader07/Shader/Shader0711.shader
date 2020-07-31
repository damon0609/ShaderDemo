// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//高光反射模型 也称作镜面反射
Shader "Custom/07/Shader0711"
{
    Properties
    {
        _Color("Color",Color)=(1,1,1,1)
        _RemapTex("RemapTex",2D)="white"{}
        _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(80,255))=20
    }
    SubShader
    {
        Pass
        {
            Tags {"LightMode"="ForwardBase"}
            CGPROGRAM
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct appdata members normal)
#pragma exclude_renderers d3d11

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal;
                float4 texcoord:TEXCOORD;
            };
            struct v2f
            {
                float4 pos:SV_POSITION;
                fixed4 worldPos:TEXCOORD0;
                fixed3 worldNormal:TEXCOORD1;
                fixed2 uv:TEXCOORD2;
            };

            fixed4 _Color;
            sampler2D _RemapTex;
            fixed4 _RemapTex_ST;
            fixed4 _Specular;
            fixed _Gloss;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld,v.vertex);//将物体顶点转成世界坐标系顶点
                o.worldNormal = UnityObjectToWorldNormal(v.normal);//将物体法线转换成世界坐标下法线
                o.uv = TRANSFORM_TEX(v.texcoord,_RemapTex);//用内置函数对纹理进行缩放和平移
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float3 nomral = normalize(i.worldNormal);
                float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));//计算顶点反射方向

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                //漫反射
                fixed3 halfLambert = 0.5*dot(nomral,lightDir)+0.5;
                fixed3 diffuseColor = tex2D(_RemapTex,fixed2(halfLambert,halfLambert)).rgb*_Color.rgb;
                fixed3 diffuse = diffuseColor*_LightColor0.rgb;

                //镜面反射
                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                fixed3 halfDir = normalize(lightDir+viewDir);
                fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(0,dot(normal,halfDir)),_Gloss);
                
                return fixed3(ambient + diffuse + specular,1.0);
            }
            ENDCG
        }
    }
    // FallBack "Specular" 
}
