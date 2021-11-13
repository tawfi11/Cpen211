.text
.global _start
_start:
    BL CONFIG_VIRTUAL_MEMORY
// Step 1-3: configure PMN0 to count cycles
    MOV R0, #0 // Write 0 into R0 then PMSELR
    MCR p15, 0, R0, c9, c12, 5 // Write 0 into PMSELR selects PMN0
    MOV R1, #0x11 // Event 0x11 is CPU cycles
    MCR p15, 0, R1, c9, c13, 1 // Write 0x11 into PMXEVTYPER (PMN0 measure CPU cycles)
// Step 4: enable PMN0
    mov R0, #1 // PMN0 is bit 0 of PMCNTENSET
    MCR p15, 0, R0, c9, c12, 1 // Setting bit 0 of PMCNTENSET enables PMN0
// Step 5: clear all counters and start counters
    mov r0, #3 // bits 0 (start counters) and 1 (reset counters)
    MCR p15, 0, r0, c9, c12, 0 // Setting PMCR to 3
// Step 6: code we wish to profile using hardware counters
    mov r1, #0x00100000 // base of array
    mov r2, #0x100 // iterations of inner loop
    mov r3, #2 // iterations of outer loop
    mov r4, #0 // i=0 (outer loop counter)
L_outer_loop:
    mov r5, #0 // j=0 (inner loop counter)
L_inner_loop:
    ldr r6, [r1, r5, LSL #2] // read data from memory
    add r5, r5, #1 // j=j+1
    cmp r5, r2 // compare j with 256
    blt L_inner_loop // branch if less than
    add r4, r4, #1 // i=i+1
    cmp r4, r3 // compare i with 2
    blt L_outer_loop // branch if less than
// Step 7: stop counters
    mov r0, #0
    MCR p15, 0, r0, c9, c12, 0 // Write 0 to PMCR to stop counters
// Step 8-10: Select PMN0 and read out result into R3
    mov r0, #0 // PMN0
    MCR p15, 0, R0, c9, c12, 5 // Write 0 to PMSELR
    MRC p15, 0, R3, c9, c13, 2 // Read PMXEVCNTR into R3
end: b end // wait here
