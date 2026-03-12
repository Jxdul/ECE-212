/*Author - Lab Tech. Last edited on Jan 14, 2022 */
/*-----------------DO NOT MODIFY--------*/
.global Sort
.global printf
.global cr
.extern value
.extern getstring
.syntax unified

.text
Sort:
/*-----------------Students write their subroutine here--------------------*/
PUSH {r4-r7,lr}
mov r4,r0
ldr r5,[sp,#20]
cmp r5,#1
ble SortDone
subs r6,r5,#1

OuterLoop:
mov r7,r4
mov r3,r6

InnerLoop:
ldr r0,[r7]
ldr r1,[r7,#4]
cmp r0,r1
ble NoSwap
str r1,[r7]
str r0,[r7,#4]

NoSwap:
add r7,r7,#4
subs r3,r3,#1
bne InnerLoop

subs r6,r6,#1
bne OuterLoop

SortDone:
POP {r4-r7,pc}
/*-------Code ends here ---------------------*/

/*-----------------Add your strings here in the data section--------*/
.data
