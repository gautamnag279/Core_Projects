CLR P0.7
LOOP:
MOV P1, A
ADD A, #03H
CJNE A, #0FFH, LOOP
LOOP1:
MOV P1, A
SUBB A, #03H
CJNE A, #00H, LOOP1
JMP LOOP