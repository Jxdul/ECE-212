/*Author - Lab Tech. Last edited on Jan 14, 2022 */
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
bl printf
bl cr
bl getstring
mov r5,r0
cmp r5,#3
blt EntryCountTooLow
cmp r5,#10
bgt EntryCountTooHigh
b BoundsLoop

EntryCountTooLow:
ldr r0,=ErrEntryTooLow
bl printf
bl cr
b EntryCountLoop

EntryCountTooHigh:
ldr r0,=ErrEntryTooHigh
bl printf
bl cr
b EntryCountLoop

BoundsLoop:
ldr r0,=PromptLower
bl printf
bl cr
bl getstring
mov r6,r0

ldr r0,=PromptUpper
bl printf
bl cr
bl getstring
mov r7,r0

cmp r6,r7
ble StartValueLoop
ldr r0,=ErrBounds
bl printf
bl cr
b BoundsLoop

StartValueLoop:
movs r8,#0

ValueLoop:
cmp r8,r5
beq ExitWelcomePrompt

subs r0,r5,#1
cmp r8,r0
bne PromptNormalValue
ldr r0,=PromptLastValue
bl printf
b ReadValue

PromptNormalValue:
ldr r0,=PromptValue
bl printf

ReadValue:
bl cr
bl getstring
cmp r0,r6
blt InvalidValue
cmp r0,r7
bgt InvalidValue
str r0,[r4],#4
adds r8,#1
b ValueLoop

InvalidValue:
ldr r0,=ErrOutOfRange
bl printf
bl cr
b ValueLoop

ExitWelcomePrompt:
str r5,[sp,#24]
POP {r4-r8,pc}

/*-------Code ends here ---------------------*/

/*-----------------Add your strings here in the data section--------*/
.data
PromptEntryCount:
.string "Please enter the number(3min-10max) of entries"
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


