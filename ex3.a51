ORG 0H
LJMP MAIN
ORG 100H
MAIN:
CALL SEARCH
HERE: SJMP HERE
ORG 130H
SEARCH:
// Add your code here.
MOV R3, 31H
MOV A, 

ADD A, 30H
DEC A
MOV 40H, A
CALL MID
MID:
MOV A, 40H
CJNE A, 30H, LABEL1
LABEL1:
JC LABEL2
SUBB A, 30H
MOV B, #02H
DIV AB
ADD A, 30H
MOV R1, A
CALL COMPARATOR
HALF:
JC LEFT
JNC RIGHT
LEFT:
MOV A, R1
DEC A
MOV 40H, A
CALL MID
RIGHT:
MOV A, R1
INC A
MOV 30H, A
CALL MID

COMPARATOR:
MOV A, 32H
MOV 41H, @R1
CJNE A, 41H, HALF
MOV 33H, R1
THERE: SJMP THERE
LABEL2:
MOV 33H, #0EH
END