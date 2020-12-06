// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/10/Shader1004"
{
    Properties
    {
        _Color("MirrorsColor",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags{"Queue"="Transparent+10"}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert (float4 vertexPos:POSITION):SV_POSITION
            {
                return UnityObjectToClipPos(vertexPos);
            }
            fixed4 frag (void) : COLOR
            {
                return float4(1,0,0,0);
            }
            ENDCG
        }
        Pass{
            ZTest Always
            Blend OneMinusDstAlpha DstAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            

            uniform float4 _Color;
            float4 vert (float4 vertexPos:POSITION):SV_POSITION
            {
                float4 pos = UnityObjectToClipPos (vertexPos);
                pos.z = pos.w;
                return pos;
            }
            fixed4 frag (void) : COLOR
            {
                return float4(_Color.rgb,0);
            }
            ENDCG
        }
    }
}
