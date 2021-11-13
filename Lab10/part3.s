// taken from interrupt_example.s


.include    "address_map_arm.s" 
.include    "interrupt_ID.s" 

/* ********************************************************************************
 * This program demonstrates use of interrupts with assembly language code.
 * The program responds to interrupts from the pushbutton KEY port in the FPGA.
 *
 * The interrupt service routine for the pushbutton KEYs indicates which KEY has
 * been pressed on the LED display.
 ********************************************************************************/


.section    .vectors, "ax" 

            B       _start                  // reset vector
            B       SERVICE_UND             // undefined instruction vector
            B       SERVICE_SVC             // software interrrupt vector
            B       SERVICE_ABT_INST        // aborted prefetch vector
            B       SERVICE_ABT_DATA        // aborted data vector
.word       0 // unused vector
            B       SERVICE_IRQ             // IRQ interrupt vector
            B       SERVICE_FIQ             // FIQ interrupt vector

.text        
.global     _start 
_start:                                     
/* Set up stack pointers for IRQ and SVC processor modes */
            MOV     R1, #0b11010010         // interrupts masked, MODE = IRQ
            MSR     CPSR_c, R1              // change to IRQ mode
            LDR     SP, =A9_ONCHIP_END - 3  // set IRQ stack to top of A9 onchip memory
/* Change to SVC (supervisor) mode with interrupts disabled */
            MOV     R1, #0b11010011         // interrupts masked, MODE = SVC
            MSR     CPSR, R1                // change to supervisor mode
            LDR     SP, =DDR_END - 3        // set SVC stack to top of DDR3 memory

            BL      CONFIG_GIC              // configure the ARM generic interrupt controller

                                            // write to the pushbutton KEY interrupt mask register
            LDR     R0, =KEY_BASE           // pushbutton KEY base address
            MOV     R1, #0xF               // set interrupt mask bits
            STR     R1, [R0, #0x8]          // interrupt mask register is (base + 8)

            MOV     R0, #0b01010011         // IRQ unmasked, MODE = SVC
            MSR     CPSR_c, R0     
                                            // enable IRQ interrupts in the processor

            LDR     R0, =MPCORE_PRIV_TIMER           // MPCORE_PRIV_TIMER base address
            LDR     R1, =100000000              //    set load value (1nitialling value)
            STR     R1, [R0]          // load value register is (base)

            MOV     R1, #0b111     //SET I,A,E to 1
            STR     R1, [R0, #8]    // I,A,E register is (base + 8)

            LDR     R0, =JTAG_UART_BASE
            MOV     R1, #0b01       //SET RE  to 1 AND WE to 0
            STRB    R1, [R0, #4]     //RE AND WE ARE IN (base + 4)
   

IDLE:       
            LDR R0, =CHAR_FLAG
            LDR R1, [R0]

            CMP R1, #1
            MOVEQ R1, #0
            STREq R1, [R0]

            LDReq R0, =CHAR_BUFFER
            LDReq R0, [R0]
            
            BLEQ PUT_JTAG

 //           BLEQ READING

            B       IDLE                    // main program simply idles

/* Define the exception service routines */

/*--- Undefined instructions --------------------------------------------------*/
SERVICE_UND:                                
            B       SERVICE_UND             

/*--- Software interrupts -----------------------------------------------------*/
SERVICE_SVC:                                
            B       SERVICE_SVC             

/*--- Aborted data reads ------------------------------------------------------*/
SERVICE_ABT_DATA:                           
            B       SERVICE_ABT_DATA        

/*--- Aborted instruction fetch -----------------------------------------------*/
SERVICE_ABT_INST:                           
            B       SERVICE_ABT_INST        

/*--- IRQ ---------------------------------------------------------------------*/
SERVICE_IRQ:                                
            PUSH    {R0-R7, LR}             

/* Read the ICCIAR from the CPU interface */
            LDR     R4, =MPCORE_GIC_CPUIF   
            LDR     R5, [R4, #ICCIAR]       // read from ICCIAR

FPGA_IRQ1_HANDLER:                          
            CMP     R5, #KEYS_IRQ           
            BLEQ    KEY_ISR
            CMP     R5, #KEYS_IRQ
            BEQ     EXIT_IRQ

            CMP     R5, #MPCORE_PRIV_TIMER_IRQ
            BLEQ    TIMER_ISR
            BEQ     EXIT_IRQ

            CMP      R5, #JTAG_IRQ
            BLEQ     JTAG_ISR
            CMP      R5, #JTAG_IRQ
            BEQ      EXIT_IRQ

UNEXPECTED: B     UNEXPECTED              // if not recognized, stop here

EXIT_IRQ:                                   
/* Write to the End of Interrupt Register (ICCEOIR) */
            STR     R5, [R4, #ICCEOIR]      // write to ICCEOIR

            POP     {R0-R7, LR}             
            SUBS    PC, LR, #4              

/*--- FIQ ---------------------------------------------------------------------*/
SERVICE_FIQ:                                
            B       SERVICE_FIQ             
       

PUT_JTAG:
      LDR R1, =0xFF201000 // JTAG UART base address
      LDR R2, [R1, #4] // read the JTAG UART control register
      LDR R3, =0xFFFF
      ANDS R2, R2, R3 // check for write space
      BEQ END_PUT // if no space, ignore the character
      STR R0, [R1] // send the character
END_PUT:  BX LR


.end         

