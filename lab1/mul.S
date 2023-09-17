	.text
	.file	"mul.cpp"
	.section	.text.startup,"ax",@progbits
	.p2align	2                               // -- Begin function __cxx_global_var_init
	.type	__cxx_global_var_init,@function
__cxx_global_var_init:                  // @__cxx_global_var_init
	.cfi_startproc
// %bb.0:
	stp	x29, x30, [sp, #-32]!           // 16-byte Folded Spill
	str	x19, [sp, #16]                  // 8-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 32
	.cfi_offset w19, -16
	.cfi_offset w30, -24
	.cfi_offset w29, -32
	adrp	x19, _ZStL8__ioinit
	add	x19, x19, :lo12:_ZStL8__ioinit
	mov	x0, x19
	bl	_ZNSt8ios_base4InitC1Ev
	adrp	x0, :got:_ZNSt8ios_base4InitD1Ev
	adrp	x2, __dso_handle
	add	x2, x2, :lo12:__dso_handle
	mov	x1, x19
	ldr	x0, [x0, :got_lo12:_ZNSt8ios_base4InitD1Ev]
	bl	__cxa_atexit
	ldr	x19, [sp, #16]                  // 8-byte Folded Reload
	ldp	x29, x30, [sp], #32             // 16-byte Folded Reload
	ret
.Lfunc_end0:
	.size	__cxx_global_var_init, .Lfunc_end0-__cxx_global_var_init
	.cfi_endproc
                                        // -- End function
	.text
	.globl	main                            // -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   // @main
	.cfi_startproc
// %bb.0:
	sub	sp, sp, #32
	stp	x29, x30, [sp, #16]             // 16-byte Folded Spill
	add	x29, sp, #16
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	wzr, [x29, #-4]
	adrp	x8, :got:_ZSt3cin
	ldr	x0, [x8, :got_lo12:_ZSt3cin]
	add	x1, sp, #4
	bl	_ZNSirsERi
	mov	w8, #2
	str	w8, [sp, #8]
	mov	w8, #1
	str	w8, [sp]
.LBB1_1:                                // =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #8]
	ldr	w9, [sp, #4]
	cmp	w8, w9
	b.gt	.LBB1_3
// %bb.2:                               //   in Loop: Header=BB1_1 Depth=1
	ldr	w8, [sp]
	ldr	w9, [sp, #8]
	mul	w8, w8, w9
	str	w8, [sp]
	ldr	w8, [sp, #8]
	add	w8, w8, #1
	str	w8, [sp, #8]
	b	.LBB1_1
.LBB1_3:
	ldr	w1, [sp]
	adrp	x8, :got:_ZSt4cout
	ldr	x0, [x8, :got_lo12:_ZSt4cout]
	bl	_ZNSolsEi
	adrp	x8, :got:_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_
	ldr	x1, [x8, :got_lo12:_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_]
	bl	_ZNSolsEPFRSoS_E
	mov	w0, wzr
	ldp	x29, x30, [sp, #16]             // 16-byte Folded Reload
	add	sp, sp, #32
	ret
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        // -- End function
	.section	.text.startup,"ax",@progbits
	.p2align	2                               // -- Begin function _GLOBAL__sub_I_mul.cpp
	.type	_GLOBAL__sub_I_mul.cpp,@function
_GLOBAL__sub_I_mul.cpp:                 // @_GLOBAL__sub_I_mul.cpp
	.cfi_startproc
// %bb.0:
	stp	x29, x30, [sp, #-16]!           // 16-byte Folded Spill
	mov	x29, sp
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	bl	__cxx_global_var_init
	ldp	x29, x30, [sp], #16             // 16-byte Folded Reload
	ret
.Lfunc_end2:
	.size	_GLOBAL__sub_I_mul.cpp, .Lfunc_end2-_GLOBAL__sub_I_mul.cpp
	.cfi_endproc
                                        // -- End function
	.type	_ZStL8__ioinit,@object          // @_ZStL8__ioinit
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.hidden	__dso_handle
	.section	.init_array,"aw",@init_array
	.p2align	3
	.xword	_GLOBAL__sub_I_mul.cpp
	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
