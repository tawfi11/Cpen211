x  RN 0   ; 1st argument address of x in r0
y  RN 1   ; 2nd argument address of y in r1
z  RN 2   ; 3rd argument address of z in r2
i  RN 3   ; local variable i
j  RN 4   ; local variable j
k  RN 5   ; local variable k
n  RN 7   ;local variable N constant
xijAddr RN 6   ; address of x[i][j]
tempAddr    RN 12  ; address of y[i][j] or z[i][j]

my_array:

mm:
    mov n, 32
    /*SUB  sp,sp,#24     ;  make room on stack for 3 registers
    STR  r4, [sp, #20]  ;  save r4 on stack
    STR  r5, [sp, #16]  ;  save r5 on stack
    STR  r6,  [sp, #12] ;  save r6 on stack
    str r7, [sp, #8]
    str r8, [sp, #4]
    str r9, [sp, #0]*/
    MOV   i,  0   ;  i = 0; initialize 1st for loop
L1: 
    MOV   j,  0  ;  j = 0; restart 2nd for loop
L2: 
    MOV   k,  0  ;  k = 0; restart 3rd for loop
    mul r9, i, n //multiply i by row size (n)
    add xijAddr, j, r9 //add the product and j to get address of xij
    add xijAddr, x, xijAddr, LSL #3 //convert into bytes
    .word 0b00001101100101100100101100000000 //0b = binary
    //FLDD d4, [xijAddr, #0] 
L3:
    mul r9, k, n
    add tempAddr, j, r9
    add tempAddr, z, tempAddr, LSL#3
    .word 0b00001101100111000010101100000000
    //FLDD d2, [tempAddr, #0]
    mul r9, i, n
    add tempAddr k, r9
    add tempAddr, y, tempAddr, LSL #3
    .word 0b00001101100111000110101100000000
    //FLDD d6, [tempAddr, #0]
    .word 0b00001110001001100010101100000010
    //FMULD d2, d6, d2
    .word 0b00001110001101000100101100000010
    //FADDD d4, d4, d2
    ADD k, k, #1
    CMP k, n
    blt L3
    .word 0b00001101100001100100101100000000
    //FSTD d4, [xijAddr, #0]
    add j,j,#1
    cmp j, #32
    blt L2
    add i,i,#1
    cmp i, n
    blt L1
