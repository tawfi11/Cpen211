.include "address_map_arm.s" 

.global JTAG_ISR 
.global CHAR_BUFFER
.global CHAR_FLAG


CHAR_BUFFER:
.word 0xFF

CHAR_FLAG:
.word 0x0

JTAG_ISR:

      LDR R0, =JTAG_UART_BASE
      LDR R1, [R0]
     // LDR R2, =0xFFFF0000
     // AND R1, R1, R2
      LDR R0, =CHAR_BUFFER
      STR R1, [R0]

      LDR R0, =CHAR_FLAG
      MOV R1, #1
      STR R1, [R0]

      BX LR

.end         
