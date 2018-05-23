.data
	guess: .float 0.5
	three: .float 3.0
	zero: .float 0.0
	str1: .asciiz "A raiz cubica eh "
	str2: .asciiz ". O erro eh menor que "
	
	# The parameters registers are f0 and f7 (replacing a0 and a1 from integer operations)
	# f0 also works as a return parameter
	# f1 the number entered by the user
	# f2 guess for NewtonRapson method
	# f3 has the value of guess/last result power 3 and the value of the divident: (x0^3 - targetValue)
	# and at last f3 also have the result of the division
	# f4 stores the value 3, originated from the derivative
	# f5 has the divider value : (x0^2 * 3)

.text
	jal ReadNumbers
	mov.s $f1,$f0 # $f1 has the target value
	
	l.s $f2,guess
	l.s $f4,three
	
	Newton_Raphson:
		mov.s $f7,$f2
		mov.s $f0,$f2
		li $a0,3
		jal Power
		
		sub.s $f3,$f0,$f1 # f0 has the guess/last value power 3
		
		mov.s $f7,$f2
		mov.s $f0,$f2
		li $a0,2
		jal Power
		
		mul.s $f5,$f0,$f4 # Divider
		
		
		div.s $f3,$f3,$f5 # final result
		
		sub.s $f3,$f2,$f3
	
		c.eq.s $f2,$f3
		
		bc1t Error
		mov.s $f2,$f3
		j Newton_Raphson
	
	Power: # $f0 and $f7 need to be loaded with the parameter
		mul.s $f0,$f0,$f7 # f7 keeps the original value and f0 works as a accumulator
		sub $a0,$a0,1     # subtracts one from a0(exponent)
		bne $a0,1,Power   # when a0 has the value of 1 go back to caller
		jr $ra
	
	ReadNumbers:  # Read a float number and store the value o f0
		li $v0,6
		syscall
		jr $ra	
	
	Error:
		mov.s $f7,$f3	# performs f3^3(f3 being the result) and keeps the value in f0
		mov.s $f0,$f3
		li $a0,3
		jal Power
		
		sub.s $f7,$f1,$f0	# calculate error and save on f7
		
	PrintFinalMessage:
		li $v0,4
		la $a0,str1
		syscall
		li $v0,2
		mov.s $f12,$f3
		syscall
		
		li $v0,4
		la $a0,str2
		syscall		
		li $v0,2
		abs.s $f12,$f7
		syscall
		
	EXIT:
