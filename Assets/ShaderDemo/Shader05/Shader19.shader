Shader "Unlit/Shader19"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_BorderColor("BorderColor",Color) = (1,1,1,1)
		_Point("Point",Vector) = (0.5,0.5,0,0)
		_XAxis("XAxis",Range(0,100)) = 1
		_YAxis("YAxis",Range(0,100)) = 1
		_ZAxis("ZAxis",Range(0,100)) = 1
		_BorderSize("BorderSize",Range(0,1)) = 0.2
	}
		SubShader
		{
			Tags {"RenderType" = "Opaque"  "Queue" = "Transparent"}
			Pass
			{
				ZWrite Off
				Blend SrcAlpha OneMinusSrcAlpha // 缓冲区的颜色混合

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				uniform sampler2D _MainTex;
				uniform fixed4 _MainTex_ST;
				uniform fixed4 _BorderColor;
				uniform fixed4 _Point;
				uniform float _XAxis;
				uniform float _YAxis;
				uniform float _ZAxis;
				uniform float _BorderSize;

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float4 pos:SV_POSITION;
					float2 uv:TEXCOORD0;
					float4 vertex:TEXCOORD1;
				};

				v2f vert(appdata d)
				{
					v2f v;
					v.pos = UnityObjectToClipPos(d.vertex);
					v.uv = TRANSFORM_TEX(d.uv, _MainTex);
					v.vertex = d.vertex;
					return v;
				}
				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 col = tex2D(_MainTex,i.uv);
					fixed3 worldPos = mul(unity_ObjectToWorld, i.vertex).xyz;//将物体坐标转换世界坐标

					float xResult = abs(worldPos.x - _Point.x);
					float yResult = abs(worldPos.y - _Point.y);
					float zResult = abs(worldPos.z - _Point.z);


					if (xResult > _XAxis / 2 || yResult > _YAxis / 2 || zResult > _ZAxis / 2)
					{
						discard;
					}

					if (xResult >= _XAxis / 2 - _BorderSize || yResult >= _YAxis / 2 - _BorderSize || zResult >= _ZAxis / 2 - _BorderSize)
					{
						col = _BorderColor;
					}
				
					return col;
				}
				ENDCG
			}
		}
}
