; RUN: llc -mtriple aarch64-arm-linux-gnu --enable-machine-outliner -outliner-leaf-descendants=false \
; RUN:   -verify-machineinstrs %s -o - | FileCheck --check-prefixes CHECK,V8A %s
; RUN: llc -mtriple aarch64 -enable-machine-outliner -outliner-leaf-descendants=false \
; RUN:   -verify-machineinstrs -mattr=+v8.3a %s -o - | \
; RUN:   FileCheck %s --check-prefixes CHECK,V83A

declare i32 @thunk_called_fn(i32, i32, i32, i32)

define i32 @a() #0 {
; CHECK-LABEL:  a:                                      // @a
; CHECK:        // %bb.0:                               // %entry
; V8A-NEXT:         hint #25
; V83A-NEXT:        paciasp
; CHECK:            .cfi_negate_ra_state
; CHECK-NEXT:       .cfi_def_cfa_offset
; V8A:              hint #29
; V8A-NEXT:         ret
; V83A:             retaa
entry:
  %call = tail call i32 @thunk_called_fn(i32 1, i32 2, i32 3, i32 4)
  %cx = add i32 %call, 8
  ret i32 %cx
}

define i32 @b() #0 {
; CHECK-LABEL:  b:                                      // @b
; CHECK:        // %bb.0:                               // %entry
; V8A-NEXT:         hint #25
; V83A-NEXT:        paciasp
; CHECK:            .cfi_negate_ra_state
; CHECK-NEXT:       .cfi_def_cfa_offset
; V8A:              hint #29
; V8A-NEXT:         ret
; V83A:             retaa
entry:
  %call = tail call i32 @thunk_called_fn(i32 1, i32 2, i32 3, i32 4)
  %cx = add i32 %call, 88
  ret i32 %cx
}

define hidden i32 @c(ptr %fptr) #0 {
; CHECK-LABEL:  c:                                      // @c
; CHECK:        // %bb.0:                               // %entry
; V8A-NEXT:         hint #25
; V83A-NEXT:        paciasp
; CHECK:            .cfi_negate_ra_state
; CHECK-NEXT:       .cfi_def_cfa_offset
; V8A:              hint #29
; V8A-NEXT:         ret
; V83A:             retaa
entry:
  %call = tail call i32 %fptr(i32 1, i32 2, i32 3, i32 4)
  %add = add nsw i32 %call, 8
  ret i32 %add
}

define hidden i32 @d(ptr %fptr) #0 {
; CHECK-LABEL:  d:                                      // @d
; CHECK:        // %bb.0:                               // %entry
; V8A-NEXT:         hint #25
; V83A-NEXT:        paciasp
; CHECK:            .cfi_negate_ra_state
; CHECK-NEXT:       .cfi_def_cfa_offset
; V8A:              hint #29
; V8A-NEXT:         ret
; V83A:             retaa
entry:
  %call = tail call i32 %fptr(i32 1, i32 2, i32 3, i32 4)
  %add = add nsw i32 %call, 88
  ret i32 %add
}

attributes #0 = { "sign-return-address"="non-leaf" minsize }

; CHECK-NOT:        OUTLINED_FUNCTION_{{.*}}
; CHECK-NOT:         .cfi_b_key_frame
; CHECK-NOT:         paci{{[a,b]}}sp
; CHECK-NOT:         hint #2{{[5,7]}}
; CHECK-NOT:         .cfi_negate_ra_state
; CHECK-NOT:         auti{{[a,b]}}sp
; CHECK-NOT:         hint #{{[29,31]}}
