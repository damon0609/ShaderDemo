Shader "Custom/10/Shader1003"
{
    Properties
    {
        _Color("RealObjectColor",Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            uniform float4 _Color;
            float4 vert (float4 vertexPos:POSITION):SV_POSITION //返回坐标
            {
                return UnityObjectToClipPos(vertexPos);
            }
            fixed4 frag (void) : COLOR //直接返回颜色
            {
               return float4(_Color.rgb,1);
            }
            ENDCG
        }
    }
}
