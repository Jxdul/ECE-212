/*Author - Lab Tech. Last edited on Jan 14, 2022 */
/*Jadyl Posadas - (ID:1850075) | Kevin Barrientos - (ID:1851619)*/
/*-----------------DO NOT MODIFY--------*/
.global Welcomeprompt
.global printf
.global cr
.extern value
.extern getstring
.syntax unified

.text
Welcomeprompt:
/*-----------------Students write their subroutine here--------------------*/
PUSH {r4-r8,lr}
mov r4,r0

EntryCountLoop:
ldr r0,=PromptEntryCount
bl printf // prints "Please enter the number(3min-10max) of entries followed by 'enter'"
bl cr
bl getstring // calls getstring to get the user input
mov r5,r0 // stores user input into r5
bl value
bl cr
cmp r5,#3 // compares the user input
blt EntryCountTooLow // if input less than 3, branch to EntryCountTooLow
cmp r5,#10
bgt EntryCountTooHigh // if input greater than 10, branch to EntryCountTooHigh
b BoundsLoop // if good then branch to BoundsLoop

EntryCountTooLow:
ldr r0,=ErrEntryTooLow
bl printf // prints error of count being too low aka less than 3
bl cr
b EntryCountLoop

EntryCountTooHigh:
ldr r0,=ErrEntryTooHigh // prints error of count being too large aka greater than 10
bl printf
bl cr
b EntryCountLoop

BoundsLoop:
ldr r0,=PromptLower
bl printf // prints asking for lower bounds
bl cr
bl getstring
mov r6,r0 // stores lower bounds into r6
bl value
bl cr

ldr r0,=PromptUpper //prints asking for upper bounds
bl printf
bl cr
bl getstring
mov r7,r0 // stores upper bounds into r7
bl value
bl cr

cmp r6,r7 // compares lower bounds to upper bounds
blt StartValueLoop // checks if lower bounds is less than or equal to upper bounds. if false, it prints error than asks for both again.
ldr r0,=ErrBounds
bl printf
bl cr
b BoundsLoop

StartValueLoop:
movs r8,#0 // uses r8 as the loop counter

ValueLoop:
cmp r8,r5 // compares if r8 == r5 meaning the desired number of entries has been accepted.
beq ExitWelcomePrompt

subs r0,r5,#1
cmp r8,r0 // compares the counter if its the prompt value is either not the last value, or is the last value.
bne PromptNormalValue // if its not the last value, then branch to prompt for "Please enter a number"
ldr r0,=PromptLastValue // if it is the last value, then prompt for "Please enter the last number"
bl printf
b ReadValue

PromptNormalValue:
ldr r0,=PromptValue
bl printf

ReadValue:
bl cr
bl getstring
cmp r0,r6 // check if user input is less than the lower limit, gives error if it is.
blt InvalidValue
cmp r0,r7 //check if user input is greater than the upper limit, gives error if it is
bgt InvalidValue
str r0,[r4],#4
bl value
bl cr
adds r8,#1
b ValueLoop // loops again to ask for next input.

InvalidValue:
bl value
bl cr
ldr r0,=ErrOutOfRange // prints "Invalid!!! Number entered is not within the range" if the user inputed something that isnt in the range
bl printf
bl cr
b ValueLoop

ExitWelcomePrompt:
str r5,[sp,#24] // becasue we pushed {r4-r8, lr}, the saved registers are on the stack.
				// writing r5 to [sp, #24] overwrites the saved lr slot with the entry count
POP {r4-r8,pc}

/*-------Code ends here ---------------------*/

/*-----------------Add your strings here in the data section--------*/
.data
PromptEntryCount:
.string "Please enter the number(3min-10max) of entries followed by 'enter'"
PromptLower:
.string "Please enter the lower limit"
PromptUpper:
.string "Please enter the upper limit"
PromptValue:
.string "Please enter a number"
PromptLastValue:
.string "Please enter the last number"
ErrEntryTooLow:
.string "Invalid entry, Please enter more than 2 entry"
ErrEntryTooHigh:
.string "Invalid entry, Please enter less than 11 entry"
ErrBounds:
.string "Error. Please enter the lower and upper limit again"
ErrOutOfRange:
.string "Invalid!!! Number entered is not within the range"


