/*Author - Lab Tech. Last edited on Jan 14, 2022 */
/*-----------------DO NOT MODIFY--------*/
.global TestAsmCall
.global printf
.global cr
.extern value
.extern getstring
.syntax unified

.text
TestAsmCall:
PUSH {lr}
/*--------------------------------------*/
//Note - On purpose. Did not preserve the registers
ldr r0,=0x20001000 // Note- TAs will change this during the demo to see if you hardcoded your answer
ldr r4,=0xFFFFFFFF
PUSH {r4}
bl Welcomeprompt
POP {r4}
ldr r0,=0x20001000 // Note- TAs will change this during the demo to see if you hardcoded your answer
PUSH {r4}
bl Sort
POP {r4}
ldr r5,=0x20001000
PUSH {r5}
PUSH {r4}
ldr r0,=0x20002000
bl Display
POP {r4}
POP {r5}
/*-----------------DO NOT MODIFY--------*/
POP {PC}
.data
/*--------------------------------------*/
