/*Author - Lab Tech. Last edited on Jan 18, 2021 */
.global Intialization
.syntax unified

.text
.equ Opcode, 0x20001000

Intialization:
PUSH {lr}

ldr r4, =Opcode
ldr r5, =Instruction
movs r6, #6

again:
ldr r3,[r5]
str r3,[r4]
add r5,r5,#4
add r4,r4,#4
sub r6,#1
cmp r6,#0
bgt again

ldr r4, =Opcode
ldr r5,[r4,#4]
ldr r6,[r4]
ldr r4, =FirstBlock
again1: ldr r3,[r4]
str r3,[r5]
add r5,r5,#4
add r4,r4,#4
sub r6,#1
cmp r6,#0
bgt again1

ldr r4, =Opcode
ldr r5,[r4,#8]
ldr r6,[r4]
ldr r4, =SecondBlock
again2: ldr r3,[r4]
str r3,[r5]
add r5,r5,#4
add r4,r4,#4
sub r6,#1
cmp r6,#0
bgt again2

movs r4,r4

POP {PC}

.data
Instruction:
.long 0x9
.long 0x20002000
.long 0x20003000
.long 0x20004000
.long 0x20005000
.long 0x20006000

FirstBlock:
.long 0x1
.long 0x2
.long 0x3
.long 0x4
.long 0x5
.long 0x6
.long 0x7
.long 0x8
.long 0x9

SecondBlock:
.long 0x9
.long 0x8
.long 0x7
.long 0x6
.long 0x5
.long 0x4
.long 0x3
.long 0x2
.long 0x1


