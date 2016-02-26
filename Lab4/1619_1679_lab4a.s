.data 
s1:  	.space  100
s2:  	.space  100
inp1:  	.asciiz "Give s1\n>>>"
inp2:  	.asciiz "Give s2\n>>>"
outp1:   .asciiz "Result is : "

.text
.globl main

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

#read s1
print_string(inp1)
read_string($t0, s1)

#read s2
print_string(inp2)
read_string($t1, s2)

move $a0, $t0
move $a1, $t1

jal strcmp

move $s0, $v0
print_string(outp1)
print_int($s0)

exit()


#int strcmp(char *s1, char *s2)
#@param s1, s2 strings to compare
#@output : 1) -1 : s2 > s1
#	  2)  0  : s2 == s1	
#	  3)  1 : s1 > s2
strcmp:
	#store $ra to stack
	add $sp, $sp, -4
	sw  $ra, 0($sp)

	#load first chars
	lb $t0,0($a0) 
	lb $t1,0($a1)
	
	#compare chars
	blt $t0, $t1, lower
	bgt $t0, $t1, greater
	#check if strings end and equal
	beqz $t0, equals
	#if strings don't end and equal
	j rec 
	
	lower: 
		li $v0, -1
		j return
	
	greater : 
		li $v0, 1
		j return
	equals :
		li $v0, 0
		j return
	
	rec : 
		#send s1[n+1], s2[n+1], where n is recursion depth
		add $a0, $a0,1
		add $a1, $a1,1
		jal strcmp
		
		
	return:
	lw  $ra, 0($sp)
	add $sp, $sp, 4
	
	jr $ra
	