ORG 0H
LJMP MAIN
ORG 100H

MAIN:
	MOV P1, #0H
	HERE:
		MOV P1, #0FFH
		DELAY1:
			PUSH 0H
			MOV R0, #0FH
			AGAIN1:
				ACALL DELAY
				DJNZ R0, AGAIN1
			POP 0H
	MOV P1, #0H
		DELAY2:
			PUSH 0H
			MOV R0, #0FH
			AGAIN2:
				ACALL DELAY
				DJNZ R0, AGAIN2
			POP 0H
	SJMP HERE

DELAY:
	MOV TMOD, #01H
	MOV B, 31H
	MOV A, #00H
	SUBB A, B
	MOV 36H, A				;SUBB a,b		a=#00h   b=count value   - a will have the 2's complimemt of count
	MOV B, 30H
	MOV A, #00H
	SUBB A, B
	MOV 35H, A
	MOV TL0, 36H
	MOV TH0, 35H
	SETB TR0
	LOOP: JNB TF0, LOOP
	CLR TR0





CLR TF0
RET

END