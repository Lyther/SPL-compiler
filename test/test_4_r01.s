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
hanoi:
	move $t1,$a0
	li $t2,1
	beq $t1,$t2,label0
	j label1
label0:
	move $t1,$a0
	li $t2,10000
	mul $t3,$t1,$t2
	move $t1,$a0
	add $t2,$t3,$t1
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal write
	lw $ra,0($sp)
	addi $sp,$sp,4
	j label2
label1:
	move $t1,$a0
	li $t3,1
	sub $t4,$t1,$t3
	move $t1,$a0
	move $t3,$a0
	move $t5,$a0
	move $t0,$a0
	move $a0,$t5
	move $t0,$a0
	move $a0,$t3
	move $t0,$a0
	move $a0,$t1
	move $t0,$a0
	move $a0,$t4
	addi $sp,$sp,-24
	sw $t0,0($sp)
	sw $ra,4($sp)
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $t3,16($sp)
	sw $t4,20($sp)
	jal hanoi
	lw $a0,0($sp)
	lw $ra,4($sp)
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $t3,16($sp)
	lw $t4,20($sp)
	addi $sp,$sp,24
	move $t1 $v0
	move $t1,$a0
	li $t3,10000
	mul $t4,$t1,$t3
	move $t1,$a0
	add $t3,$t4,$t1
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal write
	lw $ra,0($sp)
	addi $sp,$sp,4
	move $t1,$a0
	li $t4,1
	sub $t5,$t1,$t4
	move $t1,$a0
	move $t4,$a0
	move $t6,$a0
	move $t0,$a0
	move $a0,$t6
	move $t0,$a0
	move $a0,$t4
	move $t0,$a0
	move $a0,$t1
	move $t0,$a0
	move $a0,$t5
	addi $sp,$sp,-24
	sw $t0,0($sp)
	sw $ra,4($sp)
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $t3,16($sp)
	sw $t4,20($sp)
	jal hanoi
	lw $a0,0($sp)
	lw $ra,4($sp)
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $t3,16($sp)
	lw $t4,20($sp)
	addi $sp,$sp,24
	move $t1 $v0
label2:
	li $t1,0
	move $v0,$t1
	jr $ra
main:
	li $t1,3
	move $t4,$t1
	move $t1,$t4
	li $t4,1
	li $t5,2
	li $t6,3
	move $t0,$a0
	move $a0,$t6
	move $t0,$a0
	move $a0,$t5
	move $t0,$a0
	move $a0,$t4
	move $t0,$a0
	move $a0,$t1
	addi $sp,$sp,-24
	sw $t0,0($sp)
	sw $ra,4($sp)
	sw $t1,8($sp)
	sw $t2,12($sp)
	sw $t3,16($sp)
	sw $t4,20($sp)
	jal hanoi
	lw $a0,0($sp)
	lw $ra,4($sp)
	lw $t1,8($sp)
	lw $t2,12($sp)
	lw $t3,16($sp)
	lw $t4,20($sp)
	addi $sp,$sp,24
	move $t1 $v0
	li $t1,0
	move $v0,$t1
	jr $ra
