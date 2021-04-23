Shader "Unlit/PlottingShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LineColour("Line Colour", Color) = (1,0,0,1)
        _LineWidth("Line Width", Range(0,2)) = 1.0
        _Scale("Scale", Range(0,2)) = 1.0
        _Offset("Offset", Range(-1,1)) = 0.0
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
            LOD 100

            Pass
            {
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                // make fog work
                #pragma multi_compile_fog

                #include "UnityCG.cginc"

                float _data[1000];
                float4 _LineColour;
                float _LineWidth;
                float _Scale;
                float _Offset;
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

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                int j = (int)(i.uv.x * 1000);
                float c = (_data[j]*_Scale) + _Offset;
                fixed4 col = _LineColour * (float)(i.uv.y<=(c+_LineWidth)&&i.uv.y >= (c -_LineWidth));
                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
