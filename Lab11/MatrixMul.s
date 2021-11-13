/*x  RN 0   ; 1st argument address of x in r0
y  RN 1   ; 2nd argument address of y in r1
z  RN 2   ; 3rd argument address of z in r2
i  RN 3   ; local variable i
j  RN 4   ; local variable j
k  RN 5   ; local variable k
n  RN 7   ;local variable N constant
xijAddr RN 6   ; address of x[i][j]
tempAddr    RN 12  ; address of y[i][j] or z[i][j]

my_array:*/

.global mm
.global Array_A
.global Array_B
.global Array_C

mm:
    mov r7, #3
    mov r10, #256
    SUB  sp,sp, #24     //  make room on stack for 3 registers
    STR  r4, [sp, #20]  //  save r4 on stack
    STR  r5, [sp, #16]  //  save r5 on stack
    STR  r6,  [sp, #12] //  save r6 on stack
    str r7, [sp, #8]
    str r8, [sp, #4]
    str r9, [sp, #0]
    MOV   r3,  #0   //  i = 0// initialize 1st for loop
L1: 
    MOV   r4,  #0  //  j = 0// restart 2nd for loop
L2: 
    MOV   r5,  #0  //  k = 0// restart 3rd for loop
    mul r9, r3, r7 //multiply i by row size (n)
    add r6, r4, r9 //add the product and j to get address of xij
    add r6, r0, r6, LSL #3 //convert into bytes
    .word 0b11101101100101100100101100000000 //0b = binary
    //FLDD d4, [xijAddr, #0] 
    //.word 0b11101101100010100100101100000000 //store what's in d4 in mem 0xFFF
L3:
    mul r9, r5, r7
    add r12, r4, r9
    add r12, r2, r12, LSL#3
    .word 0b11101101100111000010101100000000
    //FLDD d2, [tempAddr, #0]
    mul r9, r3, r7
    add r12, r5, r9
    add r12, r1, r12, LSL #3
    .word 0b11101101100111000110101100000000
    //FLDD d6, [tempAddr, #0]
    .word 0b11101110001001100010101100000010
    //FMULD d2, d6, d2
    .word 0b11101110001101000100101100000010
    //FADDD d4, d4, d2
    ADD r5, r5, #1
    CMP r5, r7
    blt L3
    .word 0b11101101100001100100101100000000
    //FSTD d4, [xijAddr, #0]
    add r4,r4, #1
    cmp r4, r7
    blt L2
    add r3,r3, #1
    cmp r3, r7
    blt L1


     ldr  r4, [sp, #20]  //  save r4 on stack
    ldr  r5, [sp, #16]  //  save r5 on stack
    ldr  r6,  [sp, #12] //  save r6 on stack
    ldr r7, [sp, #8]
    ldr r8, [sp, #4]
    ldr r9, [sp, #0]

    add sp, sp, #24

    mov pc, lr 


Array_A:
.double 1.001
.double 1.002
.double 1.003
.double 2.001
.double 2.002
.double 2.003
.double 3.001
.double 3.002
.double 3.003

Array_B:
.double 1.000
.double 1.000
.double 1.000
.double 2.000
.double 2.000
.double 2.000
.double 3.000
.double 3.000
.double 3.000

Array_C:
.double 0.0
.double 0.0
.double 0.0
.double 0.0
.double 0.0
.double 0.0
.double 0.0
.double 0.0
.double 0.0