.data
labels: .word  	goHere, goThere
msg1: .asciiz 	"-Going There!!!\n"
msg2: .asciiz   "-Went There!!!\n-Going Here!!!\n"
msg3: .asciiz   "-Went Here!!!\n-Terminating!!!"

.text
.globl main

.macro beqr(%r1, %r2, %r3)
	bne %r1, %r2, not_equal  
	jr %r3
	
	not_equal:

.end_macro



main:

lw $t1, labels($0)

li $t2, 4
lw $t2, labels($t2)



li $t3 , 4
li $t4 , 4

li $v0,4
la $a0,msg1
syscall
beqr ($t3, $t4,$t2)


goHere:

li $v0,4
la $a0,msg3
syscall
li $v0, 10
syscall


goThere:
li $v0,4
la $a0,msg2
syscall
beqr ($t3, $t4,$t1)
