;corrected code (278)

MOV TMOD,#50H ; PUT TIMER 1 IN EVENT COUNTING MODE
  SETB TR1               ; START TIMER
MOV DPL, #LOW(LEDcodes); I PUT THE LOW BYTE OF THE START ADDRESS OF THE 7 SEGMENT
                                                    ; I CODE TABLE INTO DFL
MOV DPL, #HIGH(LEDcodes); PUT  THE HIGH BYTE INTO DPH
CLR P3.4  ; I
CLR P3.3   ;I ENABLE DISPLAY 0
AGAIN:
CALL  SETDIRECTION  ;SET THE MOTOR�S DIRECTION
MOV A,TL1 ; MOVE THE TIMER 1 LOW BYTE TO A
CJNE A,#10,SKIP ;IF THE NIBBLE OF REVOLUTION IS NOT 10 SKIP  NEXT INSTRUCTIONS
CALL CLEARTIMER; IF THE NIBBLE OF REVOLUTION IS 10,RESET TIMER 1
SKIP:
MOVC A,@A+DPTR; I GET 7 SEGMENT CODE FROM CODE TABLE-THE INDEX INTO THE TABLE IS
                                   ; I DECIDED BY THE VALUE IN A
                                    ; I (EXAMPLE: THE DATA POINTER POINTS TO THE START OF THE
                                    ; I TABLE-IF THERE ARE TWO REVOLUTIONS,THEN A WILL CONTAIN TWO,
                                    ; I THEREFORE THE SECOND CODE IN THE TABLE WILL BE COPIED TO A
MOV C,F0; MOVE MOTOR DIRECTION VALUE THE CARRY
MOV ACC.7,C; AND FROM THERE TO ACC.7( THIS WILL ENSURE DISPLAY0�S DECIMAL POINT
                        ;WILL INDICATE THE MOTOR DIRECTIONS
MOV P1,A ;I MOVE ( 7 -SEG CODE (OR) NUMBER OF REVOLUTIONS AND MOTOR DIRECTION
                    ;I INDICATOR TO DISPLAY 0
JMP AGAIN ;  DO IT ALL AGAIN
SETDIRECTION:
PUSH ACC ; SAVE VALUE OF A ON STACK
PUSH 20H; SAVE VALUE OF LOCATION(FIRST BIT -ADDRESSABLE IN RAM) ON STACK
CLR A;CLEAR A
MOV 20H,#0 ;CLEAR LOCATION 20H
MOV C,P2.0; PUT SW0 VALUE IN CARRY
MOV ACC.0, C; THEN MOVE TO ACC.0
MOV C,F0 ;MOVE CURRENT MOTOR DIRECTION IN CARRY
MOV 0, C ;MOV TO LSB OF LOCATION 20H
CJNE A,20H,CHANGEDIR ;I COMPARE SW0(LSB OF A) WITH F0(LSB OF 20H)
                                           ;I -IF THERE ARE NOT SAME,THE MOTOR�S DIRECTION NEEDS REVERSED            
 JMP FINISH    ; IF THEY ARE THE SAME,MOTOR DIRECTION DOES NOT NEED TO BE CHANGE
CHANGEDIR:
CLR P3.0 ;I
CLR P3.1; I STOP MOTOR
CALL CLEARTIMER; RESET TIMER I
MOV C, P2.0; MOVE SW0 VALUE TO CARRY
MOV F0, C; AND THEN TO  F0-THIS IS THE MOTOR DIRECTION
MOV P3.0,C; MOVE WS0 VALUE (IN CARRY TO MOTOR CONTROL BIT 1
CPL C; INVERT THE CARRY
MOV P3.1,C ; I AND MOVE  IT  TO MOTOR CONTROL BIT 0
                        ;I VALUE TO CONTROL BIT 1 AND MOTOR WILL START
                         ; I AGAIN IN THE NEW DIRECTION
FINISH:
POP 20H ; GET ORIGINAL VALUE FOR LOCATION 20H FROM STACK
POP ACC  ;GET ORIGINAL VALUE FOR A FROM THE STACK
RET ;RETURN  FROM SUBROUTINE
CLEARTIMER:
CLR A ;RESET  REVOLUTION COUNT  IN A TO  ZERO
CLR TR1, ;STOP TIMER 1
MOV TL1, #0 ;RESET TIMER 1 LOW BYTE TO ZERO
SETB TR1 ;START TIMER 1
RET; RETURN FRO SUBROUTINE
LEDcodes: DB 11000000B,11111001B,10100100B,10110000B,10011001B,10010010B,10000010B,11111000B,10000000B,10010000B