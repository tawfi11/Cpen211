.text
.global _start

_start:
	BL CONFIG_VIRTUAL_MEMORY
// Step 1-3: 
	//configure PMN0 to count cycles
	MOV R0, #0 // Write 0 into R0 then PMSELR
	MCR p15, 0, R0, c9, c12, 5 // Write 0 into PMSELR selects PMN0
	MOV R1, #0x11 // Event 0x11 is CPU cycles
	MCR p15, 0, R1, c9, c13, 1 // Write 0x11 into PMXEVTYPER (PMN0 measure CPU cycles)

	//configure PMN1 to calculate Cache misses
	MOV R0, #1
	MCR p15, 0, R0, c9, c12, 5 // Write 1 into PMSELR selects PMN1
	MOV R1, #0x3 // Event 0x3 is Level 1 data cache misses
	MCR p15, 0, R1, c9, c13, 1 // Write 0x3 into PMXEVTYPER (PMN1 measure Level 1 data cache misses)


	//configure PMN2 to calculate Number of load instructions executed
	MOV R0,  #2
	MCR p15, 0, R0, c9, c12, 5 // Write 2 into PMSELR selects PMN2
	MOV R1, #0x6 // Event 0x6 is Number of load instructions executed
	MCR p15, 0, R1, c9, c13, 1 // Write 0x6 into PMXEVTYPER (PMN2 measure Number of load instructions executed)


// Step 4: 
	//enable PMN0-PMN2
	mov R0, #0b111 // PMN0-2 is bit 0 of PMCNTENSET
	MCR p15, 0, R0, c9, c12, 1 // Setting bit 0-2 of PMCNTENSET enables PMN0-2

	// Step 5: 
	//clear all counters and start counters
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
	ldr r6, [r1, r5, LSL #4] // read data from memory
	add r5, r5, #1 // j=j+1
	cmp r5, r2 // compare j with 256
	blt L_inner_loop // branch if less than
	add r4, r4, #1 // i=i+1
	cmp r4, r3 // compare i with 2
	blt L_outer_loop // branch if less than
	// Step 7: stop counters
	mov r0, #0
	MCR p15, 0, r0, c9, c12, 0 // Write 0 to PMCR to stop counters
	// Step 8-10: Select PMN0-PMN2 and read out result into R3-5
	mov r0, #0 // PMN0
	MCR p15, 0, R0, c9, c12, 5 // Write 0 to PMSELR
	MRC p15, 0, R3, c9, c13, 2 // Read PMXEVCNTR into R3

	mov r0, #1 // PMN1
	MCR p15, 0, R0, c9, c12, 5 // Write 1 to PMSELR
	MRC p15, 0, R4, c9, c13, 2 // Read PMXEVCNTR into R4

	mov r0, #2 // PMN2
	MCR p15, 0, R0, c9, c12, 5 // Write 2 to PMSELR
	MRC p15, 0, R5, c9, c13, 2 // Read PMXEVCNTR into R5

end: b end // wait here
