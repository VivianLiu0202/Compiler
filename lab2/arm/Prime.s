.arch armv7-a
.arm

.section .data
input_msg: .asciz "Please input a number:\n"
prime_msg: .asciz "Is Prime\n"
not_prime_msg: .asciz "Not Prime\n"
format: .asciz "%d"
num_buffer: .space 10

@mainfunc
.section .text
.global main
.type main,%function
main:
    push {fp,lr} @将fp和lr压入堆栈，函数调用的标准前导代码
    ldr r0,=input_msg
    bl printf

    sub sp,sp,#4 @为整数变量分配4字节的空间
    ldr r0,=format
    mov r1,sp @将sp移动到r1寄存器中，也就是r1指向之前分配的空间
    bl scanf

    ldr r6,[sp,#0] @r6:输入num
    add sp,sp,#4 @释放之前为整数变量分配的空间


    cmp r6,#1 @检查数字是否<=1
    ble not_prime @如果是，跳转c

    mov r2,#2 @初始化i=2
    mov r3,#1 @初始化isPrime标志为true

check_loop:
    mul r4,r2,r2 @计算i*i
    cmp r4,r6 @将i*i与num比较
    bgt is_prime @如果是，跳转

    
    mov r0,r6 @将num放入r0
    mov r1,r2 @将i放入r1
    bl __aeabi_idivmod(PLT)
    @__aeabi_idivmod是ARM EABI中定义的一个函数，用于执行带符号的整数除法并同时返回商和余数。
    mov r4,r1 @输入：商在r0寄存器中，余数在r1寄存器中。

    cmp r4,#0 @如果余数为0，即不是质数
    beq not_prime

    add r2,r2,#1 @i++
    b check_loop @循环


not_prime:
    ldr r0,=not_prime_msg @输出不是质数的字符串
    bl printf
    b exit_program

is_prime:
    ldr r0,=prime_msg
    bl printf
    b exit_program

exit_program:
    mov r0, #0      @ 设置退出状态为0
    pop {fp,lr} @上下文切换
    bx lr @return 0
    mov r7,#1
    swi 0

.section .note.GNU-stack, "", %progbits
