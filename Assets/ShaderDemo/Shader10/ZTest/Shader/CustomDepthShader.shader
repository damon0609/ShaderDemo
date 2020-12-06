Shader "Unlit/CustomDepthShader"
{
    Properties
    {
    }

    //自定义获取深度法线纹理的shader
    SubShader
    {
        Tags {"RenderType"="Opaque"}
        Pass
        {
            ZTest LEqual
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata{
                float4 vertex:POSITION;
                fixed3 normal:NORMAL;
            };
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 depthNormals:TEXCOORD0;
            };

            uniform sampler2D _CustomDepthNormalsTexture;
            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                //采集深度信息和法线信息
                o.depthNormals.w = COMPUTE_DEPTH_01;
                o.depthNormals.xyz = COMPUTE_VIEW_NORMAL;
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                //将数字数据转换成纹理数据
                return EncodeDepthNormal(i.depthNormals.w,i.depthNormals.xyz);
            }
            ENDCG
        }
    }
}
