.data

init_msg: .asciiz "Enter a number\n>"
msg1 :   .asciiz "Number "
msg2:	 .asciiz " Has "
msg3 :   .asciiz " Leading Zeroes\n"


.text

#This is a bonus version of lab1a... I aim to do less than n/2 steps (where n is 32 bit)
#$s0 is the integer to check
#$t1 is the mask
#$t2 is the counter 

.globl main

main :


#get input from user
li $v0, 4
la $a0, init_msg
syscall

li $v0, 5
syscall
move $s0 , $v0

#check if user is evil
li $t2, 32
beqz $s0, print_result

#init counter
li $t2, 0

#check if number is greater than 2^16-1 (The half of 2^32)
#unsigned in order to check for negative numbers
bgtu   $s0, 0xFFFF, less_zeroes
bleu   $s0, 0xFFFF, more_zeroes


less_zeroes:
#mask to check for zeroes
li $t1, 0x80000000

counter_loop_0:
	#do the and operation to compare
	and $t3, $t1, $s0
	#if not equal print results
	bnez  $t3, print_result
	
	#add 2 to counter
	addi $t2, $t2, 1
	 
	#Shift mask 2 bits 	 	
	srl  $t1, $t1, 1
	  	  	
	j counter_loop_0

	
more_zeroes:
#save input to other register
move $t4, $s0

#shift right until result is zero
counter_loop_1:
	
	beqz  $t4, fix_result
	
	#add 2 to counter
	addi $t2, $t2, 1
	#shift right
	srl $t4, $t4, 1 	
	j counter_loop_1							
				
fix_result:
#The right result is 32 - counter
li $t4, 32
subu   	$t2,$t4,$t2

#print answer to user
print_result:
li $v0, 4
la $a0, msg1
syscall

li $v0, 1
move $a0, $s0
syscall		

li $v0, 4
la $a0, msg2
syscall

li $v0, 1
move $a0, $t2
syscall		

li $v0, 4
la $a0, msg3
syscall

#exit program
li $v0, 10
syscall

