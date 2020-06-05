// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "LowPolyWaterShallowStopped_Shader"
{
	Properties
	{
		_DeepColour("Deep Colour", Color) = (0,0,0,0)
		_ShallowColour("Shallow Colour", Color) = (0,0,0,0)
		_WaterNormalMap("Water Normal Map", 2D) = "bump" {}
		_DistortionStrength("Distortion Strength", Float) = 0
		_NormalMapStrength("Normal Map Strength", Float) = 0.2
		_WaterDepth("Water Depth", Float) = 0
		_WaterFalloff("Water Falloff", Float) = 0
		_AmbientOcclusion("Ambient Occlusion", Range( -2 , 2)) = 0
		_FoamDepth("Foam Depth", Float) = 0
		_FoamFalloff("Foam Falloff", Float) = 0
		_FoamTextureMap("Foam Texture Map", 2D) = "white" {}
		_WaterSpecular("Water Specular", Float) = 0
		_FoamSpecular("Foam Specular", Float) = 0
		_WaterSmoothness("Water Smoothness", Float) = 0
		_FoamSmoothness("Foam Smoothness", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf StandardSpecular keepalpha 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _WaterNormalMap;
		uniform half _NormalMapStrength;
		uniform half4 _ShallowColour;
		uniform half4 _DeepColour;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform half _WaterDepth;
		uniform half _WaterFalloff;
		uniform half _FoamDepth;
		uniform half _FoamFalloff;
		uniform sampler2D _FoamTextureMap;
		uniform float4 _FoamTextureMap_ST;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform half _DistortionStrength;
		uniform half _WaterSpecular;
		uniform half _FoamSpecular;
		uniform half _WaterSmoothness;
		uniform half _FoamSmoothness;
		uniform half _AmbientOcclusion;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			half2 panner10 = ( 1.0 * _Time.y * float2( 0,-0.01 ) + i.uv_texcoord);
			half2 panner11 = ( 1.0 * _Time.y * float2( 0,-0.02 ) + i.uv_texcoord);
			half3 temp_output_15_0 = BlendNormals( UnpackNormal( tex2D( _WaterNormalMap, panner10 ) ) , UnpackScaleNormal( tex2D( _WaterNormalMap, panner11 ), _NormalMapStrength ) );
			o.Normal = temp_output_15_0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			half eyeDepth2 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			half temp_output_4_0 = abs( ( eyeDepth2 - ase_screenPos.w ) );
			half temp_output_31_0 = saturate( pow( ( temp_output_4_0 + _WaterDepth ) , _WaterFalloff ) );
			half4 lerpResult8 = lerp( _ShallowColour , _DeepColour , temp_output_31_0);
			half4 color36 = IsGammaSpace() ? half4(1,1,1,0) : half4(1,1,1,0);
			float2 uv0_FoamTextureMap = i.uv_texcoord * _FoamTextureMap_ST.xy + _FoamTextureMap_ST.zw;
			half2 panner42 = ( 1.0 * _Time.y * float2( -0.1,0.1 ) + uv0_FoamTextureMap);
			half temp_output_45_0 = ( saturate( pow( ( temp_output_4_0 + _FoamDepth ) , _FoamFalloff ) ) * tex2D( _FoamTextureMap, panner42 ).r );
			half4 lerpResult35 = lerp( lerpResult8 , color36 , temp_output_45_0);
			half2 appendResult18 = (half2(ase_screenPosNorm.x , ase_screenPosNorm.y));
			half4 screenColor17 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( half3( ( appendResult18 / ase_screenPosNorm.w ) ,  0.0 ) + ( _DistortionStrength * temp_output_15_0 ) ).xy);
			half4 lerpResult23 = lerp( lerpResult35 , screenColor17 , temp_output_31_0);
			o.Albedo = lerpResult23.rgb;
			half lerpResult48 = lerp( _WaterSpecular , _FoamSpecular , temp_output_45_0);
			half3 temp_cast_3 = (lerpResult48).xxx;
			o.Specular = temp_cast_3;
			half lerpResult51 = lerp( _WaterSmoothness , _FoamSmoothness , temp_output_45_0);
			o.Smoothness = lerpResult51;
			o.Occlusion = _AmbientOcclusion;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
2560;90;1920;1058;4683.659;33.10056;1.194897;True;False
Node;AmplifyShaderEditor.ScreenPosInputsNode;44;-2784,-128;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;2;-2560,-128;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1;-2816,64;Float;True;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-2352,-48;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-4528,368;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;4;-2144,-48;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2208,640;Inherit;True;Property;_FoamDepth;Foam Depth;8;0;Create;True;0;0;False;0;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;10;-4176,304;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.01;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1968,16;Inherit;True;Property;_WaterDepth;Water Depth;5;0;Create;True;0;0;False;0;0;-4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;11;-4176,640;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-0.02;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-4064,896;Inherit;False;Property;_NormalMapStrength;Normal Map Strength;4;0;Create;True;0;0;False;0;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;16;-3344,-768;Float;True;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;30;-1760,16;Inherit;True;Property;_WaterFalloff;Water Falloff;6;0;Create;True;0;0;False;0;0;-1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-3792,640;Inherit;True;Property;_WaterNormalMap;Water Normal Map;2;0;Create;True;0;0;False;0;-1;None;ec99ae2a9a160514aa854d65810dafb2;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-2048,1120;Inherit;True;0;43;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1776,-240;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1984,864;Inherit;True;Property;_FoamFalloff;Foam Falloff;9;0;Create;True;0;0;False;0;0;-60;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-1984,624;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-3792,304;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Instance;12;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;29;-1536,-224;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-3024,-512;Inherit;True;Property;_DistortionStrength;Distortion Strength;3;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;38;-1728,624;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;42;-1744,1120;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.1,0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-2960,-960;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendNormalsNode;15;-3328,432;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;6;-1600,-448;Inherit;False;Property;_DeepColour;Deep Colour;0;0;Create;True;0;0;False;0;0,0,0,0;0.02352941,0.4078422,0.6352941,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-1600,-672;Inherit;False;Property;_ShallowColour;Shallow Colour;1;0;Create;True;0;0;False;0;0,0,0,0;0.01568628,0.5568628,0.4627448,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-2720,-496;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;40;-1472,624;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;19;-2704,-752;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;43;-1408,1120;Inherit;True;Property;_FoamTextureMap;Foam Texture Map;10;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;31;-1280,-224;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-2448,-576;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;8;-1200,-560;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1137.15,658.8068;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;36;-1152,368;Inherit;False;Constant;_Color0;Color 0;8;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;53;-480,736;Inherit;False;Property;_FoamSmoothness;Foam Smoothness;14;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-640,336;Inherit;False;Property;_FoamSpecular;Foam Specular;12;0;Create;True;0;0;False;0;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;17;-2192,-768;Inherit;False;Global;_GrabScreen0;Grab Screen 0;3;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;35;-883.5396,363.8744;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-608,224;Inherit;False;Property;_WaterSpecular;Water Specular;11;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-365.6392,637.5281;Inherit;False;Property;_WaterSmoothness;Water Smoothness;13;0;Create;True;0;0;False;0;0;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;23;-640,-800;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-384,160;Inherit;False;Property;_AmbientOcclusion;Ambient Occlusion;7;0;Create;True;0;0;False;0;0;0.6;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;48;-405.6392,370.5281;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;51;-256,960;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Half;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;LowPolyWaterShallowStopped_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Translucent;0.5;True;False;0;False;Opaque;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;2;0;44;0
WireConnection;3;0;2;0
WireConnection;3;1;1;4
WireConnection;4;0;3;0
WireConnection;10;0;9;0
WireConnection;11;0;9;0
WireConnection;12;1;11;0
WireConnection;12;5;14;0
WireConnection;28;0;4;0
WireConnection;28;1;27;0
WireConnection;33;0;4;0
WireConnection;33;1;37;0
WireConnection;13;1;10;0
WireConnection;29;0;28;0
WireConnection;29;1;30;0
WireConnection;38;0;33;0
WireConnection;38;1;39;0
WireConnection;42;0;41;0
WireConnection;18;0;16;1
WireConnection;18;1;16;2
WireConnection;15;0;13;0
WireConnection;15;1;12;0
WireConnection;21;0;20;0
WireConnection;21;1;15;0
WireConnection;40;0;38;0
WireConnection;19;0;18;0
WireConnection;19;1;16;4
WireConnection;43;1;42;0
WireConnection;31;0;29;0
WireConnection;22;0;19;0
WireConnection;22;1;21;0
WireConnection;8;0;7;0
WireConnection;8;1;6;0
WireConnection;8;2;31;0
WireConnection;45;0;40;0
WireConnection;45;1;43;1
WireConnection;17;0;22;0
WireConnection;35;0;8;0
WireConnection;35;1;36;0
WireConnection;35;2;45;0
WireConnection;23;0;35;0
WireConnection;23;1;17;0
WireConnection;23;2;31;0
WireConnection;48;0;49;0
WireConnection;48;1;50;0
WireConnection;48;2;45;0
WireConnection;51;0;52;0
WireConnection;51;1;53;0
WireConnection;51;2;45;0
WireConnection;0;0;23;0
WireConnection;0;1;15;0
WireConnection;0;3;48;0
WireConnection;0;4;51;0
WireConnection;0;5;32;0
ASEEND*/
//CHKSM=696D0071D3B8DF9A363D4B0DFC90429A4E4534C9