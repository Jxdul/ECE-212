/*Author - Lab Tech. Last edited on Jan 14, 2022 */
/*Jadyl Posadas - (ID:1850075) | Kevin Barrientos - (ID:1851619)*/
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

/* Load opcode base and parameters. */
ldr r4, =Opcode
ldr r5, [r4, #4]       /* r5 = address of first array (A). */
ldr r6, [r4, #8]       /* r6 = address of second array (B). */
ldr r9, [r4]           /* r9 = N (size). */

/* Part 1: register indirect with offset. */
ldr r7, [r4, #12]      /* r7 = dest1. */
ldr r0, [r5]
ldr r1, [r6]
add r2, r0, r1
str r2, [r7]
ldr r0, [r5, #4]
ldr r1, [r6, #4]
add r2, r0, r1
str r2, [r7, #4]
ldr r0, [r5, #8]
ldr r1, [r6, #8]
add r2, r0, r1
str r2, [r7, #8]

/* Part 2: indexed register indirect. */
ldr r5, [r4, #4]       /* Reload address A. */
ldr r6, [r4, #8]       /* Reload address B. */
ldr r7, [r4, #16]      /* r7 = dest2. */
lsl r10, r9, #2        /* r10 = N * 4 (byte limit for index). */
movs r8, #0            /* r8 = index. */
part2_loop:
cmp r8, r10
bge part2_done
ldr r0, [r5, r8]
ldr r1, [r6, r8]
add r2, r0, r1
str r2, [r7, r8]
add r8, r8, #4
b part2_loop
part2_done:

/* Part 3: post-increment register indirect. */
ldr r5, [r4, #4]       /* Reload address A. */
ldr r6, [r4, #8]       /* Reload address B. */
ldr r7, [r4, #20]      /* r7 = dest3. */
part3_loop:
ldr r0, [r5], #4
ldr r1, [r6], #4
add r2, r0, r1
str r2, [r7], #4
subs r9, r9, #1
bne part3_loop

POP {r4-r11}


/*-------Code ends here ---------------------*/

/*-----------------DO NOT MODIFY--------*/
POP {PC}

.data
/*--------------------------------------*/
