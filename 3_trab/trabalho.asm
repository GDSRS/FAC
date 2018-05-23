.data
	guess: .float 0.5
	three: .float 3.0
	zero: .float 0.0
	str1: .asciiz "A raiz cubica eh "
	str2: .asciiz ". O erro eh menor que "
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
		mov.s $f3,$f0 #f3 has the value of 0.5^3
		
		sub.s $f5,$f3,$f1 # Dividend = f5
		
		mov.s $f7,$f2
		mov.s $f0,$f2
		li $a0,2
		jal Power
		mov.s $f8,$f0
		
		mul.s $f8,$f8,$f4 # Divider
		
		
		div.s $f6,$f5,$f8 # final result
		
		sub.s $f6,$f2,$f6
	
		c.eq.s $f2,$f6
		
		bc1t Error
		mov.s $f2,$f6
		j Newton_Raphson
	
	Power: # $f0 and $f7 need to be loaded with the parameter
		mul.s $f0,$f0,$f7
		sub $a0,$a0,1
		bne $a0,1,Power
		jr $ra
	
	ReadNumbers:
		li $v0,6
		syscall
		jr $ra	
	
	Error:
		mov.s $f7,$f6
		mov.s $f0,$f6
		li $a0,3
		jal Power
		sub.s $f7,$f1,$f0	
		
	PrintFinalMessage:
		li $v0,4
		la $a0,str1
		syscall
		li $v0,2
		mov.s $f12,$f6
		syscall
		
		li $v0,4
		la $a0,str2
		syscall		
		li $v0,2
		mov.s $f12,$f7
		syscall
		
	EXIT:
