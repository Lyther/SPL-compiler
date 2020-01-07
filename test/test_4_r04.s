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
fact:
	beq $a0,$t1,label1
	j label2
label1:
	move $v0,$a0
	jr $ra
label2:
	addi $t2,$a0,-1
	move $t0,$a0
	move $a0,$t2
	addi $sp,$sp,-24
	sw $t0,0($sp)
	sw $ra,4($sp)
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $t3,16($sp)
	sw $t4,20($sp)
	jal fact
	lw $a0,0($sp)
	lw $ra,4($sp)
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $t3,16($sp)
	lw $t4,20($sp)
	addi $sp,$sp,24
	move $t3 $v0
	mul $t4,$a0,$t3
	move $v0,$t4
	jr $ra
main:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal read
	lw $ra,0($sp)
	addi $sp,$sp,4
	move $t5,$t6
	bgt $t5,$t1,label3
	j label4
label3:
	move $t0,$a0
	move $a0,$t5
	addi $sp,$sp,-24
	sw $t0,0($sp)
	sw $ra,4($sp)
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $t3,16($sp)
	sw $t4,20($sp)
	jal fact
	lw $a0,0($sp)
	lw $ra,4($sp)
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $t3,16($sp)
	lw $t4,20($sp)
	addi $sp,$sp,24
	move $t5 $v0
	move $t7,$t5
	j label5
label4:
	li $t7,1
label5:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal write
	lw $ra,0($sp)
	addi $sp,$sp,4
	move $v0,$t8
	jr $ra
