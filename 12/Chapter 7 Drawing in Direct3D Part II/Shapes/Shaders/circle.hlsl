//***************************************************************************************
// color.hlsl by Frank Luna (C) 2015 All Rights Reserved.
//
// Transforms and colors geometry.
//***************************************************************************************
 
cbuffer cbPerObject : register(b0)
{
	float4x4 gWorld; 
};

cbuffer cbPass : register(b1)
{
    float4x4 gView;
    float4x4 gInvView;
    float4x4 gProj;
    float4x4 gInvProj;
    float4x4 gViewProj;
    float4x4 gInvViewProj;
    float3 gEyePosW;
    float cbPerObjectPad1;
    float2 gRenderTargetSize;
    float2 gInvRenderTargetSize;
    float gNearZ;
    float gFarZ;
    float gTotalTime;
    float gDeltaTime;
};

struct VertexIn
{
	float3 PosL  : POSITION;
    float4 Color : COLOR;
};

struct VertexOut
{
	float3 PosL  : POSITION;
    float4 Color : COLOR;
};

struct GeoOut
{
    float4 PosH    : SV_POSITION;
    float3 PosW    : POSITION;
    float4 Color   : COLOR;
};

VertexOut VS(VertexIn vin)
{
	VertexOut vout;
	
    vout.PosL = vin.PosL;
    vout.Color = vin.Color;
    
    return vout;
}

[maxvertexcount(2)]
void GS(line VertexOut gin[2],
    inout LineStream<GeoOut> lineStream) {
    
    float4 v[2];

    v[0] = float4(0.5f * (gin[0].PosL + gin[1].PosL), 1.0f);
    v[1] = v[0] + float4(0.0f, 4.0f, 0.0f, 0.0f);

    GeoOut gout;
    [unroll]
    for (int i = 0; i < 2; i++) {

        gout.PosH = mul(v[i], gViewProj);
        gout.PosW = v[i].xyz;
        gout.Color = gin[i].Color;

        lineStream.Append(gout);
    }

}


float4 PS(GeoOut pin) : SV_Target
{
    return pin.Color;
}