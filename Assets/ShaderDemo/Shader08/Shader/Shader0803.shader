Shader "Custom/08/Shader0803"
{
    Properties
    {
        
    }
    SubShader
    {
        CGINCLUDE
        struct appdata
        {
            float4 vertex : POSITION;
        };

        struct v2f
        {
            float4 vertex : SV_POSITION;
        };
        
        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            return o;
        }
        fixed4 frag (v2f i) : SV_Target
        {
            fixed4 col = fixed4(1,1,1,1);
            return col;
        }
        ENDCG

        ColorMask 0 //不输出颜色
        ZWrite Off //不写入深度
        Stencil
        {
            Ref 1 //参考值
            Comp Always //全部通过
            Pass Replace //将通过的用参考值1来代替
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }
}
