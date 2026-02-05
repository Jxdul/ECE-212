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

@ Initialize source and destination addresses
LDR R0, =0x20001000    @ R0 = Source address (ASCII data)
LDR R1, =0x20003000    @ R1 = Destination address (converted values)

loop:
    LDR R2, [R0]        @ Load ASCII character from source

    @ Check for Enter (0x0D) - end condition
    CMP R2, #0x0D
    BEQ done
    CMP R2, #0x0A       @ Also check for line feed (0x0A)
    BEQ done

    @ Check if it's 'A'-'Z' (0x41-0x5A) - uppercase
    CMP R2, #0x41
    BLT invalid         @ If less than 'A', invalid
    CMP R2, #0x5A
    BLE to_lower        @ If <= 'Z', convert to lowercase

    @ Check if it's 'a'-'z' (0x61-0x7A) - lowercase
    CMP R2, #0x61
    BLT invalid         @ If less than 'a' (but > 'Z'), invalid
    CMP R2, #0x7A
    BLE to_upper        @ If <= 'z', convert to uppercase

    @ Otherwise invalid (> 'z')
    B invalid

to_lower:
    ADD R3, R2, #0x20   @ Convert 'A'-'Z' to 'a'-'z' (add 32)
    B store

to_upper:
    SUB R3, R2, #0x20   @ Convert 'a'-'z' to 'A'-'Z' (subtract 32)
    B store

invalid:
    MOV R3, #0x2A       @ Store error code '*' (0x2A)
    B store

store:
    STR R3, [R1]        @ Store result at destination
    ADD R0, R0, #4      @ Move to next source word (4 bytes)
    ADD R1, R1, #4      @ Move to next destination word (4 bytes)
    B loop              @ Continue loop

done:




















/*-------Code ends here ---------------------*/

/*-----------------DO NOT MODIFY--------*/
POP {PC}

.data
/*--------------------------------------*/
