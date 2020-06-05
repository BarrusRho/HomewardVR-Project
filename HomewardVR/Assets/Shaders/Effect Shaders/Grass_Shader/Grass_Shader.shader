// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Grass_Shader"
{
	Properties
	{
		_GrassColour("Grass Colour", Color) = (0,0,0,0)
		_Metalness("Metalness", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_WindSpeed("Wind Speed", Float) = 0
		_WindStrength("Wind Strength", Float) = 0
		_HeightMask("Height Mask", Float) = 0
		_WindWaveScale("Wind Wave Scale", Float) = 0
		_NoiseTextureMap("Noise Texture Map", 2D) = "white" {}
		_MaskScrollSpeed("Mask Scroll Speed", Float) = 0
		_NoiseUVScale("Noise UV Scale", Float) = 0
		_ObjectPosition("Object Position", Vector) = (0,0,0,0)
		_ObjectRadius("Object Radius", Float) = 0
		_ObjectPushStrength("Object Push Strength", Range( 0 , 1)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform float _WindSpeed;
		uniform float _WindWaveScale;
		uniform float _WindStrength;
		uniform float _HeightMask;
		uniform sampler2D _NoiseTextureMap;
		uniform float _MaskScrollSpeed;
		uniform float _NoiseUVScale;
		uniform float _ObjectPushStrength;
		uniform float3 _ObjectPosition;
		uniform float _ObjectRadius;
		uniform float4 _GrassColour;
		uniform float _Metalness;
		uniform float _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float mulTime5 = _Time.y * _WindSpeed;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float temp_output_15_0 = saturate( ( ase_worldPos.y * _HeightMask ) );
			float temp_output_16_0 = ( temp_output_15_0 * temp_output_15_0 );
			float2 appendResult26 = (float2(_MaskScrollSpeed , 0.0));
			float2 appendResult22 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 panner24 = ( _Time.y * appendResult26 + ( appendResult22 * _NoiseUVScale ));
			float3 appendResult9 = (float3(( sin( ( mulTime5 + ( ase_worldPos.x * _WindWaveScale ) ) ) * _WindStrength * temp_output_16_0 * (-1.0 + (tex2Dlod( _NoiseTextureMap, float4( panner24, 0, 0.0) ).r - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) , 0.0 , 0.0));
			float3 GrassSway30 = appendResult9;
			float temp_output_40_0 = ( 1.0 - saturate( ( distance( ase_worldPos , _ObjectPosition ) / _ObjectRadius ) ) );
			float3 lerpResult49 = lerp( GrassSway30 , ( ( _ObjectPushStrength * ( ase_worldPos - _ObjectPosition ) ) * temp_output_40_0 * float3(1,0,1) * temp_output_16_0 ) , temp_output_40_0);
			v.vertex.xyz += lerpResult49;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _GrassColour.rgb;
			o.Metallic = _Metalness;
			o.Smoothness = _Smoothness;
			float3 ase_worldPos = i.worldPos;
			float temp_output_15_0 = saturate( ( ase_worldPos.y * _HeightMask ) );
			float temp_output_16_0 = ( temp_output_15_0 * temp_output_15_0 );
			o.Occlusion = temp_output_16_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
1281;641;1272;730;3160.323;391.4642;3.296564;True;False
Node;AmplifyShaderEditor.CommentaryNode;32;-3664,-624;Inherit;False;2382.7;2127;Grass Sway;25;21;29;25;22;14;27;26;19;28;6;7;18;5;13;24;15;17;20;11;23;16;4;12;9;30;Grass Sway;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;21;-3616,560;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;29;-3312,784;Inherit;True;Property;_NoiseUVScale;Noise UV Scale;9;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-3360,1008;Inherit;True;Property;_MaskScrollSpeed;Mask Scroll Speed;8;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-3344,560;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2960,-112;Inherit;True;Property;_WindWaveScale;Wind Wave Scale;6;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-3072,688;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;27;-3056,1248;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-2864,496;Inherit;True;Property;_HeightMask;Height Mask;5;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;7;-3328,-96;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;6;-2896,-544;Inherit;True;Property;_WindSpeed;Wind Speed;3;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;-3104,1008;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;33;-2515.299,1574.15;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;24;-2736,864;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;34;-2483.298,1862.15;Inherit;True;Property;_ObjectPosition;Object Position;10;0;Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;5;-2720,-544;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-2736,-304;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2672,400;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;36;-2179.3,1926.15;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;15;-2448,416;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-2496,-544;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-2163.299,2150.15;Inherit;True;Property;_ObjectRadius;Object Radius;11;0;Create;True;0;0;False;0;0;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-2480,864;Inherit;True;Property;_NoiseTextureMap;Noise Texture Map;7;0;Create;True;0;0;False;0;-1;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;37;-1923.299,1926.15;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;23;-2096,816;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;4;-2112,-80;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-2240,416;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2240,176;Inherit;True;Property;_WindStrength;Wind Strength;4;0;Create;True;0;0;False;0;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-2179.3,1590.15;Inherit;False;Property;_ObjectPushStrength;Object Push Strength;12;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-2179.3,1702.15;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1904,32;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;39;-1699.299,1926.15;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-1507.299,1926.15;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1875.299,1702.15;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-1648,48;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;43;-1427.299,2150.15;Inherit;False;Constant;_Vector0;Vector 0;12;0;Create;True;0;0;False;0;1,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1024,1792;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;30;-1424,48;Inherit;False;GrassSway;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-320,160;Inherit;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;False;0;0;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-208,272;Inherit;False;30;GrassSway;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;49;-768,1216;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;1;-464,-416;Inherit;False;Property;_GrassColour;Grass Colour;0;0;Create;True;0;0;False;0;0,0,0,0;0.3686271,0.8039216,0.3960782,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-320,64;Inherit;False;Property;_Metalness;Metalness;1;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Grass_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;21;1
WireConnection;22;1;21;3
WireConnection;28;0;22;0
WireConnection;28;1;29;0
WireConnection;26;0;25;0
WireConnection;24;0;28;0
WireConnection;24;2;26;0
WireConnection;24;1;27;0
WireConnection;5;0;6;0
WireConnection;18;0;7;1
WireConnection;18;1;19;0
WireConnection;13;0;7;2
WireConnection;13;1;14;0
WireConnection;36;0;33;0
WireConnection;36;1;34;0
WireConnection;15;0;13;0
WireConnection;17;0;5;0
WireConnection;17;1;18;0
WireConnection;20;1;24;0
WireConnection;37;0;36;0
WireConnection;37;1;38;0
WireConnection;23;0;20;1
WireConnection;4;0;17;0
WireConnection;16;0;15;0
WireConnection;16;1;15;0
WireConnection;35;0;33;0
WireConnection;35;1;34;0
WireConnection;12;0;4;0
WireConnection;12;1;11;0
WireConnection;12;2;16;0
WireConnection;12;3;23;0
WireConnection;39;0;37;0
WireConnection;40;0;39;0
WireConnection;45;0;44;0
WireConnection;45;1;35;0
WireConnection;9;0;12;0
WireConnection;41;0;45;0
WireConnection;41;1;40;0
WireConnection;41;2;43;0
WireConnection;41;3;16;0
WireConnection;30;0;9;0
WireConnection;49;0;30;0
WireConnection;49;1;41;0
WireConnection;49;2;40;0
WireConnection;0;0;1;0
WireConnection;0;3;2;0
WireConnection;0;4;3;0
WireConnection;0;5;16;0
WireConnection;0;11;49;0
ASEEND*/
//CHKSM=0CB3ECD6502251CEE766DD4E022759B068D10562