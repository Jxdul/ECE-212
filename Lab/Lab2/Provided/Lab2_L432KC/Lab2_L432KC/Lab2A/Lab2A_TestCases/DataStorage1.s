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
.long 0x6
.long 0x20006000
.long 0x20005000
.long 0x20004000
.long 0x20003000
.long 0x20002000

FirstBlock:
.long 0xA
.long 0xB
.long 0xC
.long 0xD
.long 0xE
.long 0xF

SecondBlock:
.long 0xF
.long 0xE
.long 0xD
.long 0xC
.long 0xB
.long 0xA


