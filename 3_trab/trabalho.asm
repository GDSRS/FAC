.data
	guess: .double 0.5
	three: .double 3.0
	zero: .double 0.0
	str1: .asciiz "A raiz cubica eh "
	str2: .asciiz ". O erro eh menor que "
	newLine: .asciiz "\n"

	
	# The parameters registers are f0 and f7 (replacing a0 and a1 from integer operations)
	# f0 also works as a return parameter
	# f1 the number entered by the user
	# f2 guess for NewtonRapson method
	# f3 has the value of guess/last result power 3 and the value of the divident: (x0^3 - targetValue)
	# and at last f3 also have the result of the division
	# f4 stores the value 3, originated from the derivative
	# f5 has the divider value : (x0^2 * 3)
	# Double parse
	# f1 = f2
	# f2 = f4
	# f3 = f6
	# f4 = f8
	# f5 = f10
	# f7 = f14

.text
	jal ReadNumbers
	mov.d $f2,$f0 # $f2 has the target value F1 -> F2
	
	l.d $f4,guess # f2 = f4
	l.d $f8,three # f4 = f8
	
	Newton_Raphson:
		mov.d $f14,$f4 # f2 = f4 # f7 = f14
		mov.d $f0,$f4 # f2 = f4
		li $a0,3
		jal Power
		
		sub.d $f6,$f0,$f2 # f0 has the guess/last value power 3 F1 -> F2 # f3 = f6
		
		mov.d $f14,$f4 # f2 = f4 # f7 = f14
		mov.d $f0,$f4 # f2 = f4
		li $a0,2
		jal Power
		
		mul.d $f10,$f0,$f8 # Divider # f4 = f8 # f5 = f10
		
		
		div.d $f6,$f6,$f10 # final result  # f3 = f6 # f5 = f10
		
		sub.d $f6,$f4,$f6 # f2 = f4  # f3 = f6
		
		c.eq.d $f4,$f6 # f2 = f4  # f3 = f6
		bc1t Error
		mov.d $f4,$f6 # f2 = f4  # f3 = f6
		j Newton_Raphson
	
	Power: # $f0 and $f7 need to be loaded with the parameter
		mul.d $f0,$f0,$f14 # f7 keeps the original value and f0 works as a accumulator # f7 = f14
		sub $a0,$a0,1     # subtracts one from a0(exponent)
		bne $a0,1,Power   # when a0 has the value of 1 go back to caller
		jr $ra
	
	ReadNumbers:  # Read a float number and store the value o f0
		li $v0,7
		syscall
		jr $ra	
	
	Error:
		mov.d $f14,$f6	# performs f3^3(f3 being the result) and keeps the value in f0 # f3 = f6 # f7 = f14
		mov.d $f0,$f6 # f3 = f6
		li $a0,3
		jal Power
		
		sub.d $f14,$f2,$f0	# calculate error and save on f14
		
	PrintFinalMessage:
		li $v0,4
		la $a0,str1
		syscall
		li $v0,3
		mov.d $f12,$f6 # f3 = f6
		syscall
		
		li $v0,4
		la $a0,str2
		syscall		
		li $v0,3
		abs.d $f12,$f14 # f7 = f14
		syscall
		
	EXIT:
