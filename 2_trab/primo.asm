.data
	str1: .ascii "Digite um numero :"
	str2: .ascii "Nao eh primo!"
	str3: .ascii "Eh primo!"

.text

	la $a0, str1
	li $a1, 4
	jal Print
 	jal LeInteiro
        move $t0, $v0
        jal TestaPrimo
	j Fim

	Fim:
		li $v0, 10
		syscall
		
	LeInteiro:
		li $v0, 5
		syscall
		jr $ra
		
	Print:
		move $v0, $a1
		syscall
		jr $ra
	
	TestaPrimo:
        	
        	# Testa se o número é 1
        	addi $t4, 0x0001
        	beq $t0, $t4, EhPrimo # Sendo igual deverá sair da função
        	
        	# Testa se o número é positivo
        	sgt $t4, $t0, $zero # if(t0 > 0) se verdadeiro t4 recebe 1 se não t4 recebe 0
        	beq $t4, $zero, NaoEhPrimo # Falhou no teste sai da função
        	
        	# Testa se o numero é par
        	
        	# Ultimo teste
        	#  for(int i = 3; i < num / 2; i+= 2){
		#  	if(num % i == 0){
      		#	return 0;
   		#       }
                #  }

		# Se falhar em todos os testes anteriores Nao Eh Primo
		# Se passar por todos os testes Eh Primo
   
        	jal EhPrimo

	NaoEhPrimo:
		la $a0, str2
		li $a1, 4
		jal Print
		j Fim
	
	EhPrimo:
		la $a0, str3
		li $a1, 4
		jal Print
		j Fim
	
