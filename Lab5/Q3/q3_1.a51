LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

LED1 EQU P1.7
LED2 EQU P1.6
LED3 EQU P1.5
LED4 EQU P1.4

ORG 0H
JMP MAIN

ORG 300H
;------------- ROM text strings---------------------------------------------------------------
my_string1:
         DB   "Enter Inputs", 00H
my_string2:
		 DB   "EE337-2022", 00H
my_string3:
		 DB   "Reading Inputs", 00H
my_string4:
		 DB   "Computing Results", 00H
my_string5:
		 DB   "Num1:", 00H
my_string6:
		 DB   ", Num2:", 00H
my_string7:
		 DB   "Result = ", 00H

ORG 100H
;------------------------------------LCD Printing------------------------------------
START:
	STATE0:
		ACALL lcd_init
		acall delay
		acall delay
		mov A, #82H
		acall lcd_command
		mov   dptr,#my_string1
		acall lcd_sendstring

		mov A, #0C3H
		acall lcd_command
		mov   dptr,#my_string2
		acall lcd_sendstring
	RET
	STATE14:
		ACALL lcd_init
		acall delay
		acall delay
		MOV A, #81H
		ACALL lcd_command
		MOV DPTR,#my_string3
		ACALL lcd_sendstring
		
		MOV A, #0C3H
		ACALL lcd_command
		MOV dptr,#my_string2
		ACALL lcd_sendstring
	RET
	STATE5:
		ACALL lcd_init
		acall delay
		acall delay
		MOV A, #80H
		ACALL lcd_command
		MOV dptr,#my_string4
		ACALL lcd_sendstring
		
		MOV A, #0C0H
		ACALL lcd_command
		MOV dptr, #my_string5
		ACALL lcd_sendstring
		
		MOV A, #0C5H
		ACALL lcd_command
		MOV A, 70H
		ACALL lcd_senddata
		
		MOV A, #0C6H
		ACALL lcd_command
		MOV A, 71H
		ACALL lcd_senddata
		
		MOV A, #0C7H
		ACALL lcd_command
		MOV dptr, #my_string6
		ACALL lcd_sendstring
		
		MOV A, #0CEH
		ACALL lcd_command
		MOV A, 72H
		ACALL lcd_senddata
		
		MOV A, #0CFH
		ACALL lcd_command
		MOV A, 73H
		ACALL lcd_senddata
	RET
	STATE6:
		ACALL lcd_init
		acall delay
		acall delay
		MOV A, #82H
		ACALL lcd_command
		MOV dptr,#my_string7
		ACALL lcd_sendstring
		
		MOV A, #8BH
		ACALL lcd_command
		MOV A, 74H
		ACALL lcd_senddata
		
		MOV A, #8CH
		ACALL lcd_command
		MOV A, 75H
		ACALL lcd_senddata
		
		MOV A, #8DH
		ACALL lcd_command
		MOV A, 76H
		ACALL lcd_senddata
		
		MOV A, #8EH
		ACALL lcd_command
		MOV A, 77H
		ACALL lcd_senddata
		
		MOV A, #0C0H
		ACALL lcd_command
		MOV dptr, #my_string5
		ACALL lcd_sendstring
		
		MOV A, #0C5H
		ACALL lcd_command
		MOV A, 70H
		ACALL lcd_senddata
		
		MOV A, #0C6H
		ACALL lcd_command
		MOV A, 71H
		ACALL lcd_senddata
		
		MOV A, #0C7H
		ACALL lcd_command
		MOV dptr, #my_string6
		ACALL lcd_sendstring
		
		MOV A, #0CEH
		ACALL lcd_command
		MOV A, 72H
		ACALL lcd_senddata
		
		MOV A, #0CFH
		ACALL lcd_command
		MOV A, 73H
		ACALL lcd_senddata
	RET

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

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

