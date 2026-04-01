/*Author - Lab Tech. Last edited on Jan 14, 2022 */
/*Jadyl Posadas - (ID:1850075) | Kevin Barrientos - (ID:1851619)*/
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
mov r4,r0 // recieves r0 as the base address of the array.
ldr r5,[sp,#20] // entry count is pulled from the stack
cmp r5,#1 // if the count is <= 1, it skips sorting because technically it is sorted already.
ble SortDone
subs r6,r5,#1 // prior to starting loop, subtracts the total element count by 1 and stores in r6 (r6 == amount of total loops remaining)

OuterLoop:
mov r7,r4 // moves r4 into r7 -- r4 being the starting element of the array
mov r3,r6 // moves 46 into r3 -- r6 being the element count - 1 (r3 == amount of remaining adjacent comparisons)

InnerLoop:
ldr r0,[r7] // loads current value of array into r0
ldr r1,[r7,#4] // loads next value of array into r1
cmp r0,r1
ble NoSwap // branches to NoSwap if current value is less than or equal to next -- doesn't run the swap in the next two lines of code
str r1,[r7] // swaps the value of the next register to the previous value
str r0,[r7,#4] // swaps the value of the current register to the next value

NoSwap:
add r7,r7,#4 // advances the current element(s) being compared
subs r3,r3,#1 // subtracts r3 by 1
bne InnerLoop // (branch is comparing to Z flag) if r3 is not equal to 0, then branches to inner loop

subs r6,r6,#1 // subtracts r6 by 1
bne OuterLoop // if r6 is not equal to 0, then branches to beginning of the outer loop (not fully sorted yet)

SortDone:
POP {r4-r7,pc}
/*-------Code ends here ---------------------*/

/*-----------------Add your strings here in the data section--------*/
.data
