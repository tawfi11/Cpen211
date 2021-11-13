//.include "address_map_arm.s"

.text
.globl _start
_start:

	ldr r0, =Array_C
	ldr r1, =Array_A
	ldr r2, =Array_B

	bl mm

idle:
	b idle