ORG 400H
;-------------------------CONVERTING TO ASCII-------------------------
CONVERT_TO_ASCII:
	MOV A, 60H
		MOV B, #10H
		DIV AB
		MOV 61H, A		;Upper Nibble
		MOV 62H, B		;Lower Nibble
		UPPER:
			MOV A, 61H
			ADD A, #30H
			MOV 63H, A
			MOV B, #3AH
			DIV AB
			JZ FINISHU
			MOV A, B
			ADD A, #41H
			MOV 63H, A
			FINISHU:
				MOV 64H, 63H
		LOWER:
			MOV A, 62H
			ADD A, #30H
			MOV 65H, A
			MOV B, #3AH
			DIV AB
			JZ FINISHL
			MOV A, B
			ADD A, #41H
			MOV 65H, A
			FINISHL:
				MOV 66H, 65H
	RET


;-------------------------------------MAIN-------------------------------------
MAIN:
	
	mov P2,#00h
    mov P1,#00h
    acall delay
	acall delay
	acall lcd_init
	acall delay
	acall delay
	acall delay
	
	SETB LED1
	SETB LED2
	SETB LED3
	SETB LED4
	LCALL STATE0
	LCALL DELAY_1S
	ACALL lcd_init
	
	mov p1, #0FH		; FIRST INPUT
	SETB LED1
	LCALL STATE14
	LCALL DELAY_1S
	LCALL DELAY_1S
	MOV A, P1
	MOV B, #10H
	MUL AB
	MOV 40H, A			; UPPER NIBBLE OF FIRST NUMBER
	
	mov p1, #01H		; SECOND INPUT
	SETB LED2
	LCALL STATE14
	LCALL DELAY_1S
	LCALL DELAY_1S
	MOV A, P1
	MOV B, #10H
	DIV AB
	MOV A, 40H
	ADD A, B
	MOV 30H, A			; FIRST NUMBER
	
	mov p1, #00H		; THIRD INPUT
	SETB LED3
	LCALL STATE14
	LCALL DELAY_1S
	LCALL DELAY_1S
	MOV A, P1
	MOV B, #10H
	MUL AB
	MOV 41H, A			; UPPER NIBBLE OF SECOND NUMBER
	
	mov p1, #01H		; FOURTH INPUT
	SETB LED4
	LCALL STATE14
	LCALL DELAY_1S
	LCALL DELAY_1S
	MOV A, P1
	MOV B, #10H
	DIV AB
	MOV A, 41H
	ADD A, B
	MOV 31H, A					; SECOND NUMBER
	
	MOV 60H, 30H
	LCALL CONVERT_TO_ASCII
	MOV 70h, 64H				; N1h
	MOV 71h, 66H				; N1l
	MOV 60H, 31H
	LCALL CONVERT_TO_ASCII
	MOV 72h, 64H				; N2h
	MOV 73h, 66H				; N2l
	
	CLR LED4
	LCALL STATE5
	MOV A, 30H
	MOV B, 31H
	MUL AB						; Product = M2M1
	MOV 50H, A
	MOV 51H, B
	LCALL DELAY_1S
	LCALL DELAY_1S
	
	MOV 60H, 50H
	LCALL CONVERT_TO_ASCII
	MOV 76h, 64H				; M1h
	MOV 77h, 66H				; M1l
	MOV 60H, 51H
	LCALL CONVERT_TO_ASCII
	MOV 74h, 64H				; M2h
	MOV 75h, 66H				; M2l
	
	LCALL STATE6
	
HERE: SJMP HERE			;STAY TILL RESET

;---------------1sec DELAY SUBROUTINE---------------
DELAY_1S:
		PUSH 00H
		PUSH 01H
		MOV R1, #05
		H4: MOV R0, #200
		H3: ACALL delay_1ms
		DJNZ R0, H3
		DJNZ R1, H4
		POP 01H
		POP 00H
		RET
	delay_1ms:
		PUSH 00H
		MOV R0, #4
		H2: ACALL delay_250us
		DJNZ R0, H2
		POP 00H
		RET
	delay_250us:
		PUSH 00H
		MOV R0, #244
		H1: DJNZ R0, H1
		POP 00H
		RET
RET
END