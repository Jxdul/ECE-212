/*Author - Lab Tech. Last edited on Jan 14, 2022 */
/*-----------------DO NOT MODIFY--------*/
.global Display
.global printf
.global cr
.extern value
.extern getstring
.syntax unified

.text
Display:
/*-----------------Students write their subroutine here--------------------*/
PUSH {r4-r7,lr}
ldr r5,[sp,#20]      // entryCount
ldr r4,[sp,#24]      // base address of sorted values

ldr r0,=MsgEntryCount
bl printf
mov r0,r5
bl value
bl cr

ldr r0,=MsgSorted
bl printf
bl cr

movs r6,#0
DisplayLoop:
cmp r6,r5
beq DisplayDone
ldr r0,[r4],#4
bl value
bl cr
adds r6,#1
b DisplayLoop

DisplayDone:
ldr r0,=MsgEnded
bl printf
bl cr
POP {r4-r7,pc}
/*-------Code ends here ---------------------*/

/*-----------------Add your strings here in the data section--------*/
.data
MsgEntryCount:
.string "The number of entries entered was "
MsgSorted:
.string "Sorted from smallest to biggest, the numbers are:"
MsgEnded:
.string "Program ended"

