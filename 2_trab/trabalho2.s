.data
	str1: .asciiz "A exponencial modular "
	str2: .asciiz " elevado a "
	str3: .asciiz " (mod "
	str4: .asciiz ") eh "
	errorMessage: .asciiz "O numero nao eh primo"

# Variables Tracking 
#	$t0 = store the base
#	$t1 = store the exponent
#	$t2 = store the mode
#	$t3 = random register used with slt, sgt and branch instructions
#	$t4 = store $t0 mod($t2) and the final result
#	$t5 = only used on final print message
#	$t6 = store the CheckPrimeBruteForce loop counter

.text
	jal ReadNumbers # Read base
	move $t0,$v0
	jal ReadNumbers # Read exponential
	move $t1,$v0
	jal ReadNumbers # Read mod
	move $t2,$v0
	
	move $t4,$t0 # Attribute the base to #t4 so we can iterate over the loop
	move $t5,$t1 # t5 only used on final message print
	
	li $t6,2 	  # Initiating $t6 with 2 for CheckPrimeBruteForce loop
	move $a0,$t2  # Pass mod as a parameter to use on CheckPrimeBruteForce
	j CheckPrimeBruteForce

	ExponentialStart: # only to use in CheckPrimeBruteForce branch
		seq $t3,$t1,1				#
									#
		move $a0,$t0				# Make base mod(mode) and
		move $a1,$t2				# verify if exponent is 1
		jal Mode    				# if it is, show final message and
		move $t4,$v0				# end the program

		bne $t3,1,ExponentialLoop   # 
		j FinalExponentMessage		#

	ExponentialLoop:
		sgt $t3,$t1,1 # if(t1 > 0) then t3 = 1 else t3 = 0
		beq $t3,$zero,FinalExponentMessage
		
		mul $t4,$t4,$t0 # $t4 = ($t4 mod($t2)) * $t0
	
		move $a0,$t4 #  Make t4 mod(t2)
		move $a1,$t2 #
		jal Mode	 #
		move $t4,$v0 #
	
		subi $t1,$t1,1 # decrement the exponent by one
	
		j ExponentialLoop
	
	FinalExponentMessage: # Print final success message
		la $a0, str1
		li $a1,4
		jal Print
		
		move $a0, $t0
		li $a1,1
		jal Print	
	
		la $a0, str2
		li $a1,4
		jal Print
	
		move $a0, $t5
		li $a1,1
		jal Print
	
		la $a0, str3
		li $a1,4
		jal Print
	
		move $a0, $t2
		li $a1,1
		jal Print
	
		la $a0, str4
		li $a1,4
		jal Print
	
		move $a0, $t4
		li $a1,1
		jal Print
		
		j EXIT
	
	ReadNumbers: # read an integer and store in $v0
		li $v0,5
		syscall
		jr $ra
	
	Mode:	# make $a0 mod($a1) and store the result on $v0
		div $a0,$a1
		mfhi $v0
		jr $ra
	
	CheckPrimeBruteForce:# it's a loop 
								   # remember $t6 starts with 2
		slt $t3,$t6,$a0 		   # if $t6 < $a0(mod) then $t3 = 1 and the CheckPrimeBruteForce continues
		bne $t3,1,ExponentialStart # if $t3 == 0 it means that $a0 is a prime number, then go to ExponentialStart
	
					 #   a0 mod(t6)
		move $a1,$t6 #
		jal Mode	 #
	
		seq $t3,$v0,$zero     # if $v0 == 0 than $t3 == 1 and the loop stops
		bnez $t3,ErrorMessage # if the remain of the division is equal zero, it is not a prime
		
		addi $t6,$t6,1		    # increment $t6 by one
		j CheckPrimeBruteForce
		
	Print:			# Print whatever is on $a0. $a1 specifies what to print (number, string, ..)
		move $v0,$a1
		syscall
		jr $ra
		
	ErrorMessage: #Print error message
		la $a0, errorMessage
		li $a1,4
		jal Print
		j EXIT
		
		
	EXIT: # program exit
