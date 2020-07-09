Shader "Custom/NewSurfaceShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		_BorderColor("BorderColor",Color) = (1,1,1,1)
		_Point("Point",Vector) = (0.5,0.5,0,0)
		_XAxis("XAxis",float) = 1
		_YAxis("YAxis",float) = 1
		_ZAxis("ZAxis",float) = 1
		_BorderSize("BorderSize",Range(0,1)) = 0.2
	}
		SubShader
		{
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard fullforwardshadows

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _MainTex;

			struct Input
			{
				float2 uv_MainTex;
			};

			half _Glossiness;
			half _Metallic;
			fixed4 _Color;

			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// #pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				// Albedo comes from a texture tinted by color
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = c.rgb;
				// Metallic and smoothness come from slider variables
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
				o.Alpha = c.a;
			}
			ENDCG

			Pass
			{
				ZWrite Off
				Blend SrcAlpha OneMinusSrcAlpha // 缓冲区的颜色混合

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

			fixed4 _MainTex_ST;
			sampler2D _MainTex;

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
					fixed4 col = fixed4(1,1,1,1);
					col = tex2D(_MainTex,i.uv);
					fixed3 worldPos = mul(unity_ObjectToWorld, i.vertex).xyz;
					float xResult = abs(worldPos.x - _Point.x);
					float yResult = abs(worldPos.y - _Point.y);
					float zResult = abs(worldPos.z - _Point.z);


					if (xResult > _XAxis / 2 || yResult > _YAxis / 2 || zResult > _ZAxis / 2)
					{
						discard;
					}

					if (xResult >= _XAxis / 2 - _BorderSize || yResult >= _YAxis / 2 - _BorderSize || zResult >= _ZAxis / 2 - _BorderSize)
					{
						_BorderColor.a = clamp(xResult / _XAxis / 2, 0, 1);
						col = _BorderColor;
					}
					return col;
				}
				ENDCG
			}
		}
			FallBack "Diffuse"
}
