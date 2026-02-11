/*Author - Lab Tech. Last edited on Jan 18, 2021 */
.global Intialization

.text
.equ Opcode, 0x20001000

Intialization:
PUSH {lr}

ldr r4, =Opcode
ldr r5, =FirstBlock
movs r6, #25


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
.long 0x46
.long 0x24
.long 0x74
.long 0x0e
.long 0x15
.long 0x37
.long 0x87
.long 0x65
.long 0x73
.long 0x49
.long 0x42
.long 0x64
.long 0x74
.long 0x6B
.long 0x6F
.long 0x54
.long 0x4F
.long 0x33
.long 0x47
.long 0x55
.long 0x3F
.long 0x4C
.long 0x5C
.long 0x6A
.long 0x0d

