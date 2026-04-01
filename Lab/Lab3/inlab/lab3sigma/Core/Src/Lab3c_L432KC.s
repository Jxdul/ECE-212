/*Author - Lab Tech. Last edited on Jan 14, 2022 */
/*Jadyl Posadas - (ID:1850075) | Kevin Barrientos - (ID:1851619)*/
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

ldr r0,=MsgEntryCount  // loads string "The number of entries entered was " into r0
bl printf // prints r0 into current line
mov r0,r5 // moves value of r5 (# of entries) into r0
bl value // prints value of r0 into current line
bl cr // goes to new line

ldr r0,=MsgSorted // loads string "Sorted from smallest to biggest, the numbers are:" into r0
bl printf // prints r0 into current line
bl cr // goes to new line

movs r6,#0 // starts r6 (counter) at 0
DisplayLoop:
cmp r6,r5
beq DisplayDone // if r6 (counter) == r5 (# of entries), branches to DisplayDone
ldr r0,[r4],#4 // loads value of r4 into r0, then indexes r4 to next value after
bl value // prints value in r0 to current line
bl cr // goes to new line
adds r6,#1 // advances counter by 1
b DisplayLoop // branches back to beginning of loop

DisplayDone:
ldr r0,=MsgEnded // loads string "Program ended" into r0
bl printf // prints r0 into current line
bl cr // goes to new line
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

