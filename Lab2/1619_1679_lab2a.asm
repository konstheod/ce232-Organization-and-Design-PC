.data
array: 	.byte	0x70,0x8C,0xF3,0x82,0x1B,0x9D,0x49,0x80,0x50
msg1: .asciiz "Give the pointer\n"
msg2: .asciiz "Give the offset\n"
msg3: .asciiz "Give the number of bits you want\n"
error1: .asciiz "Pointer Error!!! (0 <= p )\n"
error2: .asciiz "Offset  Error!!! (0 <= offset <= 7)\n"
error3: .asciiz "nof_bits Error!!! (0 <= nof_bits <= 32)\n"
msg_number: .asciiz "The number in hexadecimal is "

.text
#s0 = p
#s1 = offset
#s2 = nof_bits

.macro print_as_hex(%x)
	#print result
	li $v0,34
	move $a0, %x
	syscall
.end_macro	

.macro print_msg(%s)
	li $v0, 4
	la $a0,%s
	syscall
.end_macro

.macro get_int(%x)
	li $v0, 5
	syscall
	move %x , $v0
.end_macro

.macro exit()
	li $v0,10
	syscall
.end_macro

.globl main

main: 

#init to zero
move $t0,$0 

#get pointer
print_msg(msg1)
get_int($s0) 
#check answer
blt $s0, $0, print1

#get offset
print_msg(msg2)
get_int($s1) 

#check answer
bgt $s1,7,print2 #branch if offset >7
blt $s1,0,print2 #branch if offset <0

#get nof_bits
print_msg(msg3)
get_int($s2) 

#check answer
bgt $s2,32,print3 #branch if nbits >32
blt $s2,0,print3 #branch if nbits <0

#init mask
li $t1,1
sll $t1,$t1,7
#shift mask right in order to include bits after offset value
srlv $t1,$t1,$s1 

#init counter ($t2) to zero
move $t2,$0

#load first element of array
lb $s3,array($s0) 


loop:
	#if counter == nbits exit
	beq $t2,$s2,print_number 

	#read new byte if need be
	bnez $t1,continue 
		addi $s0,$s0,1 #pointer++
		lb $s3,array($s0) #load byte array[p]
		li $t1,1
		sll $t1,$t1,7 #init mask to 10000000
		j loop
	
	#else continue reading bits
	continue:
	sll $t0,$t0,1 # create space for one more bit

	and $t3,$t1,$s3 #bitwise and mask, byte
	beqz $t3,next #if ans==0 branch to next
	addi $t0,$t0,1 #else t0++

	next:
	srl $t1,$t1,1 #one bit right shift
	addi $t2,$t2,1 #counter ++
	j loop


	


print1:
print_msg(error1)
j exit

print2:
print_msg(error2)
j exit

print3:
print_msg(error3)
j exit


print_number: 
print_msg(msg_number)

print_as_hex($t0)

exit:
exit()
