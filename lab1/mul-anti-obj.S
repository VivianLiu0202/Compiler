
mul.o:     file format elf64-littleaarch64


Disassembly of section .text:

0000000000000000 <main>:
   0:	d10083ff 	sub	sp, sp, #0x20
   4:	a9017bfd 	stp	x29, x30, [sp, #16]
   8:	910043fd 	add	x29, sp, #0x10
   c:	b81fc3bf 	stur	wzr, [x29, #-4]
  10:	90000008 	adrp	x8, 0 <_ZSt3cin>
  14:	f9400100 	ldr	x0, [x8]
  18:	910013e1 	add	x1, sp, #0x4
  1c:	94000000 	bl	0 <_ZNSirsERi>
  20:	52800048 	mov	w8, #0x2                   	// #2
  24:	b9000be8 	str	w8, [sp, #8]
  28:	52800028 	mov	w8, #0x1                   	// #1
  2c:	b90003e8 	str	w8, [sp]
  30:	b9400be8 	ldr	w8, [sp, #8]
  34:	b94007e9 	ldr	w9, [sp, #4]
  38:	6b09011f 	cmp	w8, w9
  3c:	5400012c 	b.gt	60 <main+0x60>
  40:	b94003e8 	ldr	w8, [sp]
  44:	b9400be9 	ldr	w9, [sp, #8]
  48:	1b097d08 	mul	w8, w8, w9
  4c:	b90003e8 	str	w8, [sp]
  50:	b9400be8 	ldr	w8, [sp, #8]
  54:	11000508 	add	w8, w8, #0x1
  58:	b9000be8 	str	w8, [sp, #8]
  5c:	17fffff5 	b	30 <main+0x30>
  60:	b94003e1 	ldr	w1, [sp]
  64:	90000008 	adrp	x8, 0 <_ZSt4cout>
  68:	f9400100 	ldr	x0, [x8]
  6c:	94000000 	bl	0 <_ZNSolsEi>
  70:	90000008 	adrp	x8, 0 <_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_>
  74:	f9400101 	ldr	x1, [x8]
  78:	94000000 	bl	0 <_ZNSolsEPFRSoS_E>
  7c:	2a1f03e0 	mov	w0, wzr
  80:	a9417bfd 	ldp	x29, x30, [sp, #16]
  84:	910083ff 	add	sp, sp, #0x20
  88:	d65f03c0 	ret

Disassembly of section .text.startup:

0000000000000000 <__cxx_global_var_init>:
   0:	a9be7bfd 	stp	x29, x30, [sp, #-32]!
   4:	f9000bf3 	str	x19, [sp, #16]
   8:	910003fd 	mov	x29, sp
   c:	90000013 	adrp	x19, 0 <__cxx_global_var_init>
  10:	91000273 	add	x19, x19, #0x0
  14:	aa1303e0 	mov	x0, x19
  18:	94000000 	bl	0 <_ZNSt8ios_base4InitC1Ev>
  1c:	90000000 	adrp	x0, 0 <_ZNSt8ios_base4InitD1Ev>
  20:	90000002 	adrp	x2, 0 <__dso_handle>
  24:	91000042 	add	x2, x2, #0x0
  28:	aa1303e1 	mov	x1, x19
  2c:	f9400000 	ldr	x0, [x0]
  30:	94000000 	bl	0 <__cxa_atexit>
  34:	f9400bf3 	ldr	x19, [sp, #16]
  38:	a8c27bfd 	ldp	x29, x30, [sp], #32
  3c:	d65f03c0 	ret

0000000000000040 <_GLOBAL__sub_I_mul.cpp>:
  40:	a9bf7bfd 	stp	x29, x30, [sp, #-16]!
  44:	910003fd 	mov	x29, sp
  48:	97ffffee 	bl	0 <__cxx_global_var_init>
  4c:	a8c17bfd 	ldp	x29, x30, [sp], #16
  50:	d65f03c0 	ret
