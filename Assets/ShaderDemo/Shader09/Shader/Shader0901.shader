Shader "Custom/09/Shader0901"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _outLineSize("outLineSize",int)=4
        _outLineTex("outLineTex",2D)="black"{}
        _renderTex("renderTex",2D)="black"{}
    }

    CGINCLUDE

    float _outLineSize;
    sampler2D _MainTex;
    float4 _MainTex_ST;

    struct a2v{
        float4 vertex:POSITION;
        float2 uv:TEXCOORD;
    };

    struct v2f{
        float4 pos:SV_POSITION;
        float2 uv[5]:TEXCOORD;
    };

    v2f vert_heng(a2v v)
    {
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);
        float2 uv = v.uv;
        o.uv[0] = uv;
        o.uv[1] = uv+float2(1,0)*_outLineSize*_MainTex_ST.xy;
        o.uv[2] = uv+float2(-1,0)*_outLineSize*_MainTex_ST.xy;
        o.uv[3] = uv+float2(2,0)*_outLineSize*_MainTex_ST.xy;
        o.uv[4] = uv+float2(-2,0)*_outLineSize*_MainTex_ST.xy;

        return o;
    }

    v2f vert_shu(a2v v)
    {
        v2f o;
        o.pos = UnityObjectToClipPos(v.vertex);
        float2 uv = v.uv;
        o.uv[0] = uv;
        o.uv[1] = uv+float2(0,1)*_outLineSize*_MainTex_ST.xy;
        o.uv[2] = uv+float2(0,-1)*_outLineSize*_MainTex_ST.xy;
        o.uv[3] = uv+float2(0,2)*_outLineSize*_MainTex_ST.xy;
        o.uv[4] = uv+float2(0,-2)*_outLineSize*_MainTex_ST.xy;

        return o;
    }

    fixed4 frag(v2f o):SV_TARGET
    {
        float3 col1 = tex2D(_MainTex,o.uv[0]).xyz*0.4026; 
        float3 col2 = tex2D(_MainTex,o.uv[1]).xyz*0.2442;
        float3 col3 = tex2D(_MainTex,o.uv[2]).xyz*0.2442;       
        float3 col4 = tex2D(_MainTex,o.uv[3]).xyz*0.0545;       
        float3 col5 = tex2D(_MainTex,o.uv[4]).xyz*0.0545;  
        float3 finalColor = col1+col2+col3+col4+col5;
        return fixed4(finalColor,1.0f);     
    }

    ENDCG

    SubShader
    {
        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            CGPROGRAM
            #include"UnityCG.cginc"
            #pragma vertex vert_heng
            #pragma fragment frag 
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #include"UnityCG.cginc"
            #pragma vertex vert_shu
            #pragma fragment frag 
            ENDCG
        }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv:TEXCOORD0;
            };

            struct vf
            {
                float4 pos : SV_POSITION;
                float2 uv:TEXCOORD0;
            };

            sampler2D _renderTex;

            vf vert (appdata v)
            {
                vf o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            fixed4 frag (vf i) : SV_Target
            {
                float3 color01 =tex2D(_MainTex,i.uv).xyz;
                float3 color02 = tex2D(_renderTex,i.uv).xyz;
                return float4(color01-color02,1.0);
            }
            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv:TEXCOORD0;
            };

            struct v1f
            {
                float4 pos : SV_POSITION;
                float2 uv:TEXCOORD0;
            };

            sampler2D _outLineTex;

            v1f vert (appdata v)
            {
                v1f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            fixed4 frag (v1f i) : SV_Target
            {
                float4 color01 =tex2D(_MainTex,i.uv);
                float4 color02 = tex2D(_outLineTex,i.uv);
                return float4(color01.xyz+color02.xyz,color01.w);
            }
            
            ENDCG
        }
    }
}
