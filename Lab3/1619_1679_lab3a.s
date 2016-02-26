.data

string:   	.space  	100
init_string:  	.asciiz 	"Give a string\n>>"
string_404  :	.asciiz		"Pattern Not Found"
output  :		.asciiz		"Pattern Found At Position "
.align 2
casesFSM:        .word           state1 state2 


.text

#@param %s string to print
.macro print_string(%s)
	li $v0,4
	la $a0, %s 
	syscall
.end_macro


#@param %x register to point to string
#@param %s data segment to store string to 
.macro read_string(%x, %s)
	li $v0,8
	la $a0, %s 
	li $a1, 100 #limit to 100 bytes string
	move %x,$a0 #save string to register
	syscall
.end_macro

.macro print_int(%x)
	li $v0, 1
	move $a0, %x
	syscall
.end_macro


.macro exit()
	li $v0, 10
	syscall
.end_macro

main:

#get input from user
#$t1 contains pointer to string
print_string(init_string)
read_string($t1, string)

#send string as input
move $a0, $t1
#call function
jal findPattern

move $t0, $v0

bltz $t0, not_found

print_string(output)
print_int($t0)

terminate:
exit()


not_found :
print_string(string_404)
j terminate



#int findPattern(char * str)
#@param $a0 = char * str
#@output $v0 = first occurance of string
findPattern:
	
	#store $s0,$s1 in $sp
	addi $sp ,$sp, -4
	sw   $s1, 0($sp)
	
	
	#$s1 is our string
	la $s1, ($a0)
	

	#return value set to 0
	move $v0, $0
	# $t1 is counter 
	move $t1, $0
	# $t6 is current state
	li $t6, 0
	
	loop:
		#load character to $t3
		lb   $t3, 0($s1)
		beqz $t3, return_miss
		add  $s1, $s1, 1
		
		#go to appr. state
		sll $t4, $t6, 2
		lw $t5,casesFSM($t4) 
		jr  $t5	
		
		#state1 accepts a 			
		state1:
			beq $t3, 'a', match1
			beq $t3, 'b', miss1
			j miss
			#in case of miss wait for a in the 
			#same state.			
			miss1:
				add $v0, $v0, $t1
				add $v0, $v0, 1
				li $t1, 0
				li $t6, 0
				j loop
			#in case of match go to state 2		
			match1:
				add $t1, $t1,1 
				li $t6, 1
				j loop
		#state2 accepts b or a if appropriate	
		state2:
			#if final (state 5 in FSM) wait for a
			bne $t1, 5, not_final
				beq $t3, 'b', miss_final
				bne $t3, 'a', miss
				#if match return success
				j return_match
				#if not stay in same state and wait for a
				miss_final:
					add $t1, $t1, -1
					add $v0, $v0, 2
					li $t6, 0
					j loop			
			#if fsm state < state 5 accept b	
			not_final: 
			beq $t3, 'a', miss2
			beq $t3, 'b', match2
			j miss
			#if a stay in this state
			miss2:
				add $v0, $v0, $t1
				li $t1, 1
				li $t6, 1
				j loop
			#if b go to next FSM State and state1		
			match2:
				add $t1, $t1,1 
				li $t6, 0
				j loop	
		#if invalid character go to state 0 			
		miss:
			add $v0, $v0, $t1
			add $v0, $v0,1
			move $t6, $0
			move $t1, $0
			j loop
		
	
	return_match:
	lw   $s1, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	return_miss:
	lw   $s1, 0($sp)
	addi $sp, $sp, 4
	li $v0 -1
	jr $ra
