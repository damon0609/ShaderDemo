Shader "Unlit/CustomDepth"
{
    Properties
    {
    }
    SubShader
    {
        Pass
        {
            Tags{ "RenderType"="Opaque" "Queue"="Geomerty" }
            ZTest LEqual
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                fixed2 depth:TEXCOORD0;
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                UNITY_TRANSFER_DEPTH(o.depth); 
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_OUTPUT_DEPTH(i.depth)*100;
            }
            ENDCG
        }
    }
}
