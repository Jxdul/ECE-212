/* In-lab rewritten Part B trapezoidal-rule implementation */
.equ Opcode, 0x20001000

PUSH {r4-r11}

/* Load parameters from opcode at 0x20001000 */
ldr r4, =Opcode
ldr r5, [r4]           /* r5 = n (number of data points) */
ldr r6, [r4, #4]       /* r6 = addr of X data points */
ldr r7, [r4, #8]       /* r7 = addr of Y data points */
ldr r8, [r4, #12]      /* r8 = temp storage addr (unused here) */
ldr r9, [r4, #16]      /* r9 = result addr */

/* Compute deltaX = X[1] - X[0] */
ldr r0, [r6]           /* X[0] */
ldr r1, [r6, #4]       /* X[1] */
sub r12, r1, r0        /* r12 = deltaX (1, 2, or 4) */

/* Initialize sum = 0 */
movs r10, #0           /* r10 is accumulator */
movs r11, #0           /* r11 = index (byte offset) */
lsl r0, r5, #2         /* r0 = n*4 (byte limit) */

main_loop:
cmp r11, r0
bge complete

/* first and last terms use coefficient 1 */
cmp r11, #0
beq add_once
sub r1, r0, #4
cmp r11, r1
beq add_once

/* middle terms use coefficient 2 */
ldr r2, [r7, r11]
lsl r2, r2, #1
add r10, r10, r2
b next

add_once:
ldr r2, [r7, r11]
add r10, r10, r2

next:
add r11, r11, #4
b main_loop

complete:
/* product = deltaX * sum */
mov r0, r10
cmp r12, #4
bne check_dx2
lsl r0, r10, #2
b div2_round

check_dx2:
cmp r12, #2
bne div2_round
lsl r0, r10, #1

/* divide by 2 and round up if odd */
div2_round:
lsr r1, r0, #1
tst r0, #1
beq no_round
add r1, r1, #1

no_round:
str r1, [r9]

POP {r4-r11}
