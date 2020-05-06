Shader "Unlit/Shader15"
{
    Properties
    {
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            float3 hsb2rgb(float3 c)
            {
                //clamp将输入的数值限制在指定的范围内，大于右边返回右边，小于左边返回左边，在左右之间返回本身值
                float3 rgb = clamp(abs(fmod(c.x*6.0+float3(0.0,4.0,2.0),6.0)-3.0)-1.0,0,1);
                rgb = rgb*rgb*(3.0-2.0*rgb);
                return c.z*lerp(float3(1,1,1),rgb,c.y);
            }

            // float3 hsb2rgb( float3 c ){
            //     float3 rgb = clamp( abs(fmod(c.x*6.0+float3(0.0,4.0,2.0),6)-3.0)-1.0, 0, 1);
            //     rgb = rgb*rgb*(3.0-2.0*rgb);
            //     return c.z * lerp( float3(1,1,1), rgb, c.y);
            // }

            
            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 col;
                col.rgb = hsb2rgb(float3(i.uv.x,1,i.uv.y));
                return col;
            }
            ENDCG
        }
    }
}
