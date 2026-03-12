/*Author - Lab Tech. Last edited on Jan 14, 2022 */
/*-----------------DO NOT MODIFY--------*/
.global TestAsmCall
.global printf
.global cr
.extern value
.extern value1
.extern getstring
.syntax unified

.text
TestAsmCall:
PUSH {lr}
bl cr
ldr r0, =StackValue
bl printf
mov r0,sp
bl value1
bl cr
Repeat:
bl cr
ldr r0, =Prompt
bl printf
bl cr
ldr r0, =Sub1
bl printf
bl cr
ldr r0, =Sub2
bl printf
bl cr
ldr r0, =Sub3
bl printf
bl cr
ldr r0, =Sub4
bl printf
bl cr
bl printf
bl getstring
mov r4,r0
bl cr
cmp r4,#1
beq ChkSub1
cmp r4,#2
beq ChkSub2
cmp r4,#3
beq ChkSub3
cmp r4,#4
beq ChkSub4
ldr r0, =Invalid
bl printf
bal Repeat
ChkSub4:
ldr r0,=0x20001000 
ldr r4,=0xFFFFFFFF
PUSH {r4}
bl Welcomeprompt
POP {r4}
ldr r0,=0x20001000 // Note- TAs will change this during the demo to see if you hardcoded your answer
PUSH {r4}
bl Sort
POP {r4}
ldr r5,=0x20001000
ldr r0,=0x20001000 // Note- TAs will change this during the demo to see if you hardcoded your answer
PUSH {r5}
PUSH {r4}
ldr r0,=0x20002000
bl Display
POP {r4}
POP {r5}
bal Exit
ChkSub3:
mov r4,sp
PUSH {r4}
ldr r0, =Subroutine3
bl printf
bl cr
ldr r5,=0x20001000
PUSH {r5}
PUSH {r6}
ldr r4, =#0x44444444
ldr r5, =#0x55555555
ldr r6, =#0x66666666
bl Display
RegCheck2:
ldr r0,=#0x44444444
cmp r4,r0
bne RegisterModify2
ldr r0,=#0x55555555
cmp r5,r0
bne RegisterModify2
ldr r0,=#0x66666666
cmp r6,r0
bne RegisterModify2
bal Next4
RegisterModify2:
ldr r0, =RegisterError
bl printf
bl cr
Next4:
POP {r6}
POP {r5}
POP {r4}
cmp r4,sp
beq Next5
ldr r0, =StackError
bl printf
bl cr
Next5:
bal Repeat
ChkSub1:
mov r4,sp
PUSH {r4}
ldr r5, =#0x55555555
ldr r6, =#0x66666666
ldr r4, =#0x44444444
ldr r0, =Subroutine1
bl printf
bl cr
PUSH {r4}
ldr r0,=0x20001000 // Note- TAs will change this during the demo to see if you hardcoded your answer
bl Welcomeprompt
RegCheck:
ldr r0,=#0x44444444
cmp r4,r0
bne RegisterModify
ldr r0,=#0x55555555
cmp r5,r0
bne RegisterModify
ldr r0,=#0x66666666
cmp r6,r0
bne RegisterModify
bal Next
RegisterModify:
ldr r0, =RegisterError
bl printf
bl cr
Next:
POP {r6}
POP {r5}
cmp r5,sp
beq Next1
ldr r0, =StackError
bl printf
bl cr
Next1:
ldr r0, =KeyboardEntry
bl printf
mov r0,r6
bl value
bl cr
bal Repeat
ChkSub2:
mov r4,sp
PUSH {r4}
ldr r0, =Subroutine2
bl printf
bl cr
ldr r0, =BeforeSort
bl printf
bl cr
mov r5,r6
ldr r4, =#0x20001000
Repeat1:
ldr r0,[r4]
bl value
bl cr
add r4,#4
sub r5,#1
cmp r5,#0
bne Repeat1
bl cr
PUSH {r6}
ldr r4, =#0x44444444
ldr r5, =#0x55555555
ldr r6, =#0x66666666
ldr r0,=0x20001000 // Note- TAs will change this during the demo to see if you hardcoded your answer
bl Sort
RegCheck1:
ldr r0,=#0x44444444
cmp r4,r0
bne RegisterModify1
ldr r0,=#0x55555555
cmp r5,r0
bne RegisterModify1
ldr r0,=#0x66666666
cmp r6,r0
bne RegisterModify1
bal Next2
RegisterModify1:
ldr r0, =RegisterError
bl printf
bl cr
Next2:
POP {r6}
POP {r5}
cmp r5,sp
beq Next3
ldr r0, =StackError
bl printf
bl cr
Next3:
mov r5,r6
ldr r4, =#0x20001000
ldr r0, =AfterSort
bl printf
bl cr
Repeat2:
ldr r0,[r4]
bl value
bl cr
add r4,#4
sub r5,#1
cmp r5,#0
bne Repeat2
bl cr
bal Repeat

Exit:
bl cr
ldr r0, =StackValue1
bl printf
mov r0,sp
bl value1
bl cr
/*-----------------DO NOT MODIFY--------*/
POP {PC}

.data
/*--------------------------------------*/
StackValue:
.string "The stack at the beginning is set at SP = "
StackValue1:
.string "The stack at end is set at SP = "
Prompt:
.string "Testing Subroutines. Choose from the menu below(Chronological order)"
Sub1:
.string "1 - Test First subroutine"
Sub2:
.string "2 - Test Second subroutine"
Sub3:
.string "3 - Test Third subroutine"
Sub4:
.string "4 - Test All subroutine"
KeyboardEntry:
.string "The Number of entries is "
RegisterError:
.string "Register not properly restored"
Subroutine1:
.string "Testing 1st subroutine."
Subroutine2:
.string "Testing 2nd subroutine."
Subroutine3:
.string "Testing 3nd subroutine."
Subroutine4:
.string "Testing All subroutine."
TestAll:
.string "Test All subroutines and run program"
Invalid:
.string "Invalid Entry, Please enter correct entry"
StackError:
.string "Stack not properly restored"
BeforeSort:
.string "The numbers before sort:"
AfterSort:
.string "The numbers after sort:"
