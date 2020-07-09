// jave.lin 2019.08.08
Shader "Test/CutPlane" {
    SubShader {
        Tags { "RenderType"="Opaque" }
        Pass {
            
            ColorMask 0
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            float4 vert (float4 vertex : POSITION) : SV_POSITION {
                return UnityObjectToClipPos(vertex);
            }
            fixed4 frag () : SV_Target { 
                discard;
                return fixed4(0,0,0,0); }
            ENDCG
        }
    }
}
