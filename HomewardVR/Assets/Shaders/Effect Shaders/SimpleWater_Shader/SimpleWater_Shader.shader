// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SimpleWater_Shader"
{
	Properties
	{
		[HDR]_Base_Colour("Base_Colour", Color) = (0,0.5176471,1,1)
		_Ripples_Speed("Ripples_Speed", Float) = 0.01
		[HDR]_Ripples_Colour("Ripples_Colour", Color) = (0.3515327,0.9301112,1,1)
		_Ripples_Scale("Ripples_Scale", Float) = 1
		_Ripples_Dissolve("Ripples_Dissolve", Float) = 2.5
		_Metallic("Metallic", Float) = -0.4
		_Smoothness("Smoothness", Float) = 0.4
		_Normals_Strength("Normals_Strength", Float) = 1
		_Normals_Speed("Normals_Speed", Vector) = (0.1,-0.1,0,0)
		_Normals_Strength2("Normals_Strength2", Float) = 0.1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float2 _Normals_Speed;
		uniform float _Normals_Strength2;
		uniform float _Ripples_Scale;
		uniform float _Ripples_Speed;
		uniform sampler2D _Sampler609;
		uniform float _Ripples_Dissolve;
		uniform float4 _Ripples_Colour;
		uniform float _Normals_Strength;
		uniform float4 _Base_Colour;
		uniform float _Metallic;
		uniform float _Smoothness;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float2 voronoihash2( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi2( float2 v, float time, inout float2 id, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -2; j <= 2; j++ )
			{
				for ( int i = -2; i <= 2; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash2( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldPos = i.worldPos;
			float3 temp_output_16_0_g3 = ( ase_worldPos * 100.0 );
			float3 crossY18_g3 = cross( ase_worldNormal , ddy( temp_output_16_0_g3 ) );
			float3 worldDerivativeX2_g3 = ddx( temp_output_16_0_g3 );
			float dotResult6_g3 = dot( crossY18_g3 , worldDerivativeX2_g3 );
			float crossYDotWorldDerivX34_g3 = abs( dotResult6_g3 );
			float2 uv_TexCoord24 = i.uv_texcoord * float2( 2,2 ) + ( _Time.y * _Normals_Speed );
			float simplePerlin2D21 = snoise( uv_TexCoord24*5.0 );
			simplePerlin2D21 = simplePerlin2D21*0.5 + 0.5;
			float temp_output_20_0_g3 = simplePerlin2D21;
			float3 crossX19_g3 = cross( ase_worldNormal , worldDerivativeX2_g3 );
			float3 break29_g3 = ( sign( crossYDotWorldDerivX34_g3 ) * ( ( ddx( temp_output_20_0_g3 ) * crossY18_g3 ) + ( ddy( temp_output_20_0_g3 ) * crossX19_g3 ) ) );
			float3 appendResult30_g3 = (float3(break29_g3.x , -break29_g3.y , break29_g3.z));
			float3 normalizeResult39_g3 = normalize( ( ( crossYDotWorldDerivX34_g3 * ase_worldNormal ) - appendResult30_g3 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 worldToTangentDir42_g3 = mul( ase_worldToTangent, normalizeResult39_g3);
			float3 temp_output_16_0_g2 = ( ase_worldPos * 100.0 );
			float3 crossY18_g2 = cross( ase_worldNormal , ddy( temp_output_16_0_g2 ) );
			float3 worldDerivativeX2_g2 = ddx( temp_output_16_0_g2 );
			float dotResult6_g2 = dot( crossY18_g2 , worldDerivativeX2_g2 );
			float crossYDotWorldDerivX34_g2 = abs( dotResult6_g2 );
			float time2 = ( _Time.y * _Ripples_Speed );
			float2 temp_output_1_0_g1 = float2( 10,10 );
			float2 appendResult10_g1 = (float2(( (temp_output_1_0_g1).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g1).y )));
			float2 temp_output_11_0_g1 = float2( 0.5,0.5 );
			float2 panner18_g1 = ( ( (temp_output_11_0_g1).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g1 = ( ( _Time.y * (temp_output_11_0_g1).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g1 = (float2((panner18_g1).x , (panner19_g1).y));
			float2 temp_output_47_0_g1 = float2( 0.01,0.01 );
			float2 uv_TexCoord78_g1 = i.uv_texcoord * float2( 2,2 );
			float2 temp_output_31_0_g1 = ( uv_TexCoord78_g1 - float2( 1,1 ) );
			float2 appendResult39_g1 = (float2(frac( ( atan2( (temp_output_31_0_g1).x , (temp_output_31_0_g1).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g1 )));
			float2 panner54_g1 = ( ( (temp_output_47_0_g1).x * _Time.y ) * float2( 1,0 ) + appendResult39_g1);
			float2 panner55_g1 = ( ( _Time.y * (temp_output_47_0_g1).y ) * float2( 0,1 ) + appendResult39_g1);
			float2 appendResult58_g1 = (float2((panner54_g1).x , (panner55_g1).y));
			float2 coords2 = ( ( (tex2D( _Sampler609, ( appendResult10_g1 + appendResult24_g1 ) )).rg * 1.0 ) + ( float2( 10,10 ) * appendResult58_g1 ) ) * _Ripples_Scale;
			float2 id2 = 0;
			float voroi2 = voronoi2( coords2, time2,id2, 0 );
			float4 temp_output_6_0 = ( pow( voroi2 , _Ripples_Dissolve ) * _Ripples_Colour );
			float temp_output_20_0_g2 = temp_output_6_0.r;
			float3 crossX19_g2 = cross( ase_worldNormal , worldDerivativeX2_g2 );
			float3 break29_g2 = ( sign( crossYDotWorldDerivX34_g2 ) * ( ( ddx( temp_output_20_0_g2 ) * crossY18_g2 ) + ( ddy( temp_output_20_0_g2 ) * crossX19_g2 ) ) );
			float3 appendResult30_g2 = (float3(break29_g2.x , -break29_g2.y , break29_g2.z));
			float3 normalizeResult39_g2 = normalize( ( ( crossYDotWorldDerivX34_g2 * ase_worldNormal ) - appendResult30_g2 ) );
			float3 worldToTangentDir42_g2 = mul( ase_worldToTangent, normalizeResult39_g2);
			o.Normal = BlendNormals( ( worldToTangentDir42_g3 * _Normals_Strength2 ) , ( worldToTangentDir42_g2 * _Normals_Strength ) );
			o.Albedo = _Base_Colour.rgb;
			o.Emission = temp_output_6_0.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
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
450;696;1070;315;1084.556;-1316.813;2.199358;True;True
Node;AmplifyShaderEditor.SimpleTimeNode;3;-1870.971,1.952582;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1450.025,350.3669;Float;True;Property;_Ripples_Speed;Ripples_Speed;2;0;Create;True;0;0;False;0;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1206.755,261.7903;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;9;-1370.113,-245.1013;Inherit;False;RadialUVDistortion;-1;;1;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler609;False;1;FLOAT2;10,10;False;11;FLOAT2;0.5,0.5;False;65;FLOAT;1;False;68;FLOAT2;10,10;False;47;FLOAT2;0.01,0.01;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1196.71,516.0797;Float;True;Property;_Ripples_Scale;Ripples_Scale;4;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;27;-1777.107,-674.303;Float;True;Property;_Normals_Speed;Normals_Speed;9;0;Create;True;0;0;False;0;0.1,-0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1373.93,-901.3181;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;2;-920.0363,260.6672;Inherit;True;1;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;2;FLOAT;0;FLOAT;1
Node;AmplifyShaderEditor.RangedFloatNode;11;-678.5721,319.5876;Float;True;Property;_Ripples_Dissolve;Ripples_Dissolve;5;0;Create;True;0;0;False;0;2.5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-668.1636,681.4073;Float;False;Property;_Ripples_Colour;Ripples_Colour;3;1;[HDR];Create;True;0;0;False;0;0.3515327,0.9301112,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-620.5657,-920.1905;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;2,2;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;10;-464.7309,38.90421;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-181.1307,259.9309;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;21;-245.8659,-910.28;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;22;90.48578,-906.8023;Inherit;True;Normal From Height;-1;;3;1942fe2c5f1a1f94881a33d532e4afeb;0;1;20;FLOAT;0;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;14;0.08126128,-374.5493;Inherit;True;Normal From Height;-1;;2;1942fe2c5f1a1f94881a33d532e4afeb;0;1;20;FLOAT;0;False;2;FLOAT3;40;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;29;409.5764,-801.0493;Float;True;Property;_Normals_Strength2;Normals_Strength2;10;0;Create;True;0;0;False;0;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;119.104,-661.6981;Inherit;True;Property;_Normals_Strength;Normals_Strength;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;654.5563,-985.3207;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;456.7731,-378.6308;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;1;694.2144,-69.97543;Inherit;False;Property;_Base_Colour;Base_Colour;0;1;[HDR];Create;True;0;0;False;0;0,0.5176471,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;37;353.5678,1119.476;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-141.056,488.7414;Inherit;True;Property;_Metallic;Metallic;6;0;Create;True;0;0;False;0;-0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;25;860.2634,-718.5497;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;32;-858.8295,1261.691;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;13;-138.056,731.7413;Inherit;True;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;-473.8295,1261.691;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;38;187.0054,1429.78;Inherit;True;Constant;_Vector2;Vector 2;11;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DotProductOpNode;35;-53.82947,1378.691;Inherit;True;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;33;-886.8295,1516.691;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1072.113,16.10415;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SimpleWater_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;26;0;3;0
WireConnection;26;1;27;0
WireConnection;2;0;9;0
WireConnection;2;1;4;0
WireConnection;2;2;8;0
WireConnection;24;1;26;0
WireConnection;10;0;2;0
WireConnection;10;1;11;0
WireConnection;6;0;10;0
WireConnection;6;1;7;0
WireConnection;21;0;24;0
WireConnection;22;20;21;0
WireConnection;14;20;6;0
WireConnection;23;0;22;40
WireConnection;23;1;29;0
WireConnection;19;0;14;40
WireConnection;19;1;20;0
WireConnection;37;0;35;0
WireConnection;37;1;38;0
WireConnection;25;0;23;0
WireConnection;25;1;19;0
WireConnection;34;0;32;0
WireConnection;34;1;33;0
WireConnection;35;0;33;1
WireConnection;35;1;34;0
WireConnection;0;0;1;0
WireConnection;0;1;25;0
WireConnection;0;2;6;0
WireConnection;0;3;12;0
WireConnection;0;4;13;0
ASEEND*/
//CHKSM=81DD648866403F131EAE73013271F77DC2398094