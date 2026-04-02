/*Author - Lab Tech. Last edited on Jan 14, 2022 */
/*-----------------DO NOT MODIFY--------*/
.global Display
.global printf
.global cr
.extern value
.extern getstring
.extern offled()
.extern onled()
.extern column()
.extern row()
.syntax unified

.text
Display:
/*--------------------------------------*/

/*-------Students write their code here ------------*/
PUSH {R4-R7, LR}
BL   offled

MOV  R7, #0

repeat_loop:
MOV  R5, #0

row_loop:
LDR  R0, [SP, #20]
LDRB R6, [R0, R5]
MOV  R4, #0

col_loop:
MOV  R1, #0x80
LSR  R1, R1, R4
TST  R6, R1
BEQ  skip_led

MOV  R0, R5
BL   row
MOV  R0, R4
BL   column
BL   onled
MOV  R0, #1
BL   HAL_Delay
BL   offled

skip_led:
ADD  R4, R4, #1
CMP  R4, #8
BLT  col_loop

ADD  R5, R5, #1
CMP  R5, #8
BLT  row_loop

ADD  R7, R7, #1
CMP  R7, #50
BLT  repeat_loop

POP  {R4-R7, PC}
























/*-------Code ends here ---------------------*/

/*-----------------DO NOT MODIFY--------*/
.data
/*--------------------------------------*/
