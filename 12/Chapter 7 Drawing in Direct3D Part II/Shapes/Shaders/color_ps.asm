//
// Generated by Microsoft (R) HLSL Shader Compiler 9.29.952.3111
//
//
//   fxc circle.hlsl /T vs_5_0 /E VS /Fo color_ps.cso /Fc color_ps.asm
//
//
//
// Input signature:
//
// Name                 Index   Mask Register SysValue Format   Used
// -------------------- ----- ------ -------- -------- ------ ------
// POSITION                 0   xyz         0     NONE  float   xyz 
// COLOR                    0   xyzw        1     NONE  float   xyzw
//
//
// Output signature:
//
// Name                 Index   Mask Register SysValue Format   Used
// -------------------- ----- ------ -------- -------- ------ ------
// POSITION                 0   xyz         0     NONE  float   xyz 
// COLOR                    0   xyzw        1     NONE  float   xyzw
//
vs_5_0
dcl_globalFlags refactoringAllowed
dcl_input v0.xyz
dcl_input v1.xyzw
dcl_output o0.xyz
dcl_output o1.xyzw
mov o0.xyz, v0.xyzx
mov o1.xyzw, v1.xyzw
ret 
// Approximately 3 instruction slots used
