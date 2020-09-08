Shader "Custom/08/Shader0807"
{
    Properties
    {
        _MainColor("Color",Color)=(1,1,1,1)
        _OutLineColor("OutLineColor",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags{"Queue"="Geometry"}
        ZTest On //进行深度测试
        ZWrite On //不写入深度缓存区
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            fixed4 _MainColor;
            fixed4 _OutLineColor;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                return _OutLineColor;
            }
            ENDCG
        }
    }
}
