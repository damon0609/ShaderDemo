// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/10/Shader1007"
{
    Properties
    {
        _Color("VirtualObjectColor",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags {"Queue"="Transparent"}
        Pass
        {
            //渲染队列为不透明物体，则绘制规则为从近到远进行绘制
            //首先进行深度测试则，该物体的深度首先和无像素时（深度值为无限大）进行对比，其默认值为LEqual，所以测试可以通过
            //由于深度测试已经通过，其红色会更新到颜色缓存中
            //由于该pass深度测试虽然已经通过颜色也已经更新到颜色缓存中，但是其深度值并没有写入颜色缓存中所以深度缓存中的值依然为无限大
            //接下下来绘制的物体由于深度测试被通过，所以颜色会更新到颜色缓存中并且其深度写入是开启的则此时深度缓存的值为灰色色物体的深度值
            //如果将该pass的深度值写入则进入正常的渲染流程
            //在几何队列中不能关闭深度写入否则颜色无法进入颜色缓存中
            ZTest LEqual
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            fixed4 _Color;
            struct appdata
            {
                float4 vertex : POSITION;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
            };
            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag (v2f i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
