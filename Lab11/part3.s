dgemm:
    /*
    Passed vars:
    r0 = int n
    r1 = double *A (first arugment address of A)
    r2 = double *B (first argument address of B)
    r3 = double *C (first argument address of C)

    local vars:
    r5 = sj
    r4 = si
    r12 = sk
     */
     mov r5, #0
dgemm_L1:
    mov r4, #0
dgemm_L2:
    mov r12, #0
dgemm_L3:
    BL do_block //branch to different function
    add, r12, r12, #32 //sk = sk + blocksize
    cmp r12, r0 
    blt dgemm_L3

    //continue on dgemm_L2
    add r4, r4, #32 //si = si + blocksize
    cmp r4, r0
    blt dgemm_L2

    //continue on dgemm_L1
    add r5, r5, #32 //sj = sj + blocksize
    cmp r5, r0
    blt dgemm_L1

    //otherwise
    B idle

do_block:
    /*
    Passed vars:
    r0 = int n
    r1 = double *A (first argument address of A)
    r2 = double *B (first argument address of B)
    r3 = double *C (first argument address of C)
    r4 = int si
    r5 = int sj
    r6 = int sk

    local vars:
    r7 = BLOCKSIZE + s...
    r8 = i
    r9 = j
    r10 = aijAddr
    r11 = tempAddr
    r12 = k
    d1 = cij
    d2 = aij
    d3 = bij
    d4 = aij * bij
     */
    //mov r7, #32 //BLOCKSiZE
    mov r8, r4 //i = si

do_block_L1:
    mov r9, r5 //j = sj
do_block_L2:
    ADD r10, r9, r8, LSL #5 //cijAddr = i*size + j
    ADD r10, r3, r10, LSL #3 //cijAddr = byte address of c[i][j]
    .word 0b11101101100110100000101100000000
    //FLDD d0, [r10, #0] //d0 = 8 bytes of c[i][j]
    mul r11, r9, r0 //j*n
    add r11, r11, r8 //i+j*n
    .word 0b11101101100110110001101100000000
    //FLDD d1, [r1, r11] // double cij = C[i+j*n]
    mov r12, r6 //k = sk
do_block_L3:
    mul r11, r12, r0 //k*n
    add r11, r11, r8 //i+k*n
    add, r11, r1, r11, LSL#3
    .word 0b11101101100110110010101100000000
    //FLDD d2, [r11, #0] //load a[i+k*n] into d2 = aij
    mul r11, r9, r0 ///j*n
    add r11, r11, r12 //k+j*n
    .word 0b11101101100110110011101100000000
    //FLDD d3, [r11, #0] //load b[k+j*n] into d3 = bij
    .word 0b11101110001000110100101100000010
   // FMULD d4, d3, d2 
    .word 0b11101110001100010001101100000100
    //FADDD d1, d1, d4 //cij = cij + (aij * bij)
    add r12, r12, #1 //k++
    add r7, r6, #32 //r7 = blocksize + sk
    cmp r12, r7
    blt do_block_L3 //loop back to do_block_L3 if k < blocksize + sk

    //continue on do_block_L2
    mul r11, r9, r0 //j*n
    add r11, r11, r8 //i+j*n
    add r11, r11, LSL #3
    .word 0b11101101100110110001101100000000
    //FSTD d1, [r11, #0] //C[i+j*n] = cij
    add r7, r5, #32 //s7 = blocksize + sj
    add r9, r9, #1 //j++
    cmp r9, r7 
    blt do_block_L2 //loop back to do_block_L2 if j < blocksize + sj

    //continue on do_block_L1
    add r7, r4, #32 //r7 = blocksize + si
    add r4, r4, #1 //i++
    cmp r4, r7
    blt do_block_L1 //loop back to do_block_L1 if i < blocksize + si
    
    //Has to return back to dgemm
  
    
idle:
    B idle //wait here