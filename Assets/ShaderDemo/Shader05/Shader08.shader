Shader "Unlit/Shader08"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //_Pos("Pos",Vector) = (0.5,0.5,0,0)
        // _Radius("Radius",Range(0,1)) = 0
        // _ScaleFactor("ScaleFactor",Range(0,1))=0.2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Pos;
            float _Radius;
            float _ScaleFactor;
            float _EdgeSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                float2 scale = float2(_ScreenParams.x/_ScreenParams.y,1);//这里为什么会使用_ScreenParams.x/_ScreenParams.y
                float2 center = _Pos;
                float2 dir =center - i.uv;
                float dis = length(dir*scale);
                //float num =1 - step(_Radius,dis);
                float num = smoothstep(_Radius+_EdgeSize,_Radius,dis);
                fixed4 col = tex2D(_MainTex, i.uv+dir*_ScaleFactor*num);
                return col;
            }
            ENDCG
        }
    }
}
