.data

msgH1:    .asciiz "Iteration "
msgH2:    .asciiz "\n-----------\n"
msgN1 :   .asciiz "Please Give N1:\n > "
msgN2 :   .asciiz "Please Give N2:\n > "
msgE1:    .asciiz "========================================\nThe max final union of range is ["
msgE2:    .asciiz ","
msgE3:    .asciiz "]\n========================================"

.text

#t0 current min
#t1 current max
#$t2 new entry min
#$t3 new entry max
#$t4 current range length
#$t5 iteration counter
#$t6 new range length

.globl main

main :

#init counter
li $t5, 0

#init current [min. max ] range to [0,0]
li $t0, 0
li $t1, 0


big_fat_loop:
	#get input from user and init new entry range [min,max]($t2, $t3)
	li $v0, 4
	la $a0, msgH1
	syscall

	li $v0, 1
	move $a0 , $t5
	syscall

	li $v0, 4
	la $a0, msgH2
	syscall

	li $v0, 4
	la $a0, msgN1
	syscall


	li $v0, 5
	syscall
	move $t2 , $v0
	
	#check if user wants to terminate program
	blt $t2,$zero, print_exit

	li $v0, 4
	la $a0, msgN2
	syscall

	li $v0, 5
	syscall
	move $t3 , $v0
	
	#check if user wants to terminate program
	blt $t3,$zero, print_exit
	
	
	#add one to iteration
	addi $t5, $t5, 1
	
	#first check if join(Union1, Union2)!=0
	blt $t3,$t0, not_join
	bgt $t2,$t1, not_join
	
	#else join ranges
	set_min:
	bgt $t2,$t0,set_new_min
	set_max:
	blt $t3,$t1,set_new_max
	
	j big_fat_loop
	
	set_new_min:
		move $t0,$t2
		j set_max
	set_new_max:
		move $t1,$t3
		j big_fat_loop	
	
	
	not_join:
		#check which length is greatest	
		sub $t4,$t1,$t0
		sub $t6,$t3, $t2
		
		#check which is the longest
		bgt $t6, $t4, set_new	
		#if still our old one is the longest
		j big_fat_loop
		
		
		set_new:
			move $t0, $t2
			move $t1, $t3
			j big_fat_loop
			
	
	
print_exit:
li $v0, 4
la $a0, msgE1
syscall

li $v0, 1
move $a0 , $t0
syscall
	
li $v0, 4
la $a0, msgE2
syscall
	
li $v0, 1
move $a0 , $t1
syscall
	
li $v0, 4
la $a0, msgE3
syscall

#exit program
li $v0, 10
syscall
