// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AdvancedBurning_Shader"
{
	Properties
	{
		_AlbedoMap("Albedo Map", 2D) = "white" {}
		_CloudTextureMask("Cloud Texture Mask", 2D) = "white" {}
		_DistortionMap("Distortion Map", 2D) = "bump" {}
		_DistortionStrength("Distortion Strength", Range( 0 , 1)) = 0
		_ScrollSpeed("Scroll Speed", Range( 0 , 1)) = 0
		_WarmColour("Warm Colour", Color) = (0,0,0,0)
		_HotColour("Hot Colour", Color) = (0,0,0,0)
		_BurnStrength("Burn Strength", Range( 0 , 1)) = 0.33
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		AlphaToMask On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _AlbedoMap;
		uniform float4 _AlbedoMap_ST;
		uniform float4 _WarmColour;
		uniform float4 _HotColour;
		uniform sampler2D _CloudTextureMask;
		uniform sampler2D _DistortionMap;
		uniform float4 _DistortionMap_ST;
		uniform float _DistortionStrength;
		uniform float _ScrollSpeed;
		uniform float4 _CloudTextureMask_ST;
		uniform float _BurnStrength;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_AlbedoMap = i.uv_texcoord * _AlbedoMap_ST.xy + _AlbedoMap_ST.zw;
			o.Albedo = tex2D( _AlbedoMap, uv_AlbedoMap ).rgb;
			float2 uv_DistortionMap = i.uv_texcoord * _DistortionMap_ST.xy + _DistortionMap_ST.zw;
			float2 panner11 = ( ( _Time.y * _ScrollSpeed ) * float2( 0,-1 ) + float2( 0,0 ));
			float2 uv_TexCoord9 = i.uv_texcoord + panner11;
			float4 lerpResult17 = lerp( _WarmColour , _HotColour , tex2D( _CloudTextureMask, ( ( (UnpackNormal( tex2D( _DistortionMap, uv_DistortionMap ) )).xy * _DistortionStrength ) + uv_TexCoord9 ) ).r);
			float4 temp_cast_1 = (2.0).xxxx;
			float2 uv_CloudTextureMask = i.uv_texcoord * _CloudTextureMask_ST.xy + _CloudTextureMask_ST.zw;
			float4 tex2DNode22 = tex2D( _CloudTextureMask, uv_CloudTextureMask );
			float temp_output_23_0 = step( tex2DNode22.r , _BurnStrength );
			o.Emission = ( ( pow( lerpResult17 , temp_cast_1 ) * 2.0 ) * ( temp_output_23_0 + ( temp_output_23_0 - step( tex2DNode22.r , ( _BurnStrength / 1.1 ) ) ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
0;726;1068;274;1940.175;153.0676;2.085087;True;False
Node;AmplifyShaderEditor.RangedFloatNode;14;-2512,192;Inherit;False;Property;_ScrollSpeed;Scroll Speed;5;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-2576,-624;Inherit;True;Property;_DistortionMap;Distortion Map;3;0;Create;True;0;0;False;0;None;001e97c19eee9a84bb18893d904e6283;True;bump;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleTimeNode;12;-2400,96;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-2304,-544;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2208,128;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;6;-1968,-448;Inherit;True;True;True;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-2000,-224;Inherit;False;Property;_DistortionStrength;Distortion Strength;4;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;11;-1984,32;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1680,-320;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1696,-64;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;2;-1552,-624;Inherit;True;Property;_CloudTextureMask;Cloud Texture Mask;2;0;Create;True;0;0;False;0;None;388e49192d7938d41b22ac684b1e3e99;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1232,160;Inherit;False;Constant;_DivideStrength;Divide Strength;8;0;Create;True;0;0;False;0;1.1;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1232,0;Inherit;False;Property;_BurnStrength;Burn Strength;8;0;Create;True;0;0;False;0;0.33;0.35;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-1408,-240;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;15;-1136,-1008;Inherit;False;Property;_WarmColour;Warm Colour;6;0;Create;True;0;0;False;0;0,0,0,0;0.9764706,0.7019608,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-1184,-208;Inherit;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;28;-992,240;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1200,-496;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;16;-1136,-816;Inherit;False;Property;_HotColour;Hot Colour;7;0;Create;True;0;0;False;0;0,0,0,0;1,0.909804,0.01176471,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;17;-816,-912;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-752,-672;Inherit;True;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;27;-752,240;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;23;-832,-208;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;19;-496,-1040;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;30;-512,-32;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-180.0162,-146.7632;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-176,-656;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;26;576,-448;Inherit;True;Property;_AlbedoMap;Albedo Map;0;0;Create;True;0;0;False;0;-1;None;7130c16fd8005b546b111d341310a9a4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;128,-336;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;898,104;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AdvancedBurning_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;4;0
WireConnection;13;0;12;0
WireConnection;13;1;14;0
WireConnection;6;0;5;0
WireConnection;11;1;13;0
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;9;1;11;0
WireConnection;10;0;7;0
WireConnection;10;1;9;0
WireConnection;22;0;2;0
WireConnection;28;0;24;0
WireConnection;28;1;29;0
WireConnection;3;0;2;0
WireConnection;3;1;10;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;17;2;3;1
WireConnection;27;0;22;1
WireConnection;27;1;28;0
WireConnection;23;0;22;1
WireConnection;23;1;24;0
WireConnection;19;0;17;0
WireConnection;19;1;21;0
WireConnection;30;0;23;0
WireConnection;30;1;27;0
WireConnection;31;0;23;0
WireConnection;31;1;30;0
WireConnection;20;0;19;0
WireConnection;20;1;21;0
WireConnection;25;0;20;0
WireConnection;25;1;31;0
WireConnection;0;0;26;0
WireConnection;0;2;25;0
ASEEND*/
//CHKSM=339EE50FCFBD15CB21E55EB46D5EC1442540DAD4