ORG 0000H  
LJMP MAIN 
ORG 100H
MAIN:
	 MOV A, 30H
	 MOV B, #10H
	 DIV AB
	 MOV 40H, A				;Upper Nibble
     MOV 41H, B				;Lower Nibble
     UPPER:
			MOV A, 40H
			ADD A, #30H
			MOV 45H, A
			MOV B, #3AH
			DIV AB
			JZ FINU
			MOV A, B
			ADD A, #41H
			MOV 45H, A
			FINU:
					MOV 60H, 45H
	 LOWER:
			MOV A, 41H
			ADD A, #30H
			MOV 46H, A
			MOV B, #3AH
			DIV AB
			JZ FINL
			MOV A, B
			ADD A, #41H
			MOV 46H, A
			FINL:
				MOV 61H, 46H

RET		   
END