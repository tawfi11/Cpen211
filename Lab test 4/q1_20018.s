.globl func
.globl _start
_start: 
    MOV R0, #100
    MOV R1, #my_Array
    MOV R2, #3
    BL func
end: B end

func:
	SUB sp, sp, #24 //room for many items on stack R4-R7 + link register
	STR R3, [sp, #20] //save R3 onto stack, local argument
	STR LR, [sp, #16]//save link register
	STR R7, [sp, #12] //save R7
	STR R6, [sp, #8] //save R6
	STR R5, [sp, #4] //save R5
	STR R4, [sp, #0] //save R4

	MOV R4, R0 //R4 has copy of n
	MOV R5, R1 //R5 has copy of a
	MOV R6, R2 //R2 has copy of m
	
	SUB R0, R0, #10 //R0 = result, result = n - 10
	LDR R3, [R5] //R3 = a[0]
	ADD R3, R3, #1 //numCalls = R3 = a[0] + 1
	STR R3, [R5] //a[0] = numCalls
	CMP R4, #100 //compare n to 100
	BLE rerun //n <= 100

return:	
	CMP R3, R6 //compare numCalls to m
	STRLT R0, [R5, R3, LSL#2] //otherwise a[numCalls] = result
	LDR R4, [sp, #0] //restore R4
	LDR R5, [sp, #4] //restore R5
	LDR R6, [sp, #8] //restore R6
	LDR R7, [sp, #12] //restore R7
	LDR LR, [sp, #16] //restore link register
	LDR R3, [sp, #20] //retstore R3 from stack
	ADD sp, sp, #24 //restore stack
	MOV PC, LR

rerun:
	ADD R4, R4, #11 //n = n+11
	MOV R0, R4 //for function call
	BL func // temp = func(n+11, a, m)
	MOV R7, R0 //r7 = temp
	BL func
    B return


my_Array:
.word 0
	
	
	