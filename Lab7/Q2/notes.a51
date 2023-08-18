; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable
	
ORG 00H 
LJMP MAIN

ORG 100H
;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
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
;-----------------------------------------------------------------------------	
LCD_DISPLAY:
	ACALL LCD_INIT
	ACALL DELAY
	
	MOV A, #082H
	ACALL LCD_COMMAND
	MOV DPTR, #S1
	ACALL LCD_SENDSTRING
RET
;----------------------------------------------------------------------------
org 600h
S1:
         DB   "ROLLING TIME", 00H
;---------------------------------------------------------
FREQ1:
MOV TMOD, #11H
	MOV TH1, #3EH
	MOV TL1, #3FH
	SETB TR1
	LP1:
		MOV TH0, #0EEH
		MOV TL0, #3FH
		SETB TR0
		L1: JNB TF0, L1
		CPL P0.7
		CLR TR0
		CLR TF0
	JNB TF1, LP1
	CLR TR1
	CLR TF1
RET
;----------------------------------------------------------------------------------
FREQ2:
MOV TMOD, #11H
	MOV TH1, #3EH
	MOV TL1, #3FH
	SETB TR1
	LP2:
		MOV TH0, #0F0H
		MOV TL0, #30H
		SETB TR0
		L2: JNB TF0, L2
		CPL P0.7
		CLR TR0
		CLR TF0
	JNB TF1, LP2
	CLR TR1
	CLR TF1	
RET 
;--------------------------------------------------------------------------------------
FREQ3:
MOV TMOD, #11H
	MOV TH1, #3EH
	MOV TL1, #3FH
	SETB TR1
	LP3:
		MOV TH0, #0F2H
		MOV TL0, #0B7H
		SETB TR0
		L3: JNB TF0, L3
		CPL P0.7
		CLR TR0
		CLR TF0
	JNB TF1, LP3
	CLR TR1
	CLR TF1	
	RET
;---------------------------------------------------------------------------------------------
FREQ4:

MOV TMOD, #11H
	MOV TH1, #3EH
	MOV TL1, #3FH
	SETB TR1
	LP4:
		MOV TH0, #0F5H
		MOV TL0, #72H
		SETB TR0
		L4: JNB TF0, L4
		CPL P0.7
		CLR TR0
		CLR TF0
	JNB TF1, LP4
	CLR TR1
	CLR TF1	
RET 
;-----------------------------------------------------------------------------------------------
FREQ5:
MOV TMOD, #11H
	MOV TH1, #3EH
	MOV TL1, #3FH
	SETB TR1
	LP5:
		MOV TH0, #0F4H
		MOV TL0, #2AH
		SETB TR0
		L5: JNB TF0, L5
		CPL P0.7
		CLR TR0
		CLR TF0
	JNB TF1, LP5
	CLR TR1
	CLR TF1	
RET
;-----------------------------------------------------------------------------------------------------
SILENT:
MOV TMOD, #10H
MOV TH1, #3EH
MOV TL1, #3FH
SETB TR1
Ls: 
   CLR P0.7
   JNB TF1,Ls
  CLR TR1
  CLR TF1
 RET
;-----------------------------------------------------------------------------------------------------
MAIN: 
MOV P0, #0H
MOV P1 ,#0H
MOV P2,#0H
ACALL LCD_DISPLAY

NOTE1:
 MOV R0, #30
 LOOP1: ACALL FREQ1
 DJNZ R0, LOOP1
 
 NOTE2:
 MOV R0, #30
 LOOP2: ACALL FREQ2
 DJNZ R0, LOOP2
 
 NOTE3:
 MOV R0, #30
 LOOP3: ACALL FREQ3
 DJNZ R0, LOOP3
 
 NOTE4:
 MOV R0, #30
 LOOP4: ACALL FREQ2
 DJNZ R0, LOOP4
 
 NOTE5:
 MOV R0, #40
 LOOP5: ACALL FREQ3
 DJNZ R0, LOOP5
 
 NOTE6:
 MOV R0, #20
 LOOP6: ACALL SILENT
 DJNZ R0, LOOP6
 
 NOTE7:
 MOV R0, #40
 LOOP7: ACALL FREQ4
 DJNZ R0, LOOP7
 
 NOTE8:
 MOV R0, #40H
 LOOP8: ACALL FREQ5
 DJNZ R0, LOOP8
 
 LJMP MAIN

;----------------------delay routine-----------------------------------------------------
DELAY:							; 1MS DELAY for LCD Commands
	PUSH 0H
	PUSH 1H
	MOV R0, #4
	AGAIN:
		MOV R1, #255
		LOOP:	DJNZ R1, LOOP
	DJNZ R0, AGAIN
	POP 1H
	POP 0H
RET

END