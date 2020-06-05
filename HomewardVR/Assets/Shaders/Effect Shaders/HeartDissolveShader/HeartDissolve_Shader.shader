// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HeartDissolve_Shader"
{
	Properties
	{
		_Metallic("Metallic", Range( 0 , 1)) = 0.2
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.2
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_RampTextureMap("Ramp Texture Map", 2D) = "white" {}
		_EmissionIntensity("Emission Intensity", Float) = 0
		_RampUVScale("Ramp UV Scale", Float) = 0
		_MaskTexture("Mask Texture", 2D) = "white" {}
		_UVLerp("UV Lerp", Range( 0 , 1)) = 0
		_PannerSpeed("Panner Speed", Vector) = (0,0,0,0)
		[HDR]_ColourMap("Colour Map", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _ColourMap;
		uniform sampler2D _RampTextureMap;
		uniform sampler2D _MaskTexture;
		uniform float2 _PannerSpeed;
		uniform float _UVLerp;
		uniform float _RampUVScale;
		uniform float _EmissionIntensity;
		uniform float _Metallic;
		uniform float _Smoothness;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _ColourMap.rgb;
			float2 panner23 = ( _Time.y * _PannerSpeed + i.uv_texcoord);
			float2 temp_cast_1 = (tex2D( _MaskTexture, panner23 ).r).xx;
			float2 lerpResult21 = lerp( i.uv_texcoord , temp_cast_1 , _UVLerp);
			float temp_output_7_0 = ( tex2D( _MaskTexture, lerpResult21 ).r - _SinTime.z );
			float2 temp_cast_2 = (( 1.0 - saturate( (( _RampUVScale * -1.0 ) + (temp_output_7_0 - 0.0) * (_RampUVScale - ( _RampUVScale * -1.0 )) / (1.0 - 0.0)) ) )).xx;
			o.Emission = ( tex2D( _RampTextureMap, temp_cast_2 ) * _EmissionIntensity ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
			clip( temp_output_7_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
2560;90;1920;1058;3122.035;291.7979;1.478831;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-3520,256;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;24;-3488,896;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;26;-3488,640;Inherit;False;Property;_PannerSpeed;Panner Speed;11;0;Create;True;0;0;False;0;0,0;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;23;-3168,640;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;17;-3152,-48;Inherit;True;Property;_MaskTexture;Mask Texture;9;0;Create;True;0;0;False;0;None;e28dc97a9541e3642a48c0e3886688c5;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2848,832;Inherit;False;Property;_UVLerp;UV Lerp;10;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;19;-2864,640;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;21;-2480,432;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinTimeNode;27;-2448,768;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-2048,-64;Inherit;False;Property;_RampUVScale;Ramp UV Scale;8;0;Create;True;0;0;False;0;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-2212.017,195.7276;Inherit;True;Property;_TextureMaskMap;Texture Mask Map;4;0;Create;True;0;0;False;0;-1;None;e28dc97a9541e3642a48c0e3886688c5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1728,-240;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;7;-1860.016,259.7275;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;12;-1443.74,-146.9992;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;15;-1248,-144;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;16;-1056,-144;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-688,32;Inherit;False;Property;_EmissionIntensity;Emission Intensity;7;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-768,-160;Inherit;True;Property;_RampTextureMap;Ramp Texture Map;6;0;Create;True;0;0;False;0;-1;None;64e7766099ad46747a07014e44d0aea1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;-352,-672;Inherit;False;Property;_ColourMap;Colour Map;12;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2.996078,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-784,-432;Inherit;True;Property;_NormalMap;Normal Map;1;0;Create;True;0;0;False;0;-1;None;0bebe40e9ebbecc48b8e9cfea982da7e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;400,160;Inherit;False;Property;_Metallic;Metallic;2;0;Create;True;0;0;False;0;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2196.017,387.7275;Inherit;False;Property;_OpacityMask;Opacity Mask;5;0;Create;True;0;0;False;0;0;-0.5;-0.7;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;400,240;Inherit;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;False;0;0.2;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-445.0008,-102.8516;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1;-784,-688;Inherit;True;Property;_AlbedoMap;Albedo Map;0;0;Create;True;0;0;False;0;-1;None;b297077dae62c1944ba14cad801cddf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;28;-2208,768;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-0.8;False;4;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;6,50;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;HeartDissolve_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;4;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;23;0;20;0
WireConnection;23;2;26;0
WireConnection;23;1;24;0
WireConnection;19;0;17;0
WireConnection;19;1;23;0
WireConnection;21;0;20;0
WireConnection;21;1;19;1
WireConnection;21;2;22;0
WireConnection;6;0;17;0
WireConnection;6;1;21;0
WireConnection;14;0;13;0
WireConnection;7;0;6;1
WireConnection;7;1;27;3
WireConnection;12;0;7;0
WireConnection;12;3;14;0
WireConnection;12;4;13;0
WireConnection;15;0;12;0
WireConnection;16;0;15;0
WireConnection;8;1;16;0
WireConnection;11;0;8;0
WireConnection;11;1;10;0
WireConnection;28;0;27;3
WireConnection;0;0;29;0
WireConnection;0;2;11;0
WireConnection;0;3;3;0
WireConnection;0;4;4;0
WireConnection;0;10;7;0
ASEEND*/
//CHKSM=794A55AAC075C3B6196DFA00F00A84524BF04E44