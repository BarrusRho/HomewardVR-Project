// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Snow_Shader"
{
	Properties
	{
		_GroundAlbedoMap("Ground Albedo Map", 2D) = "white" {}
		_GroundNormalMap("Ground Normal Map", 2D) = "bump" {}
		_SnowAlbedoMap("Snow Albedo Map", 2D) = "white" {}
		_SnowNormalMap("Snow Normal Map", 2D) = "bump" {}
		_Metalness("Metalness", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_SnowAmount("Snow Amount", Range( 0 , 3)) = 0
		_SnowVolume("Snow Volume", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
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
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _SnowVolume;
		uniform sampler2D _GroundNormalMap;
		uniform float4 _GroundNormalMap_ST;
		uniform sampler2D _SnowNormalMap;
		uniform float4 _SnowNormalMap_ST;
		uniform float _SnowAmount;
		uniform sampler2D _GroundAlbedoMap;
		uniform float4 _GroundAlbedoMap_ST;
		uniform sampler2D _SnowAlbedoMap;
		uniform float4 _SnowAlbedoMap_ST;
		uniform float _Metalness;
		uniform float _Smoothness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float2 uv_GroundNormalMap = v.texcoord * _GroundNormalMap_ST.xy + _GroundNormalMap_ST.zw;
			float2 uv_SnowNormalMap = v.texcoord * _SnowNormalMap_ST.xy + _SnowNormalMap_ST.zw;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 lerpResult8 = lerp( UnpackNormal( tex2Dlod( _GroundNormalMap, float4( uv_GroundNormalMap, 0, 0.0) ) ) , UnpackNormal( tex2Dlod( _SnowNormalMap, float4( uv_SnowNormalMap, 0, 0.0) ) ) , saturate( ( ase_worldNormal.y * _SnowAmount ) ));
			float3 ase_worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
			float3x3 tangentToWorld = CreateTangentToWorldPerVertex( ase_worldNormal, ase_worldTangent, v.tangent.w );
			float3 tangentNormal12 = lerpResult8;
			float3 modWorldNormal12 = (tangentToWorld[0] * tangentNormal12.x + tangentToWorld[1] * tangentNormal12.y + tangentToWorld[2] * tangentNormal12.z);
			float temp_output_16_0 = ( modWorldNormal12.y * _SnowAmount );
			float3 lerpResult21 = lerp( float3( 0,0,0 ) , ( ase_vertexNormal * _SnowVolume ) , saturate( (0.0 + (temp_output_16_0 - 0.0) * (1.0 - 0.0) / (3.0 - 0.0)) ));
			v.vertex.xyz += lerpResult21;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_GroundNormalMap = i.uv_texcoord * _GroundNormalMap_ST.xy + _GroundNormalMap_ST.zw;
			float2 uv_SnowNormalMap = i.uv_texcoord * _SnowNormalMap_ST.xy + _SnowNormalMap_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 lerpResult8 = lerp( UnpackNormal( tex2D( _GroundNormalMap, uv_GroundNormalMap ) ) , UnpackNormal( tex2D( _SnowNormalMap, uv_SnowNormalMap ) ) , saturate( ( ase_worldNormal.y * _SnowAmount ) ));
			o.Normal = lerpResult8;
			float2 uv_GroundAlbedoMap = i.uv_texcoord * _GroundAlbedoMap_ST.xy + _GroundAlbedoMap_ST.zw;
			float2 uv_SnowAlbedoMap = i.uv_texcoord * _SnowAlbedoMap_ST.xy + _SnowAlbedoMap_ST.zw;
			float temp_output_16_0 = ( (WorldNormalVector( i , lerpResult8 )).y * _SnowAmount );
			float4 lerpResult9 = lerp( tex2D( _GroundAlbedoMap, uv_GroundAlbedoMap ) , tex2D( _SnowAlbedoMap, uv_SnowAlbedoMap ) , saturate( temp_output_16_0 ));
			o.Albedo = lerpResult9.rgb;
			o.Metallic = _Metalness;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				vertexDataFunc( v, customInputData );
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
1281;641;1272;730;3023.256;916.5957;1;True;False
Node;AmplifyShaderEditor.WorldNormalVector;10;-2816,-832;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;14;-2688,-512;Inherit;False;Property;_SnowAmount;Snow Amount;6;0;Create;True;0;0;False;0;0;3;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-2400,-832;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-2528,-64;Inherit;True;Property;_SnowNormalMap;Snow Normal Map;3;0;Create;True;0;0;False;0;-1;None;24e31ecbf813d9e49bf7a1e0d4034916;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;11;-2160,-832;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-2544,-304;Inherit;True;Property;_GroundNormalMap;Ground Normal Map;1;0;Create;True;0;0;False;0;-1;None;0bebe40e9ebbecc48b8e9cfea982da7e;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;8;-1888,-448;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;12;-1551.99,-1144.917;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1199.99,-936.9171;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1024,480;Inherit;True;Property;_SnowVolume;Snow Volume;7;0;Create;True;0;0;False;0;0;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;20;-1088,176;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;22;-960,-128;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;3;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-968.1592,-1536;Inherit;True;Property;_GroundAlbedoMap;Ground Albedo Map;0;0;Create;True;0;0;False;0;-1;None;b297077dae62c1944ba14cad801cddf5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-968.1592,-1328;Inherit;True;Property;_SnowAlbedoMap;Snow Albedo Map;2;0;Create;True;0;0;False;0;-1;None;4112a019314dad94f9ffc2f8481f31bc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;23;-656,-128;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;13;-975.99,-936.9171;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-736,352;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-368,-192;Inherit;False;Property;_Smoothness;Smoothness;5;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-368,-288;Inherit;False;Property;_Metalness;Metalness;4;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;9;-312.1588,-1264;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;21;-368,224;Inherit;True;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,-384;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Snow_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;10;2
WireConnection;15;1;14;0
WireConnection;11;0;15;0
WireConnection;8;0;2;0
WireConnection;8;1;7;0
WireConnection;8;2;11;0
WireConnection;12;0;8;0
WireConnection;16;0;12;2
WireConnection;16;1;14;0
WireConnection;22;0;16;0
WireConnection;23;0;22;0
WireConnection;13;0;16;0
WireConnection;18;0;20;0
WireConnection;18;1;19;0
WireConnection;9;0;1;0
WireConnection;9;1;6;0
WireConnection;9;2;13;0
WireConnection;21;1;18;0
WireConnection;21;2;23;0
WireConnection;0;0;9;0
WireConnection;0;1;8;0
WireConnection;0;3;3;0
WireConnection;0;4;4;0
WireConnection;0;11;21;0
ASEEND*/
//CHKSM=DAA06683CF678F26A5397D076B70ABA988634537