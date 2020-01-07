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
	li $t1,110
	li $t2,97
	li $t3,3
	sub $t4,$t1,$t2
	li $t1,2
	mul $t2,$t3,$t1
	add $t1,$t4,$t2
	move $t3,$t1
	move $t1,$t3
	addi $sp,$sp,-4
	sw $ra,0($sp)
	jal write
	lw $ra,0($sp)
	addi $sp,$sp,4
	li $t2,0
	move $v0,$t2
	jr $ra
