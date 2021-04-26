Shader "Unlit/PlottingShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _channel_1("Channel 1 Active",Range(0,1)) = 1.0
        _LineColour_1("Line Colour (Channel 1)", Color) = (1,0,0,1)
        _Offset_1("Offset", Range(-1,1)) = 0.0
        _channel_2("Channel 2 Active",Range(0,1)) = 0.0
        _LineColour_2("Line Colour (Channel 2)", Color) = (0,1,0,1)
        _Offset_2("Offset", Range(-1,1)) = 0.0
        _LineColour_3("Line Colour (Channel 2)", Color) = (0,0,1,1)
        _channel_3("Channel 3 Active",Range(0,1)) = 0.0
        _Offset_3("Offset", Range(-1,1)) = 0.0
        _LineWidth("Line Width", Range(0,2)) = 1.0
        _Scale("Scale", Range(0,2)) = 1.0
        _Offset("Offset", Range(-1,1)) = 0.0

        _Speed("Speed", Range(1,10)) = 1
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

                float _channel_1;
                float _channel_2;
                float _channel_3;

                float _data_ch1[1000];
                float _data_ch2[1000];
                float _data_ch3[1000];
                
                float4 _LineColour_1;
                float4 _LineColour_2;
                float4 _LineColour_3;
                
                float _Offset_1;
                float _Offset_2;
                float _Offset_3;

                float _LineWidth;
                float _Scale;
                float _Offset;

                float _Speed;
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
            fixed4 col = float4(0.0,0.0,0.0,0.0);
                // sample the texture
            for (int j = 0; j < 3; j++) {
                float data[1000];
                for (int jj = 0; jj < 1000; jj++) {
                    data[jj] = ((float)(_channel_1 > 0) * _data_ch1[jj]) * (float)(j==0);
                    data[jj] += ((float)(_channel_2 > 0) * _data_ch2[jj]) * (float)(j == 1);
                    data[jj] += ((float)(_channel_3 > 0) * _data_ch3[jj]) * (float)(j == 2);
                }
                int k = (int)((i.uv.x * 1000)/_Speed);
                float offset = _Offset_1 * (float)(j == 0) + _Offset_2 * (float)(j == 1) + _Offset_3 * (float)(j == 2);
                float c = (data[k] * _Scale) + offset + _Offset;
                col += (float)(j == 0) * _LineColour_1 * (float)(i.uv.y <= (c + _LineWidth) && i.uv.y >= (c - _LineWidth)) * _channel_1;
                col += (float)(j == 1) * _LineColour_2 * (float)(i.uv.y <= (c + _LineWidth) && i.uv.y >= (c - _LineWidth)) * _channel_2;
                col += (float)(j == 2) * _LineColour_3 * (float)(i.uv.y <= (c + _LineWidth) && i.uv.y >= (c - _LineWidth)) * _channel_3;
            }
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
