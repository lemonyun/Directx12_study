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
    float3 NormalL : NORMAL;
};

struct VertexOut
{
	float3 PosL  : POSITION;
    float4 Color : COLOR;
    float3 NormalL : NORMAL;
};

struct GeoOut
{
    float4 PosH    : SV_POSITION;
    float3 PosW    : POSITION;
    float4 Color   : COLOR;
    float3 NormalW : NORMAL;
};

VertexOut VS(VertexIn vin)
{
	VertexOut vout;
	
    vout.PosL = vin.PosL;
    vout.Color = vin.Color;
    vout.NormalL = vin.NormalL;

    return vout;
}

void Subdivide1(VertexOut inVerts[3], out VertexOut outVerts[6]) {

    VertexOut m[3];
    m[0].PosL = 0.5f * (inVerts[0].PosL + inVerts[1].PosL);
    m[1].PosL = 0.5f * (inVerts[1].PosL + inVerts[2].PosL);
    m[2].PosL = 0.5f * (inVerts[2].PosL + inVerts[0].PosL);

    m[0].NormalL = m[0].PosL;
    m[1].NormalL = m[1].PosL;
    m[2].NormalL = m[2].PosL;

    outVerts[0] = inVerts[0];
    outVerts[1] = m[0];
    outVerts[2] = m[2];
    outVerts[3] = m[1];
    outVerts[4] = inVerts[2];
    outVerts[5] = inVerts[1];

    for (int i = 0; i < 6; i++) {
        outVerts[i].Color = inVerts[0].Color;
    }

}

void Subdivide2(VertexOut inVerts[3], out VertexOut outVerts[15]) {
    VertexOut m[3];
    m[0].PosL = 0.5f * (inVerts[0].PosL + inVerts[1].PosL);
    m[1].PosL = 0.5f * (inVerts[1].PosL + inVerts[2].PosL);
    m[2].PosL = 0.5f * (inVerts[2].PosL + inVerts[0].PosL);

    VertexOut k[9];
    k[0].PosL = 0.5f * (m[0].PosL + inVerts[0].PosL);
    k[1].PosL = 0.5f * (m[0].PosL + m[2].PosL);
    k[2].PosL = 0.5f * (inVerts[0].PosL + m[2].PosL);
    k[3].PosL = 0.5f * (inVerts[1].PosL + m[0].PosL);
    k[4].PosL = 0.5f * (m[1].PosL + inVerts[1].PosL);
    k[5].PosL = 0.5f * (m[0].PosL + m[1].PosL);
    k[6].PosL = 0.5f * (m[1].PosL + m[2].PosL);
    k[7].PosL = 0.5f * (m[1].PosL + inVerts[2].PosL);
    k[8].PosL = 0.5f * (m[2].PosL + inVerts[2].PosL);
    
    outVerts[0] = inVerts[0];
    outVerts[1] = k[0];
    outVerts[2] = k[2];
    outVerts[3] = k[1];
    outVerts[4] = m[2];
    outVerts[5] = k[6];
    outVerts[6] = k[8];
    outVerts[7] = k[7];
    outVerts[8] = inVerts[2];
    outVerts[9] = m[0];
    outVerts[10] = k[3];
    outVerts[11] = k[5];
    outVerts[12] = k[4];
    outVerts[13] = m[1];
    outVerts[14] = inVerts[1];

    for (int i = 0; i < 15; i++) {
        outVerts[i].Color = inVerts[0].Color;
    }

}

void OutputSubdivision1(VertexOut v[6], inout TriangleStream<GeoOut> triStream) {
    GeoOut gout[6];

    [unroll]
    for (int i = 0; i < 6; i++) {

        float4 temp = normalize(float4(v[i].PosL, 0.0f)) * 4;
        

        gout[i].PosW = temp.xyz;

        gout[i].NormalW = v[i].NormalL;

        gout[i].PosH = mul(float4(gout[i].PosW,1.0f), gViewProj);

        gout[i].Color = v[i].Color;
    }

    [unroll]
    for (int j = 0; j < 5; j++) {
        triStream.Append(gout[j]);
    }

    triStream.RestartStrip();

    triStream.Append(gout[1]);
    triStream.Append(gout[5]);
    triStream.Append(gout[3]);
}


void OutputSubdivision2(VertexOut v[15], inout TriangleStream<GeoOut> triStream) {
    GeoOut gout[15];

    [unroll]
    for (int i = 0; i < 15; i++) {

        float4 temp = normalize(float4(v[i].PosL, 0.0f)) * 4;


        gout[i].PosW = temp.xyz;

        gout[i].PosH = mul(float4(gout[i].PosW, 1.0f), gViewProj);

        gout[i].Color = v[i].Color;
    }

    [unroll]
    for (int j = 0; j < 9; j++) {
        triStream.Append(gout[j]);
    }

    triStream.RestartStrip();

    triStream.Append(gout[1]);
    triStream.Append(gout[9]);
    triStream.Append(gout[3]);
    triStream.Append(gout[11]);
    triStream.Append(gout[5]);
    triStream.Append(gout[13]);
    triStream.Append(gout[7]);

    triStream.RestartStrip();
    [unroll]
    for (int j = 9; j < 14; j++) {
        triStream.Append(gout[j]);
    }
    triStream.RestartStrip();

    triStream.Append(gout[10]);
    triStream.Append(gout[14]);
    triStream.Append(gout[12]);



}



[maxvertexcount(24)]
void GS(triangle VertexOut gin[3],
    inout TriangleStream<GeoOut> triStream) {
    
    if (length(gEyePosW) < 15) {
        VertexOut v[15];
        Subdivide2(gin, v);
        OutputSubdivision2(v, triStream);
    }
    else if (length(gEyePosW) < 30) {
        VertexOut v[6];
        Subdivide1(gin, v);
        OutputSubdivision1(v, triStream);

    }
    else {
        
        GeoOut gout[3];
        [unroll]
        for (int i = 0; i < 3; i++) {

            gout[i].PosW = gin[i].PosL;
            gout[i].PosH = mul(float4(gout[i].PosW, 1.0f), gViewProj);
            gout[i].Color = gin[i].Color;
        }

        triStream.Append(gout[0]);
        triStream.Append(gout[1]);
        triStream.Append(gout[2]);
    }

    

}


float4 PS(GeoOut pin) : SV_Target
{
    return pin.Color;
}