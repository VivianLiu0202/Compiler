	.text
	.file	"main.cpp"
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
	.globl	_Z11isOddNumberi                // -- Begin function _Z11isOddNumberi
	.p2align	2
	.type	_Z11isOddNumberi,@function
_Z11isOddNumberi:                       // @_Z11isOddNumberi
	.cfi_startproc
// %bb.0:
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	w0, [sp, #12]
	mov	w8, #1
	and	w8, w8, #0x1
	strb	w8, [sp, #11]
	ldr	w8, [sp, #12]
	mov	w9, #2
	mov	w10, #2
	sdiv	w10, w8, w9
	msub	w8, w10, w9, w8
	cbnz	w8, .LBB1_2
// %bb.1:
	strb	wzr, [sp, #11]
.LBB1_2:
	ldrb	w0, [sp, #11]
	add	sp, sp, #16
	ret
.Lfunc_end1:
	.size	_Z11isOddNumberi, .Lfunc_end1-_Z11isOddNumberi
	.cfi_endproc
                                        // -- End function
	.globl	main                            // -- Begin function main
	.p2align	2
	.type	main,@function
main:                                   // @main
	.cfi_startproc
// %bb.0:
	sub	sp, sp, #64
	stp	x29, x30, [sp, #48]             // 16-byte Folded Spill
	add	x29, sp, #48
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	wzr, [x29, #-4]
	stur	wzr, [x29, #-8]
	mov	w8, #1
	stur	w8, [x29, #-12]
.LBB2_1:                                // =>This Inner Loop Header: Depth=1
	ldur	w8, [x29, #-8]
	cmp	w8, #6
	mov	w8, wzr
	b.ge	.LBB2_3
// %bb.2:                               //   in Loop: Header=BB2_1 Depth=1
	ldur	w8, [x29, #-12]
	cmp	w8, #1
	cset	w8, eq
.LBB2_3:                                //   in Loop: Header=BB2_1 Depth=1
	tbz	w8, #0, .LBB2_5
// %bb.4:                               //   in Loop: Header=BB2_1 Depth=1
	ldursw	x8, [x29, #-8]
	adrp	x9, arr
	add	x9, x9, :lo12:arr
	mov	x10, #4
	madd	x1, x8, x10, x9
	adrp	x8, :got:_ZSt3cin
	ldr	x0, [x8, :got_lo12:_ZSt3cin]
	bl	_ZNSirsERi
	ldur	w8, [x29, #-8]
	add	w8, w8, #1
	stur	w8, [x29, #-8]
	b	.LBB2_1
.LBB2_5:
	str	xzr, [sp, #24]
	str	wzr, [sp, #20]
	stur	wzr, [x29, #-8]
.LBB2_6:                                // =>This Inner Loop Header: Depth=1
	ldur	w8, [x29, #-8]
	cmp	w8, #6
	b.ge	.LBB2_10
// %bb.7:                               //   in Loop: Header=BB2_6 Depth=1
	ldursw	x8, [x29, #-8]
	adrp	x9, arr
	add	x9, x9, :lo12:arr
	mov	x10, #4
	madd	x8, x8, x10, x9
	ldr	w0, [x8]
	bl	_Z11isOddNumberi
	and	w8, w0, #0x1
	cmp	w8, #1
	b.ne	.LBB2_9
// %bb.8:                               //   in Loop: Header=BB2_6 Depth=1
	ldursw	x8, [x29, #-8]
	adrp	x9, arr
	add	x9, x9, :lo12:arr
	mov	x10, #4
	madd	x8, x8, x10, x9
	ldr	w8, [x8]
	scvtf	d0, w8
	ldr	d1, [sp, #24]
	fadd	d0, d1, d0
	str	d0, [sp, #24]
	ldr	w8, [sp, #20]
	add	w8, w8, #1
	str	w8, [sp, #20]
.LBB2_9:                                //   in Loop: Header=BB2_6 Depth=1
	ldur	w8, [x29, #-8]
	add	w8, w8, #1
	stur	w8, [x29, #-8]
	b	.LBB2_6
.LBB2_10:
	ldr	d0, [sp, #24]
	ldr	w8, [sp, #20]
	scvtf	d1, w8
	fdiv	d0, d0, d1
	str	d0, [sp, #8]
	ldr	d0, [sp, #8]
	adrp	x8, :got:_ZSt4cout
	ldr	x0, [x8, :got_lo12:_ZSt4cout]
	bl	_ZNSolsEd
	adrp	x8, :got:_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_
	ldr	x1, [x8, :got_lo12:_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_]
	bl	_ZNSolsEPFRSoS_E
	mov	w0, wzr
	ldp	x29, x30, [sp, #48]             // 16-byte Folded Reload
	add	sp, sp, #64
	ret
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
	.cfi_endproc
                                        // -- End function
	.section	.text.startup,"ax",@progbits
	.p2align	2                               // -- Begin function _GLOBAL__sub_I_main.cpp
	.type	_GLOBAL__sub_I_main.cpp,@function
_GLOBAL__sub_I_main.cpp:                // @_GLOBAL__sub_I_main.cpp
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
.Lfunc_end3:
	.size	_GLOBAL__sub_I_main.cpp, .Lfunc_end3-_GLOBAL__sub_I_main.cpp
	.cfi_endproc
                                        // -- End function
	.type	_ZStL8__ioinit,@object          // @_ZStL8__ioinit
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.hidden	__dso_handle
	.type	arr,@object                     // @arr
	.bss
	.globl	arr
	.p2align	2
arr:
	.zero	24
	.size	arr, 24

	.section	.init_array,"aw",@init_array
	.p2align	3
	.xword	_GLOBAL__sub_I_main.cpp
	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
