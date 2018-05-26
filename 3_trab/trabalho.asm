.data
	guess: .double 0.5
	three: .double 3.0
	zero: .double 0.0
	str1: .asciiz "A raiz cubica eh "
	str2: .asciiz ". O erro eh menor que "
	errorLimit: .double 0.0000000000001
	
	# The parameters registers are f0 and f14 (replacing a0 and a1 from integer operations)
	# f0 also works as a return parameter
	# f2 the number entered by the user
	# f4 guess for NewtonRapson method
	# f6 has the value of guess/last result power 3 and the value of the divident: (x0^3 - targetValue)
	# and at last f3 also have the result of the division
	# f8 stores the value 3, originated from the derivative
	# f10 has the divider value : (x0^2 * 3)

.text
	jal ReadNumbers
	mov.d $f2,$f0 # $f2 has the target(user input) value
	
	l.d $f4,guess 
	l.d $f8,three
	l.d $f16,errorLimit
	
	Newton_Raphson:
		mov.d $f14,$f4 # make guess power 3
		mov.d $f0,$f4  #
		li $a0,3       #
		jal Power      # stores the value in f0
		
		sub.d $f6,$f0,$f2 # Dividend. subtract guess^3 by user input (x0^3 - input)
		
		mov.d $f14,$f4 # make guess power 2
		mov.d $f0,$f4  #
		li $a0,2	   #
		jal Power      # stores the value in f0
		
		mul.d $f10,$f0,$f8 # Divider (3 * guess^2)
		
		div.d $f6,$f6,$f10 # Division result  (x0³ - input) / (3 - guess²)
		
		sub.d $f6,$f4,$f6 # Subtract guess from division result
		
		jal Error # Calculate error
		
		c.lt.d $f14,$f16 # Set True if error is less than e^-13
		
		bc1t PrintFinalMessage
		
		mov.d $f4,$f6 # f2 = f4  # f3 = f6
		j Newton_Raphson
	
	Power: # $f0 and $f14 need to be loaded with the parameter
		mul.d $f0,$f0,$f14 # f14 keeps the original value and f0 works as a accumulator
		sub $a0,$a0,1     # subtracts one from a0(exponent)
		bne $a0,1,Power   # when a0 has the value of 1 go back to caller
		jr $ra
	
	ReadNumbers:  # Read a float number and store the value o f0
		li $v0,7
		syscall
		jr $ra	
	
	Error:
		mov.d $f14,$f6	# performs f6³(f6 being the result) and keeps the value in f0
		mov.d $f0,$f6 
		li $a0,3
		
		subi $sp,$sp,4 # store last $ra
		sw $ra,0($sp)  #
		
		jal Power
		
		lw $ra,0($sp)  # load $ra stored
		addi $sp,$sp,4 #
		
		sub.d $f14,$f2,$f0	# calculate error and save on f14
		abs.d $f14,$f14		# get absolute value of the error
		jr $ra
		
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
