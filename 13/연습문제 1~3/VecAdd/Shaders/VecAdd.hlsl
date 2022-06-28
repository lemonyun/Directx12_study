
struct Data
{
	float3 v1;
};

struct Result
{
	float v1;
};

//-------------Practice 1,2 ----------------------//
RWStructuredBuffer<Data> gInputA : register(u0);
RWStructuredBuffer<Data> gOutput : register(u1);

//-------------Practice 3 -----------------------//
//ConsumeStructuredBuffer<Data> gInputA : register(u0);
//AppendStructuredBuffer<Data> gOutput : register(u1);

//-------------Practice 1,2 ----------------------//
[numthreads(64, 1, 1)]
void CS(int3 dtid : SV_DispatchThreadID)
{
	gOutput[dtid.x].v1.x = length(gInputA[dtid.x].v1);
	
}

////-------------Practice 3 -----------------------//
//[numthreads(64, 1, 1)]
//void CS()
//{
//	
//	Data d = gInputA.Consume();
//
//	d.v1 = float3(length(d.v1), length(d.v1), length(d.v1));
//	
//	gOutput.Append(d);
//}
