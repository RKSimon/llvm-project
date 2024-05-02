; REQUIRES: asserts
; RUN: llc < %s -mtriple=aarch64 -mcpu=cyclone -mattr=+slow-misaligned-128store -enable-misched -verify-misched -o - | FileCheck %s

; Tests to check that the scheduler dependencies derived from alias analysis are
; correct when we have loads that have been split up so that they can later be
; merged into STP.

; Now that overwritten stores are elided in SelectionDAG, dependencies
; are resolved and removed before MISCHED. Check that we have
; equivalent pair of stp calls as a baseline.

; CHECK-LABEL: test_splat
; CHECK:      mov x8, x2
; CHECK-NEXT: ld1r { v0.2s }, [x8], #4
; CHECK-NEXT: stur d0, [x2, #12]
; CHECK-NEXT: str d0, [x8]
; CHECK-NEXT: stp w1, w0, [x2, #8]
define void @test_splat(i32 %x, i32 %y, ptr %p) {
entry:
  %val = load i32, ptr %p, align 4
  %0 = getelementptr inbounds i32, ptr %p, i64 1
  %1 = getelementptr inbounds i32, ptr %p, i64 2
  %2 = getelementptr inbounds i32, ptr %p, i64 3
  %vec0 = insertelement <4 x i32> undef, i32 %val, i32 0
  %vec1 = insertelement <4 x i32> %vec0, i32 %val, i32 1
  %vec2 = insertelement <4 x i32> %vec1, i32 %val, i32 2
  %vec3 = insertelement <4 x i32> %vec2, i32 %val, i32 3
  store <4 x i32> %vec3, ptr %0, align 4
  store i32 %x, ptr %2, align 4
  store i32 %y, ptr %1, align 4
  ret void
}

declare void @llvm.memset.p0.i64(ptr nocapture, i8, i64, i1)
%struct.tree_common = type { ptr, ptr, i32 }

; CHECK-LABEL: test_zero
; CHECK-DAG: stp x2, xzr, [x0, #8]
; CHECK-DAG: str w1, [x0, #16]
; CHECK-DAG: str xzr, [x0]

define void @test_zero(ptr %t, i32 %code, ptr %type) {
entry:
  tail call void @llvm.memset.p0.i64(ptr align 8 %t, i8 0, i64 24, i1 false)
  %code1 = getelementptr inbounds %struct.tree_common, ptr %t, i64 0, i32 2
  store i32 %code, ptr %code1, align 8
  %type2 = getelementptr inbounds %struct.tree_common, ptr %t, i64 0, i32 1
  store ptr %type, ptr %type2, align 8
  ret void
}
