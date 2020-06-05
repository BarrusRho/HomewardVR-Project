// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water_Shader"
{
	Properties
	{
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalMap1Strength("Normal Map 1 Strength", Range( 0 , 1)) = 1
		_NormalMap2Strength("Normal Map 2 Strength", Range( 0 , 1)) = 1
		_NormalBlendStrength("Normal Blend Strength", Range( 0 , 1)) = 1
		_UVScale("UV Scale", Float) = 1
		_UV1Tiling("UV 1 Tiling", Float) = 1
		_UV2Tiling("UV 2 Tiling", Float) = 1
		_ColourDeep("Colour (Deep)", Color) = (0,0.2901961,0.2313726,1)
		_ColourShallow("Colour (Shallow)", Color) = (0,0,0,0)
		_UV1AnimationSpeed("UV 1 Animation Speed", Vector) = (0,0,0,0)
		_UV2AnimationSpeed("UV 2 Animation Speed", Vector) = (0,0,0,0)
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_Metalness("Metalness", Range( 0 , 1)) = 0.2
		_FresnelPower("Fresnel Power", Float) = 5
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float3 worldPos;
			INTERNAL_DATA
		};

		uniform sampler2D _NormalMap;
		uniform float _NormalMap1Strength;
		uniform float2 _UV1AnimationSpeed;
		uniform float _UVScale;
		uniform float _UV1Tiling;
		uniform float _NormalMap2Strength;
		uniform float2 _UV2AnimationSpeed;
		uniform float _UV2Tiling;
		uniform float _NormalBlendStrength;
		uniform float4 _ColourDeep;
		uniform float4 _ColourShallow;
		uniform float _FresnelPower;
		uniform float _Metalness;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult2 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 _WorldUV5 = ( appendResult2 / _UVScale );
			float2 panner27 = ( _Time.x * _UV1AnimationSpeed + ( _WorldUV5 * _UV1Tiling ));
			float2 _UV135 = panner27;
			float2 panner28 = ( _Time.x * _UV2AnimationSpeed + ( _WorldUV5 * _UV2Tiling ));
			float2 _UV236 = panner28;
			float3 lerpResult10 = lerp( UnpackScaleNormal( tex2D( _NormalMap, _UV135 ), _NormalMap1Strength ) , UnpackScaleNormal( tex2D( _NormalMap, _UV236 ), _NormalMap2Strength ) , _NormalBlendStrength);
			float3 _NormalMap17 = lerpResult10;
			o.Normal = _NormalMap17;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV19 = dot( _NormalMap17, ase_worldViewDir );
			float fresnelNode19 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV19, _FresnelPower ) );
			float4 lerpResult16 = lerp( _ColourDeep , _ColourShallow , fresnelNode19);
			float4 _Colour21 = lerpResult16;
			o.Albedo = _Colour21.rgb;
			o.Metallic = _Metalness;
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
7;7;1906;1004;1831.16;1280.992;1.031816;True;True
Node;AmplifyShaderEditor.CommentaryNode;6;-1264,-1920;Inherit;False;1013;405;World UV;5;1;2;3;4;5;World UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1216,-1872;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;4;-928,-1632;Inherit;False;Property;_UVScale;UV Scale;5;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;2;-976,-1872;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;3;-736,-1872;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;39;-2050,-549.4604;Inherit;False;1434.669;1230.992;UV1 & UV2;12;29;25;30;26;27;28;32;31;34;33;35;36;UV1 & UV2;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-496,-1872;Inherit;True;_WorldUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1680,192;Inherit;False;Property;_UV2Tiling;UV 2 Tiling;7;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1712,-352;Inherit;False;Property;_UV1Tiling;UV 1 Tiling;6;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-1968,-432;Inherit;True;5;_WorldUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1518.429,-499.4604;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;26;-2000,-64;Inherit;True;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;33;-1511.086,377.5321;Inherit;True;Property;_UV2AnimationSpeed;UV 2 Animation Speed;11;0;Create;True;0;0;False;0;0,0;1,-0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;34;-1523.616,-236.1995;Inherit;True;Property;_UV1AnimationSpeed;UV 1 Animation Speed;10;0;Create;True;0;0;False;0;0,0;1,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1504,128;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;28;-1156.022,9.937052;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;27;-1184.553,-410.829;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;23;-16,-1408;Inherit;False;1461;741;Normal Map;10;11;9;13;10;17;12;8;7;37;38;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-858.3314,-376.2594;Inherit;True;_UV1;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-864.8157,12.79633;Inherit;True;_UV2;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;56.18274,-1272.11;Inherit;False;35;_UV1;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;96,-1152;Inherit;True;Property;_NormalMap;Normal Map;1;0;Create;True;0;0;False;0;dd2fd2df93418444c8e280f1d34deeb5;dd2fd2df93418444c8e280f1d34deeb5;True;bump;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;109.1827,-900.11;Inherit;False;36;_UV2;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;55,-772;Inherit;False;Property;_NormalMap2Strength;Normal Map 2 Strength;3;0;Create;True;0;0;False;0;1;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;49,-1359;Inherit;False;Property;_NormalMap1Strength;Normal Map 1 Strength;2;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;400,-1360;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;400,-976;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;544,-784;Inherit;False;Property;_NormalBlendStrength;Normal Blend Strength;4;0;Create;True;0;0;False;0;1;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;10;928,-1168;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;17;1200,-1168;Inherit;True;_NormalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1536,-1408;Inherit;False;1285;783;Colour;7;20;15;14;16;21;19;42;Colour;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-1446.765,-763.7188;Inherit;False;Property;_FresnelPower;Fresnel Power;14;0;Create;True;0;0;False;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;20;-1488,-1008;Inherit;True;17;_NormalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;15;-1088,-1056;Inherit;False;Property;_ColourShallow;Colour (Shallow);9;0;Create;True;0;0;False;0;0,0,0,0;0.4196078,0.7882354,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;14;-1088,-1344;Inherit;False;Property;_ColourDeep;Colour (Deep);8;0;Create;True;0;0;False;0;0,0.2901961,0.2313726,1;0,0.2901959,0.2313724,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;19;-1184,-864;Inherit;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;16;-784,-1216;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-496,-1216;Inherit;True;_Colour;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-450,-192;Inherit;True;17;_NormalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-343.7682,325.4182;Inherit;False;Property;_Smoothness;Smoothness;12;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-343.7682,58.41821;Inherit;False;Property;_Metalness;Metalness;13;0;Create;True;0;0;False;0;0.2;0.512;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;22;-305,-416;Inherit;True;21;_Colour;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Water_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;1;1
WireConnection;2;1;1;3
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;5;0;3;0
WireConnection;29;0;25;0
WireConnection;29;1;30;0
WireConnection;32;0;25;0
WireConnection;32;1;31;0
WireConnection;28;0;32;0
WireConnection;28;2;33;0
WireConnection;28;1;26;1
WireConnection;27;0;29;0
WireConnection;27;2;34;0
WireConnection;27;1;26;1
WireConnection;35;0;27;0
WireConnection;36;0;28;0
WireConnection;7;0;9;0
WireConnection;7;1;37;0
WireConnection;7;5;11;0
WireConnection;8;0;9;0
WireConnection;8;1;38;0
WireConnection;8;5;12;0
WireConnection;10;0;7;0
WireConnection;10;1;8;0
WireConnection;10;2;13;0
WireConnection;17;0;10;0
WireConnection;19;0;20;0
WireConnection;19;3;42;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;16;2;19;0
WireConnection;21;0;16;0
WireConnection;0;0;22;0
WireConnection;0;1;18;0
WireConnection;0;3;41;0
WireConnection;0;4;40;0
ASEEND*/
//CHKSM=F5B751F90FAFC595143A1B749739F9723CD997D3