ORG 0H
LJMP MAIN
ORG 100H
MAIN:
CALL SEARCH
HERE: SJMP HERE
ORG 130H
SEARCH:
// Add your code here.
CLR C
MOV R1,30H
MOV A,30H
ADD A,31H
DEC A
MOV R2,A
MOV A,30H
ADD A,R2
RRC A
MOV R0,A
BINARY:
MOV A,R1
SUBB A,R2
JZ LABEL2
CLR C
MOV A,@R0
CJNE A,32H,LABEL1
JNC UPDATEL
MOV B,R0
MOV R2,B
DEC R2
SJMP UPDATEM
UPDATEL:MOV B,R0
MOV R1,B
INC R1
UPDATEM:MOV A,R1
ADD A ,R2
MOV B,R4
CLR C
RRC A
MOV R0,A
SJMP BINARY
LABEL1:
MOV A,R0
MOV 33H,A
SJMP ENDPROGRAM
LABEL2:
MOV 33H,#0EH
ENDPROGRAM:
RET
END