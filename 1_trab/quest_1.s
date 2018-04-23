.text
	li $1,0x55555555
	sll $2,$1,1 #shift logial left on 0x55555555
	or $3,$1,$2 # AAAAAAAA bit-bit or 55555555 
	and $4,$1,$2 # AAAAAAAA bit-bit and 55555555 
	xor $5,$1,$2 # AAAAAAAA bit-bit xor 55555555 
	