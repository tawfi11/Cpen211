binary_search:
    LDR r4, [sp,#0] //load numCalls into r4. It's the top of the stack because it was passed in the stack, therefore it has to be the top
    ADD r4, r4, #1 //increment numCalls
    STR r4, [sp,#0] //store numCalls back into stack
    SUB sp, sp, #36 //make room for 8 registers and lr, 1 byte = 4 bits, these will be deleted later, 
                     //local vars are temp in functions
    STR lr, [sp, #32] //store lr so it doesn't get lost
    STR r0, [sp, #28] //store whatever's in r0 so it doesn't get lost
    STR r1, [sp, #24] //store whatever's in r1 so it doesn't get lost
    STR r2, [sp, #20] //store whatever's in r2 so it doesn't get lost
    STR r3, [sp, #16] //store whatever's in r3 so it doesn't get lost
    STR r7, [sp, #12] //save r7 for use later
    STR r6, [sp, #8] //save r6 for use later
    STR r5, [sp, #4] //save r5 for use later
    STR r4, [sp, #0] //save r4 for use later

	SUB r5, r3, r2 // endIndex - startIndex
	MOV r5, r5, LSR#1 //(endIndex - startIndex)/2
	ADD r5, r5, r3 //startIndex + (endIndex - startIndex)/2
	CMP r2, r3 //compare startIndex and endIndex
    BGT if_index_true //if(startIndex > endIndex)
    LDR r6, [r0, r5, LSL#2] //r0 holds address of numbers, r5 holds an index
                            //r5 is the index but it's in bytes, you have to convert to bits by
                            //multiplying by 4. r0 is the address of the first element, get the 
                            //address of r0 + (4* r5). So r6 = numbers[middleIndex]
    CMP r6, r1 //compare numbers[middleIndex] and key
    MOVEQ r7, r5 //r7 = keyIndex = middleIndex if numbers{middleIndex] == KEY 
    BGT greater_than //If r6 > r1 goto greater_than
    B func_call //go to func_call

if_index_true:
    MOV r0, #-1 //return -1 in r0

    LDR r4, [sp, #0] //restore r4 for caller
    LDR r5, [sp, #4] //restore r5 for caller
    LDR r6, [sp, #8] //restore r6 for caller
    LDR r7, [sp, #12] //restore r7 for caller
    LDR r3, [sp, #16] //restore r3 for caller
    LDR r2, [sp, #20] //restore r2 for caller
    LDR r1, [sp, #24] //restore r1 for caller
    LDR lr, [sp, 32] //restore lr 
    ADD sp, sp, #36 //adjust stack to delete 36 items
    MOV pc, lr //restore program counter, jump back to callback routine

greater_than:
    SUB r3, r5, #1 //middleIndex - 1
    B binary_search
    MOV r7, r0
    B done

func_call:
    ADD r2, r5, #1 //middleIndex + 1
    B binary_search
    MOV r7, r0
    B done

done: 
    STR [-r4],[r0, r5, LSL#2] 

    MOV r0, r7 //move keyIndex to return

    LDR r4, [sp, #0] //restore r4 for caller
    LDR r5, [sp, #4] //restore r5 for caller
    LDR r6, [sp, #8] //restore r6 for caller
    LDR r7, [sp, #12] //restore r7 for caller
    LDR r3, [sp, #16] //restore r3 for caller
    LDR r2, [sp, #20] //restore r2 for caller
    LDR r1, [sp, #24] //restore r1 for caller
    LDR lr, [sp, 32] //restore lr 
    ADD sp, sp, #36 //adjust stack to delete 36 items
    MOV pc, lr //restore program counter, jump back to callback routine