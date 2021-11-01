// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "SanShaders/BasicUnlit_WallDetection_Shader"
{
	Properties
	{
		_Color("Behind the Wall Color", Color) = (1,1,1,1)
		_MainTex ("Main Texture", 2D) = "white" {}
	}


		Subshader
	{
		  Pass
        {
            Stencil 
			{
				  Ref 1
				  Comp always
				  Pass replace
				  ZFail keep
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }


		   Pass{
             ZWrite on
			 ZTest Always
			 Blend SrcAlpha OneMinusSrcAlpha

				Stencil {
				  Ref 1
				  Comp NotEqual
				}

				//Give shader which you want to display behind the wall!!
				CGPROGRAM
					 #pragma vertex vert
					 #pragma fragment frag

				    uniform half4 _Color;
					struct vertexInput
					{
						float4 vertex: POSITION;
					};

					struct vertexOutput
					{
						float4 pos : SV_POSITION;
					};

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}


			half4 frag(vertexOutput i) : COLOR
			{
				return _Color;
			}

			   ENDCG
		   }
	}
}
