/*Author - Lab Tech. Last edited on Jan 14, 2022 */
/*Jadyl Posadas - (ID:1850075) | Kevin Barrientos - (ID:1851619)*/
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

LDR R0, =0x20001000
LDR R1, =0x20003000

loop:
	@load ascii char
	LDR R2, [R0]

	@check for enter character
	CMP R2, #0x0D
	BEQ exit

	@check valid uppercase letters
	CMP R2, #0x41
	BLT invalid
	CMP R2, #0x5A
	BLE tolower

	@check valid lowercase letters
	CMP R2, #0x61
	BLT invalid
	CMP R2, #0x7A
	BLE toupper

	@branch invalid if no conditions go through
	B invalid

tolower:
	ADD R3, R2, #0x20
	B store

toupper: SUB R3, R2, #0x20
	B store

invalid:
	 MOV R3, #0x2A
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
