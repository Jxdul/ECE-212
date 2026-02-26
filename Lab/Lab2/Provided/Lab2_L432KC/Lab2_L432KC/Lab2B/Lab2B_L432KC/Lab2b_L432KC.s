/*Author - Lab Tech. Last edited on Jan 14, 2022 */
/*-----------------DO NOT MODIFY--------*/
.global TestAsmCall
.global printf
.global cr
.syntax unified

.text
TestAsmCall:
PUSH {lr}
/*--------------------------------------*/

/*-------Students write their code here ------------*/
.equ Opcode, 0x20001000

PUSH {r4-r11}

/* Load parameters from opcode at 0x20001000 */
ldr r4, =Opcode
ldr r5, [r4]           /* r5 = n (number of data points) */
ldr r6, [r4, #4]       /* r6 = addr of X data points */
ldr r7, [r4, #8]       /* r7 = addr of Y data points */
ldr r8, [r4, #12]      /* r8 = temp storage addr */
ldr r9, [r4, #16]      /* r9 = result addr */

/* Compute deltaX = X[1] - X[0] */
ldr r0, [r6]           /* X[0] */
ldr r1, [r6, #4]       /* X[1] */
sub r12, r1, r0       /* r12 = deltaX (1, 2, or 4) */

/* Initialize sum = 0 */
movs r10, #0
movs r11, #0           /* r11 = index (byte offset) */
lsl r0, r5, #2        /* r0 = n*4 (byte limit) */

/* Loop: sum = y0 + 2*y1 + 2*y2 + ... + 2*y_{n-1} + y_n */
trap_loop:
cmp r11, r0
bge trap_loop_done

/* Check if first (i=0) or last (i=n-1) index */
cmp r11, #0
beq add_coeff1
sub r1, r0, #4        /* r1 = (n-1)*4 */
cmp r11, r1
beq add_coeff1

/* Middle: add 2*y_i (use LSL for multiply by 2) */
ldr r1, [r7, r11]
lsl r1, r1, #1        /* 2*y_i */
add r10, r10, r1
b trap_next

add_coeff1:
ldr r1, [r7, r11]
add r10, r10, r1

trap_next:
add r11, r11, #4
b trap_loop

trap_loop_done:

/* result = (deltaX * sum) / 2, round up if fraction */
mov r0, r10            /* r0 = sum */
cmp r12, #4
bne check_dx2
lsl r0, r10, #2       /* deltaX=4: prod = sum*4 */
b apply_div2
check_dx2:
cmp r12, #2
bne prod_done
lsl r0, r10, #1       /* deltaX=2: prod = sum*2 */
b apply_div2
prod_done:
/* deltaX=1: prod = sum (r0 already has sum) */

apply_div2:
lsr r1, r0, #1        /* r1 = prod/2 (truncated) */
tst r0, #1             /* check if prod was odd */
beq no_round
add r1, r1, #1         /* round up if fraction */
no_round:
str r1, [r9]           /* store final area */

POP {r4-r11}


/*-------Code ends here ---------------------*/

/*-----------------DO NOT MODIFY--------*/
POP {PC}

.data
/*--------------------------------------*/
