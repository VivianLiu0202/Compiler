
mul:     file format elf64-littleaarch64


Disassembly of section .init:

0000000000000848 <_init>:
 848:	d503201f 	nop
 84c:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
 850:	910003fd 	mov	x29, sp
 854:	94000068 	bl	9f4 <call_weak_fn>
 858:	a8c17bfd 	ldp	x29, x30, [sp], #16
 85c:	d65f03c0 	ret

Disassembly of section .plt:

0000000000000860 <.plt>:
 860:	a9bf7bf0 	stp	x16, x30, [sp, #-16]!
 864:	90000090 	adrp	x16, 10000 <__FRAME_END__+0xf35c>
 868:	f947b211 	ldr	x17, [x16, #3936]
 86c:	913d8210 	add	x16, x16, #0xf60
 870:	d61f0220 	br	x17
 874:	d503201f 	nop
 878:	d503201f 	nop
 87c:	d503201f 	nop

0000000000000880 <__cxa_finalize@plt>:
 880:	90000090 	adrp	x16, 10000 <__FRAME_END__+0xf35c>
 884:	f947b611 	ldr	x17, [x16, #3944]
 888:	913da210 	add	x16, x16, #0xf68
 88c:	d61f0220 	br	x17

0000000000000890 <_ZNSirsERi@plt>:
 890:	90000090 	adrp	x16, 10000 <__FRAME_END__+0xf35c>
 894:	f947ba11 	ldr	x17, [x16, #3952]
 898:	913dc210 	add	x16, x16, #0xf70
 89c:	d61f0220 	br	x17

00000000000008a0 <__libc_start_main@plt>:
 8a0:	90000090 	adrp	x16, 10000 <__FRAME_END__+0xf35c>
 8a4:	f947be11 	ldr	x17, [x16, #3960]
 8a8:	913de210 	add	x16, x16, #0xf78
 8ac:	d61f0220 	br	x17

00000000000008b0 <_ZNSolsEPFRSoS_E@plt>:
 8b0:	90000090 	adrp	x16, 10000 <__FRAME_END__+0xf35c>
 8b4:	f947c211 	ldr	x17, [x16, #3968]
 8b8:	913e0210 	add	x16, x16, #0xf80
 8bc:	d61f0220 	br	x17

00000000000008c0 <__cxa_atexit@plt>:
 8c0:	90000090 	adrp	x16, 10000 <__FRAME_END__+0xf35c>
 8c4:	f947c611 	ldr	x17, [x16, #3976]
 8c8:	913e2210 	add	x16, x16, #0xf88
 8cc:	d61f0220 	br	x17

00000000000008d0 <_ZNSt8ios_base4InitC1Ev@plt>:
 8d0:	90000090 	adrp	x16, 10000 <__FRAME_END__+0xf35c>
 8d4:	f947ca11 	ldr	x17, [x16, #3984]
 8d8:	913e4210 	add	x16, x16, #0xf90
 8dc:	d61f0220 	br	x17

00000000000008e0 <abort@plt>:
 8e0:	90000090 	adrp	x16, 10000 <__FRAME_END__+0xf35c>
 8e4:	f947ce11 	ldr	x17, [x16, #3992]
 8e8:	913e6210 	add	x16, x16, #0xf98
 8ec:	d61f0220 	br	x17

00000000000008f0 <_ZNSolsEi@plt>:
 8f0:	90000090 	adrp	x16, 10000 <__FRAME_END__+0xf35c>
 8f4:	f947d211 	ldr	x17, [x16, #4000]
 8f8:	913e8210 	add	x16, x16, #0xfa0
 8fc:	d61f0220 	br	x17

0000000000000900 <__gmon_start__@plt>:
 900:	90000090 	adrp	x16, 10000 <__FRAME_END__+0xf35c>
 904:	f947d611 	ldr	x17, [x16, #4008]
 908:	913ea210 	add	x16, x16, #0xfa8
 90c:	d61f0220 	br	x17

Disassembly of section .text:

0000000000000940 <__cxx_global_var_init>:
 940:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
 944:	f9000bf3 	str	x19, [sp, #16]
 948:	910003fd 	mov	x29, sp
 94c:	b0000093 	adrp	x19, 11000 <__data_start>
 950:	91004673 	add	x19, x19, #0x11
 954:	aa1303e0 	mov	x0, x19
 958:	97ffffde 	bl	8d0 <_ZNSt8ios_base4InitC1Ev@plt>
 95c:	90000080 	adrp	x0, 10000 <__FRAME_END__+0xf35c>
 960:	b0000082 	adrp	x2, 11000 <__data_start>
 964:	91002042 	add	x2, x2, #0x8
 968:	aa1303e1 	mov	x1, x19
 96c:	f947fc00 	ldr	x0, [x0, #4088]
 970:	97ffffd4 	bl	8c0 <__cxa_atexit@plt>
 974:	f9400bf3 	ldr	x19, [sp, #16]
 978:	a8c27bfd 	ldp	x29, x30, [sp], #32
 97c:	d65f03c0 	ret

0000000000000980 <_GLOBAL__sub_I_mul.cpp>:
 980:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
 984:	910003fd 	mov	x29, sp
 988:	97ffffee 	bl	940 <__cxx_global_var_init>
 98c:	a8c17bfd 	ldp	x29, x30, [sp], #16
 990:	d65f03c0 	ret
 994:	d503201f 	nop
 998:	d503201f 	nop
 99c:	d503201f 	nop
 9a0:	d503201f 	nop
 9a4:	d503201f 	nop
 9a8:	d503201f 	nop
 9ac:	d503201f 	nop
 9b0:	d503201f 	nop
 9b4:	d503201f 	nop
 9b8:	d503201f 	nop
 9bc:	d503201f 	nop

00000000000009c0 <_start>:
 9c0:	d503201f 	nop
 9c4:	d280001d 	mov	x29, #0x0                   	// #0
 9c8:	d280001e 	mov	x30, #0x0                   	// #0
 9cc:	aa0003e5 	mov	x5, x0
 9d0:	f94003e1 	ldr	x1, [sp]
 9d4:	910023e2 	add	x2, sp, #0x8
 9d8:	910003e6 	mov	x6, sp
 9dc:	90000080 	adrp	x0, 10000 <__FRAME_END__+0xf35c>
 9e0:	f947dc00 	ldr	x0, [x0, #4024]
 9e4:	d2800003 	mov	x3, #0x0                   	// #0
 9e8:	d2800004 	mov	x4, #0x0                   	// #0
 9ec:	97ffffad 	bl	8a0 <__libc_start_main@plt>
 9f0:	97ffffbc 	bl	8e0 <abort@plt>

00000000000009f4 <call_weak_fn>:
 9f4:	90000080 	adrp	x0, 10000 <__FRAME_END__+0xf35c>
 9f8:	f947f400 	ldr	x0, [x0, #4072]
 9fc:	b4000040 	cbz	x0, a04 <call_weak_fn+0x10>
 a00:	17ffffc0 	b	900 <__gmon_start__@plt>
 a04:	d65f03c0 	ret
 a08:	d503201f 	nop
 a0c:	d503201f 	nop

0000000000000a10 <deregister_tm_clones>:
 a10:	b0000080 	adrp	x0, 11000 <__data_start>
 a14:	91004000 	add	x0, x0, #0x10
 a18:	b0000081 	adrp	x1, 11000 <__data_start>
 a1c:	91004021 	add	x1, x1, #0x10
 a20:	eb00003f 	cmp	x1, x0
 a24:	540000c0 	b.eq	a3c <deregister_tm_clones+0x2c>  // b.none
 a28:	90000081 	adrp	x1, 10000 <__FRAME_END__+0xf35c>
 a2c:	f947ec21 	ldr	x1, [x1, #4056]
 a30:	b4000061 	cbz	x1, a3c <deregister_tm_clones+0x2c>
 a34:	aa0103f0 	mov	x16, x1
 a38:	d61f0200 	br	x16
 a3c:	d65f03c0 	ret

0000000000000a40 <register_tm_clones>:
 a40:	b0000080 	adrp	x0, 11000 <__data_start>
 a44:	91004000 	add	x0, x0, #0x10
 a48:	b0000081 	adrp	x1, 11000 <__data_start>
 a4c:	91004021 	add	x1, x1, #0x10
 a50:	cb000021 	sub	x1, x1, x0
 a54:	d37ffc22 	lsr	x2, x1, #63
 a58:	8b810c41 	add	x1, x2, x1, asr #3
 a5c:	9341fc21 	asr	x1, x1, #1
 a60:	b40000c1 	cbz	x1, a78 <register_tm_clones+0x38>
 a64:	90000082 	adrp	x2, 10000 <__FRAME_END__+0xf35c>
 a68:	f947f842 	ldr	x2, [x2, #4080]
 a6c:	b4000062 	cbz	x2, a78 <register_tm_clones+0x38>
 a70:	aa0203f0 	mov	x16, x2
 a74:	d61f0200 	br	x16
 a78:	d65f03c0 	ret
 a7c:	d503201f 	nop

0000000000000a80 <__do_global_dtors_aux>:
 a80:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
 a84:	910003fd 	mov	x29, sp
 a88:	f9000bf3 	str	x19, [sp, #16]
 a8c:	b0000093 	adrp	x19, 11000 <__data_start>
 a90:	39404260 	ldrb	w0, [x19, #16]
 a94:	35000140 	cbnz	w0, abc <__do_global_dtors_aux+0x3c>
 a98:	90000080 	adrp	x0, 10000 <__FRAME_END__+0xf35c>
 a9c:	f947e400 	ldr	x0, [x0, #4040]
 aa0:	b4000080 	cbz	x0, ab0 <__do_global_dtors_aux+0x30>
 aa4:	b0000080 	adrp	x0, 11000 <__data_start>
 aa8:	f9400400 	ldr	x0, [x0, #8]
 aac:	97ffff75 	bl	880 <__cxa_finalize@plt>
 ab0:	97ffffd8 	bl	a10 <deregister_tm_clones>
 ab4:	52800020 	mov	w0, #0x1                   	// #1
 ab8:	39004260 	strb	w0, [x19, #16]
 abc:	f9400bf3 	ldr	x19, [sp, #16]
 ac0:	a8c27bfd 	ldp	x29, x30, [sp], #32
 ac4:	d65f03c0 	ret
 ac8:	d503201f 	nop
 acc:	d503201f 	nop

0000000000000ad0 <frame_dummy>:
 ad0:	17ffffdc 	b	a40 <register_tm_clones>

0000000000000ad4 <main>:
 ad4:	d10083ff 	sub	sp, sp, #0x20
 ad8:	a9017bfd 	stp	x29, x30, [sp, #16]
 adc:	910043fd 	add	x29, sp, #0x10
 ae0:	b81fc3bf 	stur	wzr, [x29, #-4]
 ae4:	90000088 	adrp	x8, 10000 <__FRAME_END__+0xf35c>
 ae8:	f947f100 	ldr	x0, [x8, #4064]
 aec:	910013e1 	add	x1, sp, #0x4
 af0:	97ffff68 	bl	890 <_ZNSirsERi@plt>
 af4:	52800048 	mov	w8, #0x2                   	// #2
 af8:	b9000be8 	str	w8, [sp, #8]
 afc:	52800028 	mov	w8, #0x1                   	// #1
 b00:	b90003e8 	str	w8, [sp]
 b04:	b9400be8 	ldr	w8, [sp, #8]
 b08:	b94007e9 	ldr	w9, [sp, #4]
 b0c:	6b09011f 	cmp	w8, w9
 b10:	5400012c 	b.gt	b34 <main+0x60>
 b14:	b94003e8 	ldr	w8, [sp]
 b18:	b9400be9 	ldr	w9, [sp, #8]
 b1c:	1b097d08 	mul	w8, w8, w9
 b20:	b90003e8 	str	w8, [sp]
 b24:	b9400be8 	ldr	w8, [sp, #8]
 b28:	11000508 	add	w8, w8, #0x1
 b2c:	b9000be8 	str	w8, [sp, #8]
 b30:	17fffff5 	b	b04 <main+0x30>
 b34:	b94003e1 	ldr	w1, [sp]
 b38:	90000088 	adrp	x8, 10000 <__FRAME_END__+0xf35c>
 b3c:	f947e900 	ldr	x0, [x8, #4048]
 b40:	97ffff6c 	bl	8f0 <_ZNSolsEi@plt>
 b44:	90000088 	adrp	x8, 10000 <__FRAME_END__+0xf35c>
 b48:	f947e101 	ldr	x1, [x8, #4032]
 b4c:	97ffff59 	bl	8b0 <_ZNSolsEPFRSoS_E@plt>
 b50:	2a1f03e0 	mov	w0, wzr
 b54:	a9417bfd 	ldp	x29, x30, [sp, #16]
 b58:	910083ff 	add	sp, sp, #0x20
 b5c:	d65f03c0 	ret

Disassembly of section .fini:

0000000000000b60 <_fini>:
 b60:	d503201f 	nop
 b64:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
 b68:	910003fd 	mov	x29, sp
 b6c:	a8c17bfd 	ldp	x29, x30, [sp], #16
 b70:	d65f03c0 	ret
