org 0h
ljmp main
org 100h
main:
      function:
	  
	  mov 50h,#15h;
	  mov 51h,#06h;
	  mov 52h,#19h;
	  mov 53h,#83h;
	   mov A,50h;
	   mov p1,A;
	   acall delay_1s;
       swap A;
	   mov p1,A;
	   acall delay_1s;
	   clr A;
	   mov A,#0f0h;
	   mov p1,A;
	   acall delay_1s;
	   clr A;
	   mov A,51h;
	   mov p1,A;
	   acall delay_1s;
       swap A;
	   mov p1,A;
	   acall delay_1s;
	   clr A;
	   mov A,#0F0h;
	   mov p1,A;
	   acall delay_1s;
	   clr A;
	   mov A,52h;
	   mov p1,A;
	   acall delay_1s;
       swap A;
	   mov p1,A;
	   acall delay_1s;
	   clr A;
	   mov A,53h;
	   mov p1,A;
	   acall delay_1s;
       swap A;
	   mov p1,A;
	   acall delay_1s;
	   clr A;
	   mov A,#0F0h;
	   mov p1,A;
	   acall delay_1s;
	   sjmp function;
	   
	   
delay_1s:
        push 00h
        mov r0, #5
        h4: acall delay_200ms
        djnz r0, h4
		pop 00h;
		ret;	   
delay_200ms:
        push 00h
        mov r0, #200
        h3: acall delay_1ms
        djnz r0, h3
		pop 00h;
		ret;
delay_1ms:
       push 00h
       mov r0, #4
       h2: acall delay_250us
       djnz r0, h2
       pop 00h
       ret
delay_250us:
       push 00h
       mov r0, #244
       h1: djnz r0, h1
       pop 00h
       ret;
ret;
end;