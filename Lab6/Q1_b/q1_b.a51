ORG 00H
	HERE:
		MOV P1, #0F0H
		ACALL BLINKING_DELAY
		MOV P1, #00H
		ACALL BLINKING_DELAY
		SJMP HERE

BLINKING_DELAY:
	MOV 30H, #04H
	MOV R2, 30H
		L1:ACALL DELAY
		DJNZ R2, L1
		RET



DELAY:
	MOV R3, #40 
	delay_25ms:
		MOV TMOD,#01H 		// Setting Timer_0 to MODE_1 (16 bit timer)
		MOV A, #0h			//2's complement(0000H - C350H)
		SUBB A, #50H
		MOV R0, A
		MOV A, #0h
		SUBB A, #0C3H
		MOV R1, A
		MOV TH0, R1    		// Loads TH0 register with 
		MOV TL0, R0			// LOads TL0 register with 
		SETB TR0    		// Starts the Timer 0(TR0)
LOOP: 
	JNB TF0, LOOP   		// Loops here until TF0 is set
	CLR TR0        			// Stops Timer_0
	CLR TF0  				// Clears TF0 flag
	DJNZ R3, delay_25ms
RET
END