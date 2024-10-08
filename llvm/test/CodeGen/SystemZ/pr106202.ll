; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=s390x-ibm-linux -mcpu=z10 | FileCheck %s

@g_0 = external dso_local local_unnamed_addr global i16, align 2
@g_1 = external dso_local local_unnamed_addr global i32, align 4
@g_2 = external dso_local local_unnamed_addr global i32, align 4

define void @func() {
; CHECK-LABEL: func:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lhi %r0, 41
; CHECK-NEXT:    strl %r0, g_1
; CHECK-NEXT:    lhi %r0, 0
; CHECK-NEXT:    strl %r0, g_2
; CHECK-NEXT:    br %r14
  store i32 41, ptr @g_1, align 4
  %1 = load i32, ptr @g_1, align 4
  %2 = load i16, ptr @g_0, align 2
  %3 = zext i16 %2 to i32
  %4 = shl i32 %3, %1
  %5 = zext i32 %4 to i64
  %6 = shl i64 %5, 48
  %7 = ashr exact i64 %6, 48
  %8 = or i64 %7, 0
  %9 = sext i32 %1 to i64
  %10 = icmp sge i64 %8, %9
  %11 = zext i1 %10 to i32
  %12 = or i32 0, %11
  store i32 %12, ptr @g_2, align 4
  ret void
}
