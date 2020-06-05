// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tutorial_Shader"
{
	Properties
	{
		_AlbedoMap("Albedo Map", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_MetalAlbedoMap("Metal Albedo Map", 2D) = "white" {}
		_MetalNormalMap("Metal Normal Map", 2D) = "bump" {}
		_Mask("Mask", 2D) = "white" {}
		_RockMetallic("Rock Metallic", Range( 0 , 1)) = 0
		_MetalMetallic("Metal Metallic", Range( 0 , 1)) = 0
		_RockSmoothness("Rock Smoothness", Range( 0 , 1)) = 0
		_MetalSmoothness("Metal Smoothness", Range( 0 , 1)) = 0.2
		_EmissionMap("Emission Map", 2D) = "white" {}
		_EmissionIntensity("Emission Intensity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _MetalNormalMap;
		uniform float4 _MetalNormalMap_ST;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform sampler2D _AlbedoMap;
		uniform float4 _AlbedoMap_ST;
		uniform sampler2D _MetalAlbedoMap;
		uniform float4 _MetalAlbedoMap_ST;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float _EmissionIntensity;
		uniform float _RockMetallic;
		uniform float _MetalMetallic;
		uniform float _RockSmoothness;
		uniform float _MetalSmoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 tex2DNode2 = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float2 uv_MetalNormalMap = i.uv_texcoord * _MetalNormalMap_ST.xy + _MetalNormalMap_ST.zw;
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float4 tex2DNode20 = tex2D( _Mask, uv_Mask );
			float3 lerpResult9 = lerp( tex2DNode2 , UnpackNormal( tex2D( _MetalNormalMap, uv_MetalNormalMap ) ) , tex2DNode20.r);
			o.Normal = lerpResult9;
			float2 uv_AlbedoMap = i.uv_texcoord * _AlbedoMap_ST.xy + _AlbedoMap_ST.zw;
			float2 uv_MetalAlbedoMap = i.uv_texcoord * _MetalAlbedoMap_ST.xy + _MetalAlbedoMap_ST.zw;
			float4 lerpResult6 = lerp( tex2D( _AlbedoMap, uv_AlbedoMap ) , tex2D( _MetalAlbedoMap, uv_MetalAlbedoMap ) , tex2DNode20.r);
			o.Albedo = lerpResult6.rgb;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float4 lerpResult32 = lerp( float4( 0,0,0,0 ) , ( tex2D( _EmissionMap, uv_EmissionMap ) * _EmissionIntensity ) , ( ( 1.0 - tex2DNode20.r ) * ( 1.0 - tex2DNode2.b ) ));
			o.Emission = lerpResult32.rgb;
			float lerpResult21 = lerp( _RockMetallic , _MetalMetallic , tex2DNode20.r);
			o.Metallic = lerpResult21;
			float lerpResult22 = lerp( _RockSmoothness , _MetalSmoothness , tex2DNode20.r);
			o.Smoothness = lerpResult22;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
0;73;1070;602;2286.728;1057.698;1.699967;True;False
Node;AmplifyShaderEditor.SamplerNode;20;-1385.742,-1330.928;Inherit;True;Property;_Mask;Mask;4;0;Create;True;0;0;False;0;-1;None;84508b93f15f2b64386ec07486afc7a3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1764.885,-1011.432;Inherit;True;Property;_NormalMap;Normal Map;1;0;Create;True;0;0;False;0;-1;None;0bebe40e9ebbecc48b8e9cfea982da7e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;36;-1778.486,-258.7559;Inherit;False;Property;_EmissionIntensity;Emission Intensity;10;0;Create;True;0;0;False;0;0;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-1935.338,-562.779;Inherit;True;Property;_EmissionMap;Emission Map;9;0;Create;True;0;0;False;0;-1;None;f7e96904e8667e1439548f0f86389447;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;33;-1409.502,-743.5548;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;35;-1132.334,-369.7061;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-784,-1648;Inherit;True;Property;_AlbedoMap;Albedo Map;0;0;Create;True;0;0;False;0;-1;b297077dae62c1944ba14cad801cddf5;b297077dae62c1944ba14cad801cddf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-1764.885,-819.432;Inherit;True;Property;_MetalNormalMap;Metal Normal Map;3;0;Create;True;0;0;False;0;-1;None;bd734c29baceb63499732f24fbaea45f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1481.406,-510.8239;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-688,304;Inherit;False;Property;_MetalSmoothness;Metal Smoothness;8;0;Create;True;0;0;False;0;0.2;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-688,48;Inherit;False;Property;_MetalMetallic;Metal Metallic;6;0;Create;True;0;0;False;0;0;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-688,224;Inherit;False;Property;_RockSmoothness;Rock Smoothness;7;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-831.0498,-367.301;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-784,-1456;Inherit;True;Property;_MetalAlbedoMap;Metal Albedo Map;2;0;Create;True;0;0;False;0;-1;None;bea7fa376f932ba419f3d1fc95bd1a2b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;25;-688,-32;Inherit;False;Property;_RockMetallic;Rock Metallic;5;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;21;-224,0;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;-384,-1360;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;32;-148.4757,-509.6372;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;9;-384,-1024;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;22;-208,256;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;359.8,-147.5;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Tutorial_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;33;0;2;3
WireConnection;35;0;20;1
WireConnection;37;0;31;0
WireConnection;37;1;36;0
WireConnection;34;0;35;0
WireConnection;34;1;33;0
WireConnection;21;0;25;0
WireConnection;21;1;27;0
WireConnection;21;2;20;1
WireConnection;6;0;1;0
WireConnection;6;1;5;0
WireConnection;6;2;20;1
WireConnection;32;1;37;0
WireConnection;32;2;34;0
WireConnection;9;0;2;0
WireConnection;9;1;8;0
WireConnection;9;2;20;1
WireConnection;22;0;28;0
WireConnection;22;1;29;0
WireConnection;22;2;20;1
WireConnection;0;0;6;0
WireConnection;0;1;9;0
WireConnection;0;2;32;0
WireConnection;0;3;21;0
WireConnection;0;4;22;0
ASEEND*/
//CHKSM=5A84A08732CE49315313E4E7DFA5568A17B5FEB6