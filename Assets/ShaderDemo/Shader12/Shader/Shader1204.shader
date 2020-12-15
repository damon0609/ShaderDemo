// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/12/Shader1204"
{
    Properties
    {
        _MainTex("MainTex",2D)="white"{}
        _OriginPos("OriginPos",Vector) = (0,0,0,0)
        _Radius("Radius",float) = 0
    }
    SubShader
    {


        Pass
        {
            ZWrite On ZTest Always Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            struct appdata{
                float4 vertex:POSITION;
                fixed2 uv:TEXCOORD0;
                uint vid:SV_VERTEXID;
            };

            struct v2f{ 
                fixed4 pos:SV_POSITION;
                fixed4 col:TEXCOORD0;
                fixed2 uv:TEXCOORD1;
            };

            sampler2D _CameraDepthTexture;
            sampler2D _MainTex;
            uniform fixed4 _OriginPos;
            uniform float _Radius;
            uniform float4x4 vcol;
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.col = vcol[v.vid];
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                fixed depth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,i.uv));



                //depth*_ProjectonParams.w = 观察空间中的z值
                fixed3 pos = _WorldSpaceCameraPos.xyz+i.col*(depth*_ProjectionParams.w);
                float dist = distance(_OriginPos,pos);


                fixed4 tex = tex2D(_MainTex,i.uv);
                fixed gray = dot(tex.rgb,fixed3(0.299,0.587,0.114));

                if(dist<=_Radius)
                {
                    return tex;
                }

                
                return fixed4(gray,gray,gray,1);
            }
            ENDCG
        }
    }
}
