LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable


ORG 0000H
LJMP MAIN
;-----------interrupt--------------------------------------------------------------------------------
ORG 0003H
	CLR TR1
	CLR P1.4
	SETB P3.2
	RETI

ORG 001BH
    LCALL AGAIN1
	SETB P3.2
	RETI

org 300H

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall DELAY_1ms
         clr   LCD_en
	     acall DELAY_1ms

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall DELAY_1ms
         clr   LCD_en
         
		 acall DELAY_1ms
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall DELAY_1ms
         clr   LCD_en
         
		 acall DELAY_1ms

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall DELAY_1ms
         clr   LCD_en

		 acall DELAY_1ms
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall DELAY_1ms
         clr   LCD_en
		 acall DELAY_1ms
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall DELAY_1ms
         clr   LCD_en
         acall DELAY_1ms
		 acall DELAY_1ms
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine
;------------- ROM text strings---------------------------------------------------------------
 LCD_INITIAL:
 ACALL LCD_INIT
	ACALL DELAY_1ms
	
	MOV A, #83H						;setting cursor position in first row
	ACALL LCD_COMMAND
	MOV DPTR, #S1					;to print string
	ACALL LCD_SENDSTRING
	
	MOV A, #0C2H					;setting cursor position in second row
	ACALL LCD_COMMAND
	MOV DPTR, #S2					;to print string
	ACALL LCD_SENDSTRING
RET
;--------------------------------------------------------------------------------------------------
LCD_reactiontime:

ACALL lcd_init
ACALL DELAY_1ms
MOV	A, #82H
ACALL LCD_COMMAND
MOV DPTR,#S3
ACALL LCD_SENDSTRING

MOV A, #0C0H
ACALL LCD_COMMAND 
MOV DPTR, #S4
ACALL LCD_SENDSTRING

MOV A, #20H
ACALL LCD_SENDDATA
MOV A, 53H
ACALL LCD_SENDDATA
MOV A, 54H
ACALL LCD_SENDDATA

MOV A, #20H
ACALL LCD_SENDDATA 

MOV A, 55H
ACALL LCD_SENDDATA
MOV A, 56H
ACALL LCD_SENDDATA
MOV A, 57H
ACALL LCD_SENDDATA
MOV A, 58H
ACALL LCD_SENDDATA
RET

;-----------------------------------------------------------------------------------------------
S1:
         DB   "Toggle SW1", 00H
S2:
		 DB   "if LED glows", 00H
S3:
		 DB   "Reaction Time", 00H
S4:
		 DB   "Count is", 00H
S5:
		 DB   " ", 00H
;---------------------------------------------------------------------------------------------------
TOGGLE:
	JB P1.0,ONE
	SJMP NEXT
	ONE:	CLR P3.2
RET
;-----------------------------------------------------------------------------------------------------
AGAIN1:
	CLR TF1
	INC B
RET
;-------------------------------------------------------------------------------------------------------
MAIN:
MOV P1, #0H
	MOV P2, #0H
	MOV B, #0H
	SETB P1.0 ;
	LCALL LCD_INIT			; initialising LCD
	LCALL LCD_INITIAL 
    LCALL DELAY 
	LCALL DELAY
    SETB P1.4
	MOV IE,#89H 
REACTION_TIME:
  MOV TMOD, #10H
  MOV TH1, #0H
  MOV TL1, #0H
  SETB TR1 
  ;-------------------------------------------------------------------------------
NEXT:
  JB TR1, CHECK
  SJMP N1
  CHECK:	LCALL TOGGLE
 ;---------------------------------------------------------------------------------
N1:MOV 71H,TH1
  MOV 72H,TL1
  
  MOV 51H, B
	LCALL ASCII
	MOV 53H, 64H				
	MOV 54H, 66H				
  MOV 51H,71H
	LCALL ASCII
	MOV 55h, 64H				
	MOV 56h, 66H				
  MOV 51H, 72H
	LCALL ASCII
	MOV 57h, 64H				
	MOV 58h, 66H				
LCALL LCD_reactiontime	
ACALL DELAY_1ms
ACALL DELAY
ACALL DELAY
ACALL DELAY
ACALL DELAY
ACALL DELAY
LJMP MAIN
;--------------------------------ASCII------------------------------------------------------
  ASCII:
	 MOV A, 51H
	 MOV B, #10H
	 DIV AB
	 MOV 61H, A				;Upper Nibble
     MOV 62H, B				;Lower Nibble
     UPPER:
			MOV A, 61H
			ADD A, #30H
			MOV 63H, A
			MOV B, #3AH
			DIV AB
			JZ FINU
			MOV A, B
			ADD A, #41H
			MOV 63H, A
			FINU:
					MOV 64H, 63H
	 LOWER:
			MOV A, 62H
			ADD A, #30H
			MOV 65H, A
			MOV B, #3AH
			DIV AB
			JZ FINL
			MOV A, B
			ADD A, #41H
			MOV 65H, A
			FINL:
				MOV 66H, 65H

RET
  
;----------------------DELAY_1ms routine-----------------------------------------------------
DELAY_1ms:							; 1MS DELAY_1ms
	 push 0
	 push 1
         mov r0,#4
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret
;--------------------------DELAY_1s------------------------------------------------------------
DELAY:
		PUSH 00H
		PUSH 01H
		MOV R1, #01H
		DELAY_T:
			MOV R0, #39
			AGAIN:
				ACALL DELAY_25MS
				DJNZ R0, AGAIN
			DJNZ R1, DELAY_T
		POP 01H
		POP 00H
	RET
	DELAY_25MS:
		MOV TMOD, #01H
		MOV TH0, #3EH
		MOV TL0, #3FH
		SETB TR0
		LOOP: JNB TF0, LOOP
		CLR TR0
		CLR TF0
	RET
END