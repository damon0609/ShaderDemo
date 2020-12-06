// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/10/Shader1005"
{
    Properties
    {
        _Color("VirtualObjectColor",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags{ "Queue" = "Transparent"}
        Pass
        {
            Blend OneMinusDstAlpha DstAlpha
            ZTest LEqual
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform float4 _Color;
            uniform float4x4 _WorldMirror;



            struct appdata
            {
                float4 vertex : POSITION;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
                // float4 posInMirror:TEXCOORD0;
            };
            v2f vert (appdata v)
            {
                v2f o;
                // o.posInMirror = mul(_WorldMirror,mul(unity_ObjectToWorld,v.vertex)); //将自身的顶点转换到镜子中
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                // if(i.posInMirror.y>0)
                // {
                    //     discard;
                // }
                // return float4(_Color.rgb,1);

                return fixed4(1,1,1,1);
            }
            ENDCG
        }
    }
}
