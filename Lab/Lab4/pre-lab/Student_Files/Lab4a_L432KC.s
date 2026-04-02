/*Author - Lab Tech. Last edited on Jan 14, 2022 */
/*-----------------DO NOT MODIFY--------*/
.global Welcomeprompt
.global printf
.global cr
.extern value
.extern getstring
.extern getchar
.extern putchar
.syntax unified

.text
Welcomeprompt:
/*--------------------------------------*/

/*-------Students write their code here ------------*/
PUSH {R4, LR}

LDR  R0, =welcome_msg
BL   printf
BL   cr

input_loop:
LDR  R0, =prompt_msg
BL   printf
BL   cr

BL   getchar
MOV  R4, R0

MOV  R0, R4
BL   putchar
BL   cr

CMP  R4, #0x30
BLO  check_uppercase
CMP  R4, #0x39
BLS  valid_input

check_uppercase:
CMP  R4, #0x41
BLO  invalid_input
CMP  R4, #0x5A
BHI  invalid_input

valid_input:
STR  R4, [SP, #8]
POP  {R4, PC}

invalid_input:
LDR  R0, =invalid_msg
BL   printf
BL   cr
B    input_loop





















/*-----------------DO NOT MODIFY--------*/

.data
/*--------------------------------------*/
welcome_msg: .asciz "Welcome to Wing's LED Display"
prompt_msg:  .asciz "Please enter an UpperCase letter or Number from the keyboard"
invalid_msg: .asciz "Invalid entry, please enter proper keystroke from keyboard"

