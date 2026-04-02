/*Author - Lab Tech. Last edited on Jan 14, 2022 */
/*-----------------DO NOT MODIFY--------*/
.global Convert
.global printf
.global cr
.extern value
.extern getstring
.extern convert1
.syntax unified

.text
Convert:
/*--------------------------------------*/

/*-------Students write their code here ------------*/
PUSH {LR}
LDR  R0, [SP, #4]
PUSH {R0}
BL   convert1
POP  {R0}
STR  R0, [SP, #4]
POP  {PC}























/*-------Code ends here ---------------------*/

/*-----------------DO NOT MODIFY--------*/
.data
/*--------------------------------------*/
