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
LDR R1, =0x20002000    @ R1 = Destination address (converted values)

loop:
    LDR R2, [R0]        @ Load ASCII character from source

    @ Check for Enter (0x0D) - end condition
    CMP R2, #0x0D
    BEQ done
    CMP R2, #0x0A       @ Also check for line feed (0x0A)
    BEQ done

    @ Check if it's '0'-'9' (0x30-0x39)
    CMP R2, #0x30
    BLT invalid         @ If less than '0', invalid
    CMP R2, #0x39
    BLE digit           @ If <= '9', it's a digit (0-9)

    @ Check if it's 'A'-'F' (0x41-0x46)
    CMP R2, #0x41
    BLT invalid         @ If less than 'A' (but > '9'), invalid
    CMP R2, #0x46
    BLE upper_hex       @ If <= 'F', it's uppercase hex (A-F)

    @ Check if it's 'a'-'f' (0x61-0x66)
    CMP R2, #0x61
    BLT invalid         @ If less than 'a' (but > 'F'), invalid
    CMP R2, #0x66
    BLE lower_hex       @ If <= 'f', it's lowercase hex (a-f)

    @ Otherwise invalid (> 'f')
    B invalid

digit:
    SUB R3, R2, #0x30   @ Convert '0'-'9' to 0-9
    B store

upper_hex:
    SUB R3, R2, #0x37   @ Convert 'A'-'F' to 10-15 (0x41-0x37=10)
    B store

lower_hex:
    SUB R3, R2, #0x57   @ Convert 'a'-'f' to 10-15 (0x61-0x57=10)
    B store

invalid:
    MVN R3, #0          @ Store error code -1 (0xFFFFFFFF)
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
