// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/12/Shader1204"
{
    Properties
    {
        _Diffuse("Diffuse",Color)=(1,1,1,1)
        _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(8,256))=8
        _MainTex("MainTex",2D)="white"{}
    }
    SubShader
    {
        Pass
        {
            Tags {"LightMode"="ForwardBase"}

            CGPROGRAM
            #pragma multil_compile_fwdbase
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"


            struct appdata{
                float4 vertex:POSITION;
                fixed2 uv:TEXCOORD0;
                fixed3 normal:NORMAL;
            };

            struct v2f{ 
                fixed4 pos:SV_POSITION;
                fixed2 uv:TEXCOORD1;
                fixed3 worldNormal:TEXCOORD2;
                fixed3 worldPos:TEXCOORD3;
                fixed3 vertexLight:TEXCOORD4;
            };

            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            fixed4 _Diffuse;
            fixed4 _Specular;
            fixed _Gloss;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldNormal = UnityObjectToWorldNormal(v.normal).xyz;//在世界空间下的法线向量
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;//顶点的世界坐标，注意使用xyz分量即可

                //计算逐顶点光源和SH函数
                #ifdef LIGHTMAP_OFF //关闭Lightmap时
                    float3 shLight = ShadeSH9(float4(v.normal,1.0));//计算sh的光照
                    o.vertexLight = shLight;
                    #ifdef VERTEXLIGHT_ON //开启顶点光照
                        float3 vertexLight = Shade4PointLights(unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0,
                        unity_LightColor[0].rgb,unity_LightColor[1],unity_LightColor[2],unity_LightColor[3],
                        unity_4LightAtten0,o.worldPos,o.worldNormal);
                        o.vertexLight+=vertexLight;    
                    #endif
                #endif
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));

                fixed3 diff = _LightColor0.rgb*_Diffuse.rgb*max(0,dot(worldNormal,lightDir));//漫反射
                
                fixed3 viewDir= normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                fixed3 halfDir = normalize(viewDir+lightDir);
                fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(0,dot(worldNormal,halfDir)),_Gloss);//高光
                

                fixed4 col = fixed4(ambient+(diff+specular)+ i.vertexLight,1);//逐顶点和sh光照被计算其中
                return col;
            }
            ENDCG
        }

        Pass{
            Tags{"LightMode"="ForwardAdd"}
            Blend One One

            CGPROGRAM
            #pragma multi_compile_fwdadd
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"

            fixed4 _Diffuse;
            fixed4 _Specular;
            fixed _Gloss;

            struct a2v{
                fixed4 vertex:POSITION;
                fixed3 normal:NORMAL;
            };
            struct v2f{
                fixed4 pos:SV_POSITION;
                fixed3 worldNormal:TEXCOORD0;
                fixed3 worldPos:TEXCOORD1;
                LIGHTING_COORDS(2,3)//计算光照衰减
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            fixed4 frag(v2f v):SV_Target
            {
                fixed3 worldNormal = normalize(v.worldNormal);
                fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(v.worldPos));

                fixed3 diff = _LightColor0.rgb*_Diffuse.rgb*max(0,dot(worldNormal,worldLightDir));

                fixed3 viewDir = normalize(UnityWorldSpaceViewDir(v.worldPos));
                fixed3 halfDir = normalize(worldLightDir+viewDir);
                
                fixed3 specular = _LightColor0.rgb*_Specular*pow(max(0,dot(worldNormal,halfDir)),_Gloss);

                fixed atten = LIGHT_ATTENUATION(v);//计算光照衰减值 

                return fixed4((diff+specular)*atten,1.0f);
            }
            ENDCG
        }
    }
}
