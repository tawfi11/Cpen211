.include    "address_map_arm.s" 

.global   TIMER_ISR
.global my_counter

my_counter: 	.word 0x0

TIMER_ISR:

     	LDR R0, =my_counter
     	LDR R1, [R0]

     	ADD R1, R1, #1

     	STR R1, [R0]

     	LDR R0, =LED_BASE
		STR R1, [R0]

        LDR R0, =MPCORE_PRIV_TIMER
     	MOV R1, #1
     	STR R1, [R0, #12]

     	BX      LR   

.end

