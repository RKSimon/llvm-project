; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=amdgcn -stop-after=amdgpu-isel < %s | FileCheck -check-prefix=GCN %s

define amdgpu_kernel void @uniform_trunc_i16_to_i1(ptr addrspace(1) %out, i16 %x, i1 %z) {
  ; GCN-LABEL: name: uniform_trunc_i16_to_i1
  ; GCN: bb.0 (%ir-block.0):
  ; GCN-NEXT:   liveins: $sgpr4_sgpr5
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT:   [[COPY:%[0-9]+]]:sgpr_64(p4) = COPY $sgpr4_sgpr5
  ; GCN-NEXT:   [[S_LOAD_DWORDX2_IMM:%[0-9]+]]:sreg_64_xexec = S_LOAD_DWORDX2_IMM [[COPY]](p4), 9, 0 :: (dereferenceable invariant load (s64) from %ir.out.kernarg.offset, align 4, addrspace 4)
  ; GCN-NEXT:   [[S_LOAD_DWORD_IMM:%[0-9]+]]:sreg_32_xm0_xexec = S_LOAD_DWORD_IMM [[COPY]](p4), 11, 0 :: (dereferenceable invariant load (s32) from %ir.z.kernarg.offset.align.down, addrspace 4)
  ; GCN-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY [[S_LOAD_DWORDX2_IMM]].sub1
  ; GCN-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY [[S_LOAD_DWORDX2_IMM]].sub0
  ; GCN-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 61440
  ; GCN-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 -1
  ; GCN-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE killed [[COPY2]], %subreg.sub0, killed [[COPY1]], %subreg.sub1, killed [[S_MOV_B32_1]], %subreg.sub2, killed [[S_MOV_B32_]], %subreg.sub3
  ; GCN-NEXT:   [[S_SEXT_I32_I16_:%[0-9]+]]:sreg_32 = S_SEXT_I32_I16 [[S_LOAD_DWORD_IMM]]
  ; GCN-NEXT:   [[S_MOV_B32_2:%[0-9]+]]:sreg_32 = S_MOV_B32 16
  ; GCN-NEXT:   [[S_LSHR_B32_:%[0-9]+]]:sreg_32 = S_LSHR_B32 [[S_LOAD_DWORD_IMM]], killed [[S_MOV_B32_2]], implicit-def dead $scc
  ; GCN-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY killed [[S_LSHR_B32_]]
  ; GCN-NEXT:   [[S_AND_B32_:%[0-9]+]]:sreg_32 = S_AND_B32 1, killed [[COPY3]], implicit-def dead $scc
  ; GCN-NEXT:   S_CMP_EQ_U32 killed [[S_AND_B32_]], 1, implicit-def $scc
  ; GCN-NEXT:   [[COPY4:%[0-9]+]]:sreg_64 = COPY $scc
  ; GCN-NEXT:   [[S_MOV_B32_3:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; GCN-NEXT:   S_CMP_LT_I32 killed [[S_SEXT_I32_I16_]], killed [[S_MOV_B32_3]], implicit-def $scc
  ; GCN-NEXT:   [[COPY5:%[0-9]+]]:sreg_64 = COPY $scc
  ; GCN-NEXT:   [[S_OR_B64_:%[0-9]+]]:sreg_64_xexec = S_OR_B64 killed [[COPY5]], killed [[COPY4]], implicit-def dead $scc
  ; GCN-NEXT:   [[V_CNDMASK_B32_e64_:%[0-9]+]]:vgpr_32 = V_CNDMASK_B32_e64 0, 0, 0, 1, killed [[S_OR_B64_]], implicit $exec
  ; GCN-NEXT:   BUFFER_STORE_BYTE_OFFSET killed [[V_CNDMASK_B32_e64_]], killed [[REG_SEQUENCE]], 0, 0, 0, 0, implicit $exec :: (store (s8) into %ir.out.load, addrspace 1)
  ; GCN-NEXT:   S_ENDPGM 0
  %setcc = icmp slt i16 %x, 0
  %select = select i1 %setcc, i1 true, i1 %z
  store i1 %select, ptr addrspace(1) %out
  ret void
}

define i1 @divergent_trunc_i16_to_i1(ptr addrspace(1) %out, i16 %x, i1 %z) {
  ; GCN-LABEL: name: divergent_trunc_i16_to_i1
  ; GCN: bb.0 (%ir-block.0):
  ; GCN-NEXT:   liveins: $vgpr2, $vgpr3
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; GCN-NEXT:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; GCN-NEXT:   [[V_AND_B32_e64_:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 1, [[COPY]], implicit $exec
  ; GCN-NEXT:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64 = V_CMP_EQ_U32_e64 killed [[V_AND_B32_e64_]], 1, implicit $exec
  ; GCN-NEXT:   [[V_BFE_I32_e64_:%[0-9]+]]:vgpr_32 = V_BFE_I32_e64 [[COPY1]], 0, 16, implicit $exec
  ; GCN-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; GCN-NEXT:   [[V_CMP_LT_I32_e64_:%[0-9]+]]:sreg_64 = V_CMP_LT_I32_e64 killed [[V_BFE_I32_e64_]], killed [[S_MOV_B32_]], implicit $exec
  ; GCN-NEXT:   [[S_OR_B64_:%[0-9]+]]:sreg_64_xexec = S_OR_B64 killed [[V_CMP_LT_I32_e64_]], killed [[V_CMP_EQ_U32_e64_]], implicit-def dead $scc
  ; GCN-NEXT:   [[V_CNDMASK_B32_e64_:%[0-9]+]]:vgpr_32 = V_CNDMASK_B32_e64 0, 0, 0, 1, killed [[S_OR_B64_]], implicit $exec
  ; GCN-NEXT:   $vgpr0 = COPY [[V_CNDMASK_B32_e64_]]
  ; GCN-NEXT:   SI_RETURN implicit $vgpr0
  %setcc = icmp slt i16 %x, 0
  %select = select i1 %setcc, i1 true, i1 %z
  ret i1 %select
}

define amdgpu_kernel void @uniform_trunc_i32_to_i1(ptr addrspace(1) %out, i32 %x, i1 %z) {
  ; GCN-LABEL: name: uniform_trunc_i32_to_i1
  ; GCN: bb.0 (%ir-block.0):
  ; GCN-NEXT:   liveins: $sgpr4_sgpr5
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT:   [[COPY:%[0-9]+]]:sgpr_64(p4) = COPY $sgpr4_sgpr5
  ; GCN-NEXT:   [[S_LOAD_DWORDX2_IMM:%[0-9]+]]:sreg_64_xexec = S_LOAD_DWORDX2_IMM [[COPY]](p4), 9, 0 :: (dereferenceable invariant load (s64) from %ir.out.kernarg.offset, align 4, addrspace 4)
  ; GCN-NEXT:   [[S_LOAD_DWORDX2_IMM1:%[0-9]+]]:sreg_64_xexec = S_LOAD_DWORDX2_IMM [[COPY]](p4), 11, 0 :: (dereferenceable invariant load (s64) from %ir.x.kernarg.offset, align 4, addrspace 4)
  ; GCN-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY [[S_LOAD_DWORDX2_IMM]].sub1
  ; GCN-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY [[S_LOAD_DWORDX2_IMM]].sub0
  ; GCN-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 61440
  ; GCN-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 -1
  ; GCN-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE killed [[COPY2]], %subreg.sub0, killed [[COPY1]], %subreg.sub1, killed [[S_MOV_B32_1]], %subreg.sub2, killed [[S_MOV_B32_]], %subreg.sub3
  ; GCN-NEXT:   [[COPY3:%[0-9]+]]:sreg_64 = COPY killed [[S_LOAD_DWORDX2_IMM1]]
  ; GCN-NEXT:   [[COPY4:%[0-9]+]]:sreg_32 = COPY [[COPY3]].sub0
  ; GCN-NEXT:   [[COPY5:%[0-9]+]]:sreg_32 = COPY [[COPY3]].sub1
  ; GCN-NEXT:   [[S_AND_B32_:%[0-9]+]]:sreg_32 = S_AND_B32 1, killed [[COPY5]], implicit-def dead $scc
  ; GCN-NEXT:   S_CMP_EQ_U32 killed [[S_AND_B32_]], 1, implicit-def $scc
  ; GCN-NEXT:   [[COPY6:%[0-9]+]]:sreg_64 = COPY $scc
  ; GCN-NEXT:   [[S_MOV_B32_2:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; GCN-NEXT:   S_CMP_LT_I32 killed [[COPY4]], killed [[S_MOV_B32_2]], implicit-def $scc
  ; GCN-NEXT:   [[COPY7:%[0-9]+]]:sreg_64 = COPY $scc
  ; GCN-NEXT:   [[S_OR_B64_:%[0-9]+]]:sreg_64_xexec = S_OR_B64 killed [[COPY7]], killed [[COPY6]], implicit-def dead $scc
  ; GCN-NEXT:   [[V_CNDMASK_B32_e64_:%[0-9]+]]:vgpr_32 = V_CNDMASK_B32_e64 0, 0, 0, 1, killed [[S_OR_B64_]], implicit $exec
  ; GCN-NEXT:   BUFFER_STORE_BYTE_OFFSET killed [[V_CNDMASK_B32_e64_]], killed [[REG_SEQUENCE]], 0, 0, 0, 0, implicit $exec :: (store (s8) into %ir.out.load, addrspace 1)
  ; GCN-NEXT:   S_ENDPGM 0
  %setcc = icmp slt i32 %x, 0
  %select = select i1 %setcc, i1 true, i1 %z
  store i1 %select, ptr addrspace(1) %out
  ret void
}

define i1 @divergent_trunc_i32_to_i1(ptr addrspace(1) %out, i32 %x, i1 %z) {
  ; GCN-LABEL: name: divergent_trunc_i32_to_i1
  ; GCN: bb.0 (%ir-block.0):
  ; GCN-NEXT:   liveins: $vgpr2, $vgpr3
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; GCN-NEXT:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; GCN-NEXT:   [[V_AND_B32_e64_:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 1, [[COPY]], implicit $exec
  ; GCN-NEXT:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64 = V_CMP_EQ_U32_e64 killed [[V_AND_B32_e64_]], 1, implicit $exec
  ; GCN-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; GCN-NEXT:   [[V_CMP_LT_I32_e64_:%[0-9]+]]:sreg_64 = V_CMP_LT_I32_e64 [[COPY1]], killed [[S_MOV_B32_]], implicit $exec
  ; GCN-NEXT:   [[S_OR_B64_:%[0-9]+]]:sreg_64_xexec = S_OR_B64 killed [[V_CMP_LT_I32_e64_]], killed [[V_CMP_EQ_U32_e64_]], implicit-def dead $scc
  ; GCN-NEXT:   [[V_CNDMASK_B32_e64_:%[0-9]+]]:vgpr_32 = V_CNDMASK_B32_e64 0, 0, 0, 1, killed [[S_OR_B64_]], implicit $exec
  ; GCN-NEXT:   $vgpr0 = COPY [[V_CNDMASK_B32_e64_]]
  ; GCN-NEXT:   SI_RETURN implicit $vgpr0
  %setcc = icmp slt i32 %x, 0
  %select = select i1 %setcc, i1 true, i1 %z
  ret i1 %select
}

define amdgpu_kernel void @uniform_trunc_i64_to_i1(ptr addrspace(1) %out, i64 %x, i1 %z) {
  ; GCN-LABEL: name: uniform_trunc_i64_to_i1
  ; GCN: bb.0 (%ir-block.0):
  ; GCN-NEXT:   liveins: $sgpr4_sgpr5
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT:   [[COPY:%[0-9]+]]:sgpr_64(p4) = COPY $sgpr4_sgpr5
  ; GCN-NEXT:   [[S_LOAD_DWORDX4_IMM:%[0-9]+]]:sgpr_128 = S_LOAD_DWORDX4_IMM [[COPY]](p4), 9, 0 :: (dereferenceable invariant load (s128) from %ir.out.kernarg.offset, align 4, addrspace 4)
  ; GCN-NEXT:   [[S_LOAD_DWORD_IMM:%[0-9]+]]:sreg_32_xm0_xexec = S_LOAD_DWORD_IMM [[COPY]](p4), 13, 0 :: (dereferenceable invariant load (s32) from %ir.z.kernarg.offset.align.down, addrspace 4)
  ; GCN-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY [[S_LOAD_DWORDX4_IMM]].sub1
  ; GCN-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY [[S_LOAD_DWORDX4_IMM]].sub0
  ; GCN-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sreg_64 = REG_SEQUENCE killed [[COPY2]], %subreg.sub0, killed [[COPY1]], %subreg.sub1
  ; GCN-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY [[REG_SEQUENCE]].sub1
  ; GCN-NEXT:   [[COPY4:%[0-9]+]]:sreg_32 = COPY [[REG_SEQUENCE]].sub0
  ; GCN-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 61440
  ; GCN-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 -1
  ; GCN-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:sgpr_128 = REG_SEQUENCE killed [[COPY4]], %subreg.sub0, killed [[COPY3]], %subreg.sub1, killed [[S_MOV_B32_1]], %subreg.sub2, killed [[S_MOV_B32_]], %subreg.sub3
  ; GCN-NEXT:   [[COPY5:%[0-9]+]]:sreg_32 = COPY [[S_LOAD_DWORDX4_IMM]].sub3
  ; GCN-NEXT:   [[COPY6:%[0-9]+]]:sreg_32 = COPY [[S_LOAD_DWORDX4_IMM]].sub2
  ; GCN-NEXT:   [[REG_SEQUENCE2:%[0-9]+]]:sreg_64 = REG_SEQUENCE killed [[COPY6]], %subreg.sub0, killed [[COPY5]], %subreg.sub1
  ; GCN-NEXT:   [[COPY7:%[0-9]+]]:sreg_32 = COPY killed [[S_LOAD_DWORD_IMM]]
  ; GCN-NEXT:   [[S_AND_B32_:%[0-9]+]]:sreg_32 = S_AND_B32 1, killed [[COPY7]], implicit-def dead $scc
  ; GCN-NEXT:   S_CMP_EQ_U32 killed [[S_AND_B32_]], 1, implicit-def $scc
  ; GCN-NEXT:   [[COPY8:%[0-9]+]]:sreg_64 = COPY $scc
  ; GCN-NEXT:   [[S_MOV_B64_:%[0-9]+]]:sreg_64 = S_MOV_B64 0
  ; GCN-NEXT:   [[COPY9:%[0-9]+]]:vreg_64 = COPY killed [[S_MOV_B64_]]
  ; GCN-NEXT:   [[V_CMP_LT_I64_e64_:%[0-9]+]]:sreg_64 = V_CMP_LT_I64_e64 killed [[REG_SEQUENCE2]], [[COPY9]], implicit $exec
  ; GCN-NEXT:   [[S_OR_B64_:%[0-9]+]]:sreg_64_xexec = S_OR_B64 killed [[V_CMP_LT_I64_e64_]], killed [[COPY8]], implicit-def dead $scc
  ; GCN-NEXT:   [[V_CNDMASK_B32_e64_:%[0-9]+]]:vgpr_32 = V_CNDMASK_B32_e64 0, 0, 0, 1, killed [[S_OR_B64_]], implicit $exec
  ; GCN-NEXT:   BUFFER_STORE_BYTE_OFFSET killed [[V_CNDMASK_B32_e64_]], killed [[REG_SEQUENCE1]], 0, 0, 0, 0, implicit $exec :: (store (s8) into %ir.2, addrspace 1)
  ; GCN-NEXT:   S_ENDPGM 0
  %setcc = icmp slt i64 %x, 0
  %select = select i1 %setcc, i1 true, i1 %z
  store i1 %select, ptr addrspace(1) %out
  ret void
}

define i1 @divergent_trunc_i64_to_i1(ptr addrspace(1) %out, i64 %x, i1 %z) {
  ; GCN-LABEL: name: divergent_trunc_i64_to_i1
  ; GCN: bb.0 (%ir-block.0):
  ; GCN-NEXT:   liveins: $vgpr2, $vgpr3, $vgpr4
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; GCN-NEXT:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; GCN-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; GCN-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sreg_64 = REG_SEQUENCE [[COPY2]], %subreg.sub0, [[COPY1]], %subreg.sub1
  ; GCN-NEXT:   [[V_AND_B32_e64_:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 1, [[COPY]], implicit $exec
  ; GCN-NEXT:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64 = V_CMP_EQ_U32_e64 killed [[V_AND_B32_e64_]], 1, implicit $exec
  ; GCN-NEXT:   [[S_MOV_B64_:%[0-9]+]]:sreg_64 = S_MOV_B64 0
  ; GCN-NEXT:   [[COPY3:%[0-9]+]]:vreg_64 = COPY killed [[S_MOV_B64_]]
  ; GCN-NEXT:   [[V_CMP_LT_I64_e64_:%[0-9]+]]:sreg_64 = V_CMP_LT_I64_e64 killed [[REG_SEQUENCE]], [[COPY3]], implicit $exec
  ; GCN-NEXT:   [[S_OR_B64_:%[0-9]+]]:sreg_64_xexec = S_OR_B64 killed [[V_CMP_LT_I64_e64_]], killed [[V_CMP_EQ_U32_e64_]], implicit-def dead $scc
  ; GCN-NEXT:   [[V_CNDMASK_B32_e64_:%[0-9]+]]:vgpr_32 = V_CNDMASK_B32_e64 0, 0, 0, 1, killed [[S_OR_B64_]], implicit $exec
  ; GCN-NEXT:   $vgpr0 = COPY [[V_CNDMASK_B32_e64_]]
  ; GCN-NEXT:   SI_RETURN implicit $vgpr0
  %setcc = icmp slt i64 %x, 0
  %select = select i1 %setcc, i1 true, i1 %z
  ret i1 %select
}
