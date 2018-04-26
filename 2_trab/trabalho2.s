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

.text
	jal ReadNumbers
	move $t0,$v0
	jal ReadNumbers
	move $t1,$v0
	jal ReadNumbers
	move $t2,$v0
	
	move $t4,$t0
	move $t5,$t1 # t5 only used on print
	
	li $t6,2
	move $a0,$t2
	j CheckPrimeBruteForce

	ExponentialStart: # only to use in CheckPrimeBruteForce
		seq $t3,$t1,1
		bne $t3,1,ExponentialLoop
	
		move $a0,$t0
		move $a1,$t2
		jal Mode
		move $t4,$v0
		j EXIT

	ExponentialLoop:
		sgt $t3,$t1,1 # if(t1 > 0) then t3 = 1 else t3 = 0
		beq $t3,$zero,FinalExponentMessage
	
		move $a0,$t4 #  Make t4 mod(t2)
		move $a1,$t2 #
		jal Mode	 #
		move $t4,$v0 #

		mul $t4,$t4,$t0
	
		move $a0,$t4 #  Make t4 mod(t2)
		move $a1,$t2 #
		jal Mode	 #
		move $t4,$v0 #
	
		subi $t1,$t1,1
	
		j ExponentialLoop
	
	FinalExponentMessage:
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
	
	ReadNumbers:
		li $v0,5
		syscall
		jr $ra
	
	Mode:
		div $a0,$a1
		mfhi $v0
		jr $ra
	
	CheckPrimeBruteForce:# it's a loop # https://gist.github.com/CarterA/1587394
		# 	remember $t6 starts with 2
		slt $t3,$t6,$a0 # if i < n get out
		bne $t3,1,ExponentialStart 
	
		move $a0,$a0 #  Make a0 mod(t6)
		move $a1,$t6 #
		jal Mode	 #
	
		seq $t3,$v0,$zero
		bnez $t3,ErrorMessage # se der merda é essa linha aqui
		
		addi $t6,$t6,1
		j CheckPrimeBruteForce
		
	Print:
		move $v0,$a1
		syscall
		jr $ra
		
	ErrorMessage:
		la $a0, errorMessage
		li $a1,4
		jal Print
		j EXIT
		
		
	EXIT: # program exit