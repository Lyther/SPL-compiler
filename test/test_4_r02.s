.data
_prompt: .asciiz "Enter an integer:"
_ret: .asciiz "\n"
.globl main
.text
read:
    li $v0,4
    la $a0,_prompt
    syscall
    li $v0,5
    syscall
    jr $ra
write:
    li $v0,1
    syscall
    li $v0,4
    la $a0,_ret
    syscall
    move $v0,$0
    jr $ra
main:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal read
	lw $ra,0($sp)
	addi $sp,$sp,4
	move $t1,$t2
	move $t3,$t1
	li $t4,0
	bgt $t3,$t4,label0
	j label1
label0:
	li $t3,1
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal write
	lw $ra,0($sp)
	addi $sp,$sp,4
	j label2
label1:
	move $t4,$t1
	li $t1,0
	blt $t4,$t1,label3
	j label4
label3:
	li $t1,1
	sub $t4,$t5,$t1
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal write
	lw $ra,0($sp)
	addi $sp,$sp,4
	j label5
label4:
	li $t1,0
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal write
	lw $ra,0($sp)
	addi $sp,$sp,4
label5:
label2:
	li $t6,0
	move $v0,$t6
	jr $ra
