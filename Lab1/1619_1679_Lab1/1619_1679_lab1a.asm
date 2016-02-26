.data
init_msg:      .asciiz "Enter a number\n>"
String_name1: .asciiz "Number "
String_name2: .asciiz " has "
String_name3: .asciiz " leading zeros\n"

.text
#$t0 is the counter
#$s0 is the integer
#$t1 is the mask (0x80000000)

.globl main 

main:

#read user input
li $v0, 4
la $a0, init_msg
syscall

li $v0, 5
syscall
move $s0,$v0 

#check if user is evil
li $t0, 32
beqz $s0, print

#init counter
move $t0,$0 


#create mask
addi $t1,$0,1 
sll $t1,$t1,31

loop:
	and $t2,$s0,$t1
	#if $s0==1 exit loop
	bnez $t2,print
	
	srl $t1,$t1,1
	addi $t0,$t0,1

	j loop


print :	

li $v0, 4 
la $a0, String_name1 
syscall

li $v0, 1
add $a0,$s0,$0
syscall

li $v0, 4 
la $a0, String_name2 
syscall

li $v0, 1
add $a0,$t0,$0
syscall

li $v0, 4 
la $a0, String_name3 
syscall

#exit program
li $v0, 10
syscall
