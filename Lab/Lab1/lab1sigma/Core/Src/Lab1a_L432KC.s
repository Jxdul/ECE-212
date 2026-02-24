/*Author - Lab Tech. Last edited on Jan 14, 2022 */
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
@PUT NAMES OF STUDENTS HERE!!!!!

LDR R0, =0x20001000
LDR R1, =0x20002000

loop:
	@load ascii char
	LDR R2, [R0]

	@check for enter character
	CMP R2, #0x0D
	BEQ exit

	@check valid range of numbers
	CMP R2, #0x30
	BLT invalid
	CMP R2, #0x39
	BLE digit

	@check valid uppercase letters
	CMP R2, #0x41
	BLT invalid
	CMP R2, #0x46
	BLE upper

	@check valid lowercase letters
	CMP R2, #0x61
	BLT invalid
	CMP R2, #0x66
	BLE lower

	@branch invalid if no conditions go through
	B invalid

invalid:
	MOV R3, #0xFFFFFFFF
	B store

digit:
	SUB R3, R2, #0x30
	B store

upper:
	SUB R3, R2, #0x37
	B store

lower:
	SUB R3, R2, #0x57
	B store

store:
	STR R3, [R1]
	ADD R0, #4
	ADD R1, #4
	B loop

exit:

/*-------Code ends here ---------------------*/

/*-----------------DO NOT MODIFY--------*/
POP {PC}

.data
/*--------------------------------------*/
