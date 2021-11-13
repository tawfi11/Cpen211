.globl binary_search

 binary_search:
	SUB sp, sp, #24
	STR lr, [sp, #20]	//backup
	STR r7, [sp, #16]	//backup
	STR r6, [sp, #12]	//backup
	STR r5, [sp, #8]	//backup
	STR r4, [sp, #4]	//backup

	SUB r5, r3, r2	// endIndex - startIndex
	MOV r5, r5, LSR #1	//Divide by 2
	ADD r4, r2, r5	// Middle Index

	LDR r6, [sp, #24] // NumCalls
	ADD r6, r6, #1 // NUMcalls++

	CMP r2,r3
	BGT not_found // if(startIndex>endIndex)

	MOV r5, r4
	MOV r5, r5, LSL #2
	LDR r7,[r5,r0] // r7 holds Numbers[middleIndex]

	CMP r7, r1

	BLEQ found // if(Numbers[middleIndex] == key)

	BLGT L1 // if(Numbers[middleIndex] > key)

	BLLT L2 // if(Numbers[middleIndex] < key)

	mvn r6, r6
	add r6, r6, #1
	STR r6, [r5,r1]

	LDR lr, [sp, #20]	 //restoring
	LDR r7, [sp, #16]	//restoring
	LDR r6, [sp, #12]	//restoring
	LDR r5, [sp, #8]	//restoring	
	LDR r4, [sp, #4] 	
	ADD sp, sp, #24
	MOV pc, lr

not_found:
	
	MOV r1, r0
	MOV r0, #-1
	LDR lr, [sp, #20]
	LDR r7, [sp, #16]
	LDR r6, [sp, #12]
	LDR r5, [sp, #8]
	LDR r4, [sp, #4]
	ADD sp, sp, #24
	MOV pc, lr   

	found:
//	MOV r5, r4
//	MOV r5, r5, LSL #2
//	STR r6, [r5]
	MOV r1, r0
	MOV r0, r4
	MOV pc, lr


L1:
	SUB r4, r4, #1
	MOV r3, r4
	STR r6, [sp, #0]
	B binary_search

L2:
	ADD r4, r4 , #1
	MOV r2, r4
	STR r6, [sp, #0]
	B binary_search