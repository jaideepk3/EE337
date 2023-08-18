ORG 0H
LJMP MAIN
ORG 100H
MAIN:
CALL SEARCH
HERE: SJMP HERE
ORG 130H
SEARCH:
//To get location of the array element until which the search function is to be done
MOV R1, 30H
MOV A, R1
ADD A, 31H
DEC A
MOV 28H, A
CALL FUN1 // calculating midpoint of array

FUN1:
MOV A, 28H // last element
CJNE A, 30H, F1 // comparing midpoint and given number

F1:
JC F2 // if A<@30H CARRY FLAG IS SET
SUBB A, 30H
MOV b, #02H
DIV AB
ADD A, 30H
MOV R0, A  // the claculation for shifting of midpoint and A is location of
CALL COMPARE

COMPARE:
MOV A, 32H
MOV 29H, @R0 // A gets memory location of number to be searched and midpoint stored in 29H
CJNE A, 29H, FUN2
MOV 33H, R0
THERE: SJMP THERE

FUN2:
JC X1
JNC X2

X1:
MOV A, R0
DEC A
MOV 28H, A
CALL FUN1

X2:
MOV A, R0
INC A
MOV 30H, A
CALL FUN1

F2:
MOV 33H, #0EH
END