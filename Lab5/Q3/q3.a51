LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

LED1 EQU P1.7
LED2 EQU P1.6
LED3 EQU P1.5
LED4 EQU P1.4
IN1 EQU P1.3
IN2 EQU P1.2
IN3 EQU P1.1
IN4 EQU P1.0

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
START:
	S0:
		ACALL lcd_init
		mov a,#82h
		acall lcd_command
		acall delay
		mov   dptr,#my_string1
		acall lcd_sendstring
		acall delay

		mov a,#0C3h
		acall lcd_command
		acall delay
		mov   dptr,#my_string2
		acall lcd_sendstring
		ACALL delay
	RET
	S1_4:
		ACALL lcd_init
		MOV A, #081H
		ACALL lcd_command
		ACALL delay
		MOV DPTR,#my_string3
		ACALL lcd_sendstring
		ACALL delay
		
		MOV A, #0C3H
		ACALL lcd_command
		ACALL delay
		MOV dptr,#my_string2
		ACALL lcd_sendstring
		ACALL delay
	RET
	S5:
		ACALL lcd_init
		MOV A, #80H
		ACALL lcd_command
		ACALL delay
		MOV dptr,#my_string4
		ACALL lcd_sendstring
		ACALL delay
		
		MOV A, #0C0H
		ACALL lcd_command
		ACALL delay
		MOV dptr, #my_string5
		ACALL lcd_sendstring
		ACALL delay
		
		MOV A, #0C7H
		ACALL lcd_command
		ACALL delay
		MOV dptr, #my_string6
		ACALL lcd_sendstring
		ACALL delay
	RET
	S6:
		ACALL lcd_init
		MOV A, #82H
		ACALL lcd_command
		ACALL delay
		MOV dptr,#my_string7
		ACALL lcd_sendstring
		ACALL delay	
		
		MOV A, #0C0H
		ACALL lcd_command
		ACALL delay
		MOV dptr, #my_string5
		ACALL lcd_sendstring
		ACALL delay
		
		MOV A, #0C7H
		ACALL lcd_command
		ACALL delay
		MOV dptr, #my_string6
		ACALL lcd_sendstring
		ACALL delay
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
ASCII:
	 MOV A, 40H
	 MOV B, #10H
	 DIV AB
	 MOV 41H, A				;Upper Nibble
     MOV 42H, B				;Lower Nibble
     UPPER:
			MOV A, 41H
			ADD A, #30H
			MOV 43H, A
			MOV B, #3AH
			DIV AB
			JZ FINU
			MOV A, B
			ADD A, #41H
			MOV 43H, A
			FINU:
					MOV 45H, 43H
	 LOWER:
			MOV A, 42H
			ADD A, #30H
			MOV 44H, A
			MOV B, #3AH
			DIV AB
			JZ FINL
			MOV A, B
			ADD A, #41H
			MOV 44H, A
			FINL:
				MOV 46H, 44H

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
	LCALL S0
	LCALL DELAY_1S
	ACALL lcd_init
	CLR LED2
	CLR LED3
	CLR LED4
	LCALL S1_4
	LCALL DELAY_1S
	LCALL DELAY_1S
	MOV A, P1
	MOV B, #10H
	MUL AB
	MOV 40H, A
	ACALL lcd_init
	CLR LED1
	SETB LED2
	LCALL S1_4
	LCALL DELAY_1S
	LCALL DELAY_1S
	MOV A, P1
	MOV B, #10H
	DIV AB
	MOV A, 40H
	ADD A, B
	MOV 30H, A
	ACALL lcd_init
	CLR LED2
	SETB LED3
	LCALL S1_4
	LCALL DELAY_1S
	LCALL DELAY_1S
	MOV A, P1
	MOV B, #10H
	MUL AB
	MOV 41H, A
	ACALL lcd_init
	CLR LED3
	SETB LED4
	LCALL S1_4
	LCALL DELAY_1S
	LCALL DELAY_1S
	MOV A, P1
	MOV B, #10H
	DIV AB
	MOV A, 41H
	ADD A, B
	MOV 31H, A
	MOV 40H, 30H
	LCALL ASCII
	MOV 70h, 45H
	MOV 71h, 46H
	MOV 40H, 31H
	LCALL ASCII
	MOV 72h, 45H
	MOV 73h, 46H
	CLR LED4
	LCALL S5
	MOV A, 30H
	MOV B, 31H
	MUL AB
	MOV 50H, A
	MOV 51H, B
	LCALL DELAY_1S
	LCALL DELAY_1S
	MOV 40H, 50H
	LCALL ASCII
	MOV 76h, 45H
	MOV 77h, 46H
	MOV 40H, 51H
	LCALL ASCII
	MOV 74h, 45H
	MOV 75h, 46H
	LCALL S6
HERE: SJMP HERE
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