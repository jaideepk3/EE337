LCD_DATA EQU P2		;LCD Data port
LCD_RS EQU P0.0		;LCD Register Select
LCD_RW EQU P0.1		;LCD Read/Write
LCD_EN EQU P0.2		;LCD Enable

ORG 0H
LJMP MAIN

ORG 100H
;------------------------LCD Initialisation Routine------------------------
LCD_INIT:
	MOV LCD_DATA, #38H		;Function set: 2 Line, 8-bit, 5x7 dots
	CLR LCD_RS				;Selected command register
	CLR LCD_RW				;We are writing in instruction register
	SETB LCD_EN				;Enable H->L
	ACALL DELAY
	CLR LCD_EN
	ACALL DELAY
	
	MOV LCD_DATA, #0CH		;Display on, Curson off
	CLR LCD_RS				;Selected instruction register
	CLR LCD_RW				;We are writing in instruction register
	SETB LCD_EN				;Enable H->L
	ACALL DELAY
	CLR LCD_EN
	ACALL DELAY
	
	MOV LCD_DATA, #01H		;Clear LCD
	CLR LCD_RS				;Selected command register
	CLR LCD_RW				;We are writing in instruction register
	SETB LCD_EN				;Enable H->L
	ACALL DELAY
	CLR LCD_EN
	ACALL DELAY
	
	MOV LCD_DATA, #06H		;Entry mode, auto increment with no shift
	CLR LCD_RS				;Selected command register
	CLR LCD_RW				;We are writing in instruction register
	SETB LCD_EN				;Enable H->L
	ACALL DELAY
	CLR LCD_EN
	ACALL DELAY
RET
;------------------------LCD Command Sending Routine------------------------
LCD_COMMAND:
	MOV LCD_DATA, A			;Move the command to LCD port
	CLR LCD_RS				;Selected data register
	CLR LCD_RW				;We are writing
	SETB LCD_EN				;Enable H->L
	ACALL DELAY
	CLR LCD_EN
	ACALL DELAY
RET
;------------------------LCD Data Sending Routine------------------------
LCD_SENDDATA:
	MOV LCD_DATA, A			;Move the command to LCD port
	SETB LCD_RS				;Selected data register
	CLR LCD_RW				;We are writing
	SETB LCD_EN				;Enable H->L
	ACALL DELAY
	CLR LCD_EN
	ACALL DELAY
RET
;------------------------LCD Data Sending Routine------------------------
LCD_SENDSTRING:
	PUSH 0E0H
	LCD_SENDSTRING_LOOP:
		CLR A						;clear Accumulator for any previous data
		MOVC A, @A+DPTR				;load the first character in accumulator
		JZ EXIT						;go to exit if zero
		ACALL LCD_SENDDATA			;send first char
		INC DPTR					;increment data pointer
		SJMP LCD_SENDSTRING_LOOP	;jump back to send the next character
	EXIT: POP 0E0H
RET

ORG 200H
;--------------------------------LCD Printing--------------------------------
LCD_LVL1:
	ACALL LCD_INIT
	ACALL DELAY
	
	MOV A, #84H						;setting cursor position in first row
	ACALL LCD_COMMAND
	MOV DPTR, #S1					;to print string
	ACALL LCD_SENDSTRING
	
	MOV A, #0C2H					;setting cursor position in second row
	ACALL LCD_COMMAND
	MOV DPTR, #S5					;to print string
	ACALL LCD_SENDSTRING
	MOV A, #0C9H
	ACALL LCD_COMMAND
	MOV A, 63H
	ACALL LCD_SENDDATA
	MOV A, #0CAH
	ACALL LCD_COMMAND
	MOV A, 62H
	ACALL LCD_SENDDATA
	MOV A, #0CBH
	ACALL LCD_COMMAND
	MOV A, 61H
	ACALL LCD_SENDDATA
	MOV A, #0CCH
	ACALL LCD_COMMAND
	MOV A, 60H
	ACALL LCD_SENDDATA
RET
LCD_LVL2:
	ACALL LCD_INIT
	ACALL DELAY
	
	MOV A, #84H						;setting cursor position in first row
	ACALL LCD_COMMAND
	MOV DPTR, #S2					;to print string
	ACALL LCD_SENDSTRING
	
	MOV A, #0C2H					;setting cursor position in second row
	ACALL LCD_COMMAND
	MOV DPTR, #S5					;to print string
	ACALL LCD_SENDSTRING
	MOV A, #0C9H
	ACALL LCD_COMMAND
	MOV A, 63H
	ACALL LCD_SENDDATA
	MOV A, #0CAH
	ACALL LCD_COMMAND
	MOV A, 62H
	ACALL LCD_SENDDATA
	MOV A, #0CBH
	ACALL LCD_COMMAND
	MOV A, 61H
	ACALL LCD_SENDDATA
	MOV A, #0CCH
	ACALL LCD_COMMAND
	MOV A, 60H
	ACALL LCD_SENDDATA
RET
LCD_LVL3:
	ACALL LCD_INIT
	ACALL DELAY
	
	MOV A, #84H						;setting cursor position in first row
	ACALL LCD_COMMAND
	MOV DPTR, #S3					;to print string
	ACALL LCD_SENDSTRING
	
	MOV A, #0C2H					;setting cursor position in second row
	ACALL LCD_COMMAND
	MOV DPTR, #S5					;to print string
	ACALL LCD_SENDSTRING
	MOV A, #0C9H
	ACALL LCD_COMMAND
	MOV A, 63H
	ACALL LCD_SENDDATA
	MOV A, #0CAH
	ACALL LCD_COMMAND
	MOV A, 62H
	ACALL LCD_SENDDATA
	MOV A, #0CBH
	ACALL LCD_COMMAND
	MOV A, 61H
	ACALL LCD_SENDDATA
	MOV A, #0CCH
	ACALL LCD_COMMAND
	MOV A, 60H
	ACALL LCD_SENDDATA
RET
LCD_LVL4:
	ACALL LCD_INIT
	ACALL DELAY
	
	MOV A, #84H						;setting cursor position in first row
	ACALL LCD_COMMAND
	MOV DPTR, #S4					;to print string
	ACALL LCD_SENDSTRING
	
	MOV A, #0C2H					;setting cursor position in second row
	ACALL LCD_COMMAND
	MOV DPTR, #S5					;to print string
	ACALL LCD_SENDSTRING
	MOV A, #0C9H
	ACALL LCD_COMMAND
	MOV A, 63H
	ACALL LCD_SENDDATA
	MOV A, #0CAH
	ACALL LCD_COMMAND
	MOV A, 62H
	ACALL LCD_SENDDATA
	MOV A, #0CBH
	ACALL LCD_COMMAND
	MOV A, 61H
	ACALL LCD_SENDDATA
	MOV A, #0CCH
	ACALL LCD_COMMAND
	MOV A, 60H
	ACALL LCD_SENDDATA
RET
;--------------------------------Strings--------------------------------
S1:
	DB "LEVEL 1", 00H
S2:
	DB "LEVEL 2", 00H
S3:
	DB "LEVEL 3", 00H
S4:
	DB "LEVEL 4", 00H
S5:
	DB "VALUE: ", 00H

;-------------------------------- MAIN --------------------------------
MAIN:
	MOV 70H, #06DH			;LEVEL 1&2////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	MOV 71H, #0A9H			;LEVEL 3&4////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	MOV P1, #0H
	MOV P2, #0H
	LCALL LCD_INIT			; initialising LCD
;--------------------------------Storing Levels in 50H to 53H--------------------------------
	MOV A, 70H
	SWAP A
	ANL A, #0F0H
	MOV 50H, A				; LEVEL 1 in 50H
	MOV A, 70H
	ANL A, #0F0H
	MOV 51H, A				; LEVEL 2 in 51H
	MOV A, 71H
	SWAP A
	ANL A, #0F0H
	MOV 52H, A				; LEVEL 3 in 52H
	MOV A, 71H
	ANL A, #0F0H
	MOV 53H, A				; LEVEL 4 in 53H
;--------------------------------Giving Output to LEDs--------------------------------
	HERE:
		MOV P1, 50H				; LEVEL 1
		MOV R0, 50H
		LCALL ASCII				;Storing ASCII values of each bit in 60H to 63H
		LCALL LCD_LVL1
		ACALL DELAY_1S
		MOV P1, 51H				; LEVEL 2
		MOV R0, 51H
		LCALL ASCII				;Storing ASCII values of each bit in 60H to 63H
		LCALL LCD_LVL2
		ACALL DELAY_1S
		MOV P1, 52H				; LEVEL 3
		MOV R0, 52H
		LCALL ASCII				;Storing ASCII values of each bit in 60H to 63H
		LCALL LCD_LVL3
		ACALL DELAY_1S
		MOV P1, 53H				; LEVEL 4
		MOV R0, 53H
		LCALL ASCII				;Storing ASCII values of each bit in 60H to 63H
		LCALL LCD_LVL4
		ACALL DELAY_1S
	SJMP HERE
;--------------------------------ASCII--------------------------------
ASCII:
	MOV A, R0
	ANL A, #80H					;First bit
	JZ H1
	H2:
		MOV 63H, #31H
		SJMP N1
	H1:
		MOV 63H, #30H
  N1:MOV A, R0
	ANL A, #40H					;Second bit
	JZ H3
	H4:
		MOV 62H, #31H
		SJMP N2
	H3:
		MOV 62H, #30H
  N2:MOV A, R0
	ANL A, #20H					;Third bit
	JZ H5
	H6:
		MOV 61H, #31H
		SJMP N3
	H5:
		MOV 61H, #30H
  N3:MOV A, R0
	ANL A, #10H					;Fourth bit
	JZ H7
	H8:
		MOV 60H, #31H
RET
	H7:
		MOV 60H, #30H
RET

;--------------------------------DELAY Routine--------------------------------
	DELAY_1S:
		PUSH 00H
		MOV R0, #38
		AGAIN:
			ACALL DELAY_25MS
			DJNZ R0, AGAIN
		POP 00H
	RET
	DELAY_25MS:
		MOV TMOD, #01H
		MOV TH0, #3DH
		MOV TL0, #0B0H
		SETB TR0
		LOOP: JNB TF0, LOOP
		CLR TR0
		CLR TF0
	RET
	DELAY:							; 1MS DELAY
		MOV TMOD, #10H
		MOV TH1, #0F8H
		MOV TL1, #30H
		SETB TR1
		LP: JNB TF1, LP
		CLR TR1
		CLR TF1
	RET
END