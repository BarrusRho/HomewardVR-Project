// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Burning_Shader"
{
	Properties
	{
		[HDR]_AlbedoMap("Albedo Map", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_MetalnessMap("Metalness Map", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_TextureMask("Texture Mask", 2D) = "white" {}
		_TileableFireMap("Tileable Fire Map", 2D) = "white" {}
		_FireIntensity("Fire Intensity", Range( 0 , 2)) = 0
		_FireSpeed("Fire Speed", Range( 1 , 25)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _AlbedoMap;
		uniform float4 _AlbedoMap_ST;
		uniform sampler2D _TextureMask;
		uniform float4 _TextureMask_ST;
		uniform sampler2D _TileableFireMap;
		uniform float _FireSpeed;
		uniform float _FireIntensity;
		uniform sampler2D _MetalnessMap;
		uniform float4 _MetalnessMap_ST;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float2 uv_AlbedoMap = i.uv_texcoord * _AlbedoMap_ST.xy + _AlbedoMap_ST.zw;
			o.Albedo = tex2D( _AlbedoMap, uv_AlbedoMap ).rgb;
			float2 uv_TextureMask = i.uv_texcoord * _TextureMask_ST.xy + _TextureMask_ST.zw;
			float2 panner7 = ( ( _Time.x * _FireSpeed ) * float2( 0.5,0.5 ) + i.uv_texcoord);
			o.Emission = ( ( tex2D( _TextureMask, uv_TextureMask ) * tex2D( _TileableFireMap, panner7 ) ) * ( _FireIntensity * ( _SinTime.w + 1.5 ) ) ).rgb;
			float2 uv_MetalnessMap = i.uv_texcoord * _MetalnessMap_ST.xy + _MetalnessMap_ST.zw;
			o.Metallic = tex2D( _MetalnessMap, uv_MetalnessMap ).r;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
7;623;1272;748;2765.823;-138.6714;1.166367;True;False
Node;AmplifyShaderEditor.RangedFloatNode;19;-2752,512;Inherit;True;Property;_FireSpeed;Fire Speed;7;0;Create;True;0;0;False;0;0;8;1;25;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;10;-2816,288;Inherit;True;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2432,288;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2432,16;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;7;-2000,16;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0.5,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinTimeNode;15;-2416,528;Inherit;True;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-2000,272;Inherit;False;Property;_FireIntensity;Fire Intensity;6;0;Create;True;0;0;False;0;0;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1472,-48;Inherit;True;Property;_TileableFireMap;Tileable Fire Map;5;0;Create;True;0;0;False;0;-1;f7e96904e8667e1439548f0f86389447;f7e96904e8667e1439548f0f86389447;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-1472,-272;Inherit;True;Property;_TextureMask;Texture Mask;4;0;Create;True;0;0;False;0;-1;36be8d528a4fa024faa4680d7658642c;36be8d528a4fa024faa4680d7658642c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;14;-1936,528;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1120,-272;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1680,400;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-528,-768;Inherit;True;Property;_AlbedoMap;Albedo Map;0;1;[HDR];Create;True;0;0;False;0;-1;7130c16fd8005b546b111d341310a9a4;7130c16fd8005b546b111d341310a9a4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-528,-560;Inherit;True;Property;_NormalMap;Normal Map;1;0;Create;True;0;0;False;0;-1;11f03d9db1a617e40b7ece71f0a84f6f;11f03d9db1a617e40b7ece71f0a84f6f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-688,16;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;-784,256;Inherit;True;Property;_MetalnessMap;Metalness Map;2;0;Create;True;0;0;False;0;-1;6618005f6bafebf40b3d09f498401fba;6618005f6bafebf40b3d09f498401fba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-400,320;Inherit;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;False;0;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Burning_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;18;0;10;1
WireConnection;18;1;19;0
WireConnection;7;0;8;0
WireConnection;7;1;18;0
WireConnection;5;1;7;0
WireConnection;14;0;15;4
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;12;0;13;0
WireConnection;12;1;14;0
WireConnection;16;0;6;0
WireConnection;16;1;12;0
WireConnection;0;0;1;0
WireConnection;0;1;2;0
WireConnection;0;2;16;0
WireConnection;0;3;3;0
WireConnection;0;4;17;0
ASEEND*/
//CHKSM=4CA4332030B397B90F6393BB1B8E3F2A396951EA