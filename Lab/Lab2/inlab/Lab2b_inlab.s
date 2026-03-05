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

/* Trapezoidal sum for non-uniform spacing:
 * result = ceil( sum_{i=0..n-2} (x[i+1]-x[i]) * (y[i]+y[i+1]) / 2 )
 */
movs r10, #0           /* r10 = accumulator for numerator */
movs r11, #0           /* r11 = index i */
sub r0, r5, #1         /* r0 = n-1 segments */

main_loop:
cmp r11, r0
bge complete

/* Load x[i], x[i+1] and compute dx */
lsl r1, r11, #2        /* byte offset = i*4 */
ldr r2, [r6, r1]       /* x[i] */
add r3, r1, #4
ldr r12, [r6, r3]      /* x[i+1] */
sub r12, r12, r2       /* dx */

/* Load y[i], y[i+1], compute (y[i] + y[i+1]) */
ldr r2, [r7, r1]       /* y[i] */
ldr r3, [r7, r3]       /* y[i+1] */
add r2, r2, r3         /* ysum */

/* Add dx * ysum into accumulator without MUL */
cmp r12, #4
beq mult_by_4
cmp r12, #2
beq mult_by_2
mov r1, r2             /* default: dx == 1 */
b mult_done

mult_by_2:
lsl r1, r2, #1
b mult_done

mult_by_4:
lsl r1, r2, #2

mult_done:
add r10, r10, r1

add r11, r11, #1
b main_loop

complete:
/* divide by 2 and round up if odd */
lsr r1, r10, #1
tst r10, #1
beq no_round
add r1, r1, #1

no_round:
str r1, [r9]

POP {r4-r11}
