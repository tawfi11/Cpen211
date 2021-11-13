.globl foo
.globl bar
.globl _start

_start:
    mov r0, #my_array
    mov r1, #3 
    bl foo

end:
    b end

foo:
    sub sp, sp, #40
    str r8, [sp, #36]
    str r0, [sp, #32]
    str r1, [sp, #28]
    str r2, [sp, #24]
    str r3, [sp, #20]
    str r4, [sp, #16] //store registers to use for later
    str r5, [sp, #12]
    str r6, [sp, #8]
    str r7, [sp, #4]
    str lr, [sp, #0] //save lr

    mov r4, r0 //r4 = *A
    mov r5, r1 //r5 = n

    cmp r5, #0
    ble foo_if_return //if (n <= 0) it goes to the recurive call

    //foo recursion
    sub sp, sp, #4
    str r5, [sp, #0] //store original n
    sub r7, r5, #1 //n-1 for foo recall
    mov r1, r7 //mov n-1 into r1 to replace n in foo recursive call
    mov r0, r4 //mov *A into r0 for recursive call
    bl foo //call foo
    ldr r5, [sp, #0] //get original n back
    add sp, sp, #4
    mov r6, r0 //r6 = outcome of foo(A,n-1)
    mov r0, r4 //r0 = *A
    mov r1, r6 //r1 = contents of outcome foo(A,n-1)
    bl bar
    mov r6, r0 //r6 = contents of bar call
    sub r6, r5, r6 //r6 = tmp = n - bar(A,foo(A,n-1))
    str r6, [r4, r7] //A[n-1] = tmp

    //foo return
    mov r0, r6 //return tmp
    ldr lr, [sp, #0] //restore registers
    ldr r7, [sp, #4]
    ldr r6, [sp, #8]
    ldr r5, [sp, #12]
    ldr r4, [sp, #16]
    ldr r3, [sp, #20]
    ldr r2, [sp, #24]
    ldr r1, [sp, #28]
    ldr r8, [sp, #32]
    add sp, sp, #40
    mov pc, lr


foo_if_return:
    mov r0, #1 //return 1
    ldr lr, [sp, #0] //restore registers
    ldr r7, [sp, #4]
    ldr r6, [sp, #8]
    ldr r5, [sp, #12]
    ldr r4, [sp, #16]
    ldr r3, [sp, #20]
    ldr r2, [sp, #24]
    ldr r1, [sp, #28]
    ldr r8, [sp, #32]
    add sp, sp, #40
    mov pc, lr

bar:
    sub sp, sp, #40
    str r8, [sp, #36]
    str r0, [sp, #32]
    str r1, [sp, #28]
    str r2, [sp, #24]
    str r3, [sp, #20]
    str r4, [sp, #16] //store registers to use for later
    str r5, [sp, #12]
    str r6, [sp, #8]
    str r7, [sp, #4]
    str lr, [sp, #0] //save lr

    mov r4, r0 //r4 = *A
    mov r5, r1 //r5 = n

    cmp r5, #0 //compare n and 0
    ble bar_if_return //if(n<=0)

/*bar recursive call */
    sub r7, r5, #1 //r7 = n-1
    mov r1, r7 //r1 = n-1 for recursive call
    mov r0, r4 //r0 = *A for recursive bar call
    bl bar //link to bar
    mov r6, r0 //r6 = outcome of bar recall 
    mov r0, r4 //r0 = *A for foo call
    mov r1, r6 //r1 = outcome of bar recall
    bl foo
    mov r0, r7 //r7 = temporary hold of foo call
    sub r7, r5, r7 //r7 = n - foo(A,bar(A,n-1))

    //return of bar recursive call
    mov r0, r7 //r0 holds return
    ldr lr, [sp, #0] //restore registers
    ldr r7, [sp, #4]
    ldr r6, [sp, #8]
    ldr r5, [sp, #12]
    ldr r4, [sp, #16]
    ldr r3, [sp, #20]
    ldr r2, [sp, #24]
    ldr r1, [sp, #28]
    ldr r8, [sp, #32]
    add sp, sp, #40
    mov pc, lr

bar_if_return:
    mov r0, r7 //r0 holds return
    ldr lr, [sp, #0] //restore registers
    ldr r7, [sp, #4]
    ldr r6, [sp, #8]
    ldr r5, [sp, #12]
    ldr r4, [sp, #16]
    ldr r3, [sp, #20]
    ldr r2, [sp, #24]
    ldr r1, [sp, #28]
    ldr r8, [sp, #32]
    add sp, sp, #40
    mov pc, lr

my_array:
    .word 0
    .word 0
    .word 0