.text
	jal ReadNumbers
	move $t0,$v0
	jal ReadNumbers
	move $t1,$v0
	jal ReadNumbers
	move $t2,$v0
	
	move $t4,$t0

#	jal CheckPrimeBruteForce
	seq $t3,$t1,1
	bne $t3,1,ExponentialLoop
	
	move $a0,$t0
	move $a1,$t2
	jal Mode
	move $t4,$v0
	j EXIT

	ExponentialLoop:
	sgt $t3,$t1,1 # if(t1 > 0) then t3 = 1 else t3 = 0
	beq $t3,$zero,EXIT
	
	move $a0,$t4 #  Make t0 mod(t2)
	move $a1,$t2 #
	jal Mode	 #
	move $t4,$v0 #

	mul $t4,$t4,$t0
	
	move $a0,$t4 #  Make t0 mod(t2)
	move $a1,$t2 #
	jal Mode	 #
	move $t4,$v0 #
	
	subi $t1,$t1,1
	
	j ExponentialLoop

	j EXIT
	
	ReadNumbers:
	li $v0,5
	syscall
	jr $ra
	
	Mode:
	div $a0,$a1
	mfhi $v0
	jr $ra
	
	CheckPrimeBruteForce: # https://gist.github.com/CarterA/1587394
	li $t3,2
	div $t2,$t3
	mfhi $t4
	jr $ra
		
	EXIT: # program exit
	
#	(https://stackoverflow.com/questions/5281779/c-how-to-test-easily-if-it-is-prime-number) 
