// jave.lin 2019.08.08
Shader "Test/Ballooncat" {
    Properties {
        _PlaneUpColor ("Plane Up Color", Color) = (1,0,0,1)
        _PlaneDownColor ("Plane Down Color", Color) = (0,1,0,1)
        _PlaneIntersectedColor ("Plane Intersected Color", Color) = (1,1,0,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Alpha ("Alpha", Range(0, 1)) = 0.3
        _CutRange("CutRange", Range(0, 1)) = 1
    }
    
    CGINCLUDE
    #pragma vertex vert
    #pragma fragment frag
    #include "Lighting.cginc"
    #include "UnityCG.cginc"
    struct appdata {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
        float3 normal : NORMAL;
    };
    struct v2f {
        float4 vertex : SV_POSITION;
        float2 uv : TEXCOORD0;
        float3 normal : NORMAL;
        float3 worldPos : TEXCOORD01;
        float3 objPos : TEXCOORD02;
    };
    sampler2D _MainTex;
    float4 _MainTex_ST;
    fixed4 _PlaneUpColor;
    fixed4 _PlaneDownColor;
    fixed4 _PlaneIntersectedColor;
    float3 p0, upDir; // plane infos
    float _Alpha;
    float _CutRange;
    v2f vert (appdata v) {
        v2f o;
        o.objPos = v.vertex;
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
        o.normal = v.normal;
        o.worldPos = mul(unity_ObjectToWorld, v.vertex);
        return o;
    }

    fixed4 frag (v2f i) : SV_Target
    {
        float a;
        /* =======1======
        float3 posDir = normalize(i.objPos - p0);
        half PdotU = dot(posDir, upDir);
        fixed4 tintColor;
        if (PdotU > 0) tintColor = _PlaneUpColor;
        else tintColor = _PlaneDownColor;
        */
        /* =======2======*/
        // 求点与平面距离
        // 参考：https://blog.csdn.net/qq_23869697/article/details/82688277
        // 其实就是求投影，刚好就是点乘：dot就完事了
        float3 ObjPosDir = i.objPos - p0;           // 片段模型空间与平面某个点的指向
        half distance = dot(ObjPosDir, upDir);      // 将该指向与法线点乘，就是再法线方向的投影长度，同时也是与平面的距离
        fixed4 tintColor;
        if (distance > 0)                           // 在平面上面，我们就处理alpha过渡
        {
            float t = 1 - saturate(distance / _CutRange);
            tintColor = lerp(_PlaneUpColor, _PlaneIntersectedColor, t);     // 上部颜色与交点部分颜色的插值
            a = t * _Alpha;
        }
        else
        {
            float t = 1 - saturate(-distance / _CutRange);
            tintColor = lerp(_PlaneDownColor, _PlaneIntersectedColor, t);     // 下部颜色与交点部分颜色的插值
            a = _Alpha;  // 下面alpha保持为1
        }

        // ambient
        fixed4 ambient = UNITY_LIGHTMODEL_AMBIENT;

        // diffuse
        half3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
        half3 normal = UnityObjectToWorldNormal(i.normal);
        half LdotN = dot(lightDir, normal) * 0.5 + 0.5;
        fixed3 diffuse = tex2D(_MainTex, i.uv).rgb * LdotN;
        diffuse *= tintColor;

        // specular
        half3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
        half3 halfVec = normalize(lightDir + viewDir);
        half HdotN = max(dot(halfVec, normal), 0);
        half3 specular = _LightColor0.rgb * pow(HdotN, 12) * LdotN;

        return fixed4(ambient + diffuse + specular, a);
    }
    ENDCG
    
    SubShader {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Pass {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }
    }
}
