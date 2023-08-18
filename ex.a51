ORG 0H
LJMP MAIN

ORG 100H
MAIN:
CALL SEARCH
HERE: SJMP HERE
ORG 130H
SEARCH:

mov 30h, #80h // The starting address //
mov R0, 30h
mov 31h, #23h // The ending point to which the array that we will be checking for //
add A, 31h
add A, R0
dec A
mov R1, A
mov 35h, R1
mov 32h, #0FFh // The number we have to search for //
mov R2, 32h

start_loop:
    mov A, R1  // High value address //
	mov 30h, R0
	cjne A, 30h, Pass // checking the relation between high and low address //
	jmp loop_end // If high and low value are same //
	
	
Pass:	
    JC loop_end  // If High < Low //
	JNC midterm  // Else High > Low //
	jmp reset
	
	
midterm:
    mov A, 31h
    mov B, #2
	div AB  // The mid term with reference to the staring address //
	mov 36h, #02h
	cjne A, 36h, normal
	mov A, @R1
    cjne A, 32h, Next_Number
	mov A, R1
	jmp print

Next_Number:
    mov R1, 30h
	mov A, @R1
	cjne A, 32h, loop_end
	mov A, R1
	jmp print
	
normal:	
	dec A
	add A,R0
	mov R1, A  // storing the midterm's address in R1(for the time being since we will call it indirectly //
	mov A, #00h
    addc A,#00h
	mov A, #00h // Taking care of the carry flag //
	JMP reset

reset:
	mov A, @R1
	cjne A, 32h, not_equal // Comparing the middle term's value to that of what we are searching for //
	jmp print // This is when we find the number we are looking for //

not_equal:
    mov A, #00h // Handle possible overflow //
	jc else_block // Implies the value is greater than the value at mid. Therefore low = mid + 1 //
	mov A, R1 // Neither than value is less then the mid value, high = mid - 1 //
	dec A // mid = mid - 1 //
	mov R1, A  // High = Mid - 1 //
	mov 35h,A
	subb A, R0
	inc A
	mov 31h, A
	jmp start_loop
	
else_block:
    mov A, R1
	inc A  // mid = mid + 1 //
	mov R0, A  // low = mid + 1 //
	mov R1, 35h
	mov A, R1
	subb A, R0
	inc A
	mov 31h, A
	jmp start_loop
        
print:
    mov 33h,A // Storing the array location of the no. we were looking for //
    jmp true_end
	

loop_end:
    mov 33h, #0Eh // The no. we were looking for isn't present in the array //
	ret
true_end:
    nop

RET
END