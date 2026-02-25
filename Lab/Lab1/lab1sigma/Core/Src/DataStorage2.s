/*Author - Lab Tech. Last edited on Jan 18, 2021 */
.global Intialization

.text
.equ Opcode, 0x20001000

Intialization:
PUSH {lr}

ldr r4, =Opcode
ldr r5, =FirstBlock
movs r6, #20


again:
ldr r3,[r5]
str r3,[r4]
add r5,r5,#4
add r4,r4,#4
sub r6,#1
cmp r6,#0
bgt again

POP {PC}

.data
FirstBlock:
.long 0x14
.long 0x44
.long 0x54
.long 0x9A
.long 0x72
.long 0x94
.long 0x41
.long 0x75
.long 0x65
.long 0x5F
.long 0x48
.long 0x33
.long 0x89
.long 0x6A
.long 0x67
.long 0x63
.long 0x4B
.long 0x47
.long 0x66
.long 0x0D

