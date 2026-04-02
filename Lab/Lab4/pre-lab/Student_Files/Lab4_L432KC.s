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
ldr r4,=0xEEEEEEEE
PUSH {r4}
bl Welcomeprompt
POP {r4}

PUSH {r4}
bl Convert
POP {r4}

PUSH {r4}
bl Display
POP {r4}

/*-----------------DO NOT MODIFY--------*/
POP {PC}

.data
/*--------------------------------------*/
