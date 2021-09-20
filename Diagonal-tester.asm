.data
aMatrix: .word 1 2 3 4 #[[1, 2], [3, 4]]
bVector: .word 3 5  #[3, 5]
cMatrix: .word 0xDEAD 0xC0DE 0xF00D 0xBAD

# [[1+3, 2], [3, 4+5]] 
expected: .word 4 2 3 9

.text
.globl main
main:
la $a0, aMatrix # 2z2 matrix A
la $a1, bVector # 2 element vector
la $a2, cMatrix # 2x2 matrix C (result)
addi $a3, $0, 2 # N = 2
jal DiagAdd # call NMM(&a, &b, &c, 2)
#CHECK IF IT WORKED!
la $t0, cMatrix # Destination 
la $t1, expected # Expected
addi $t2, $0, 4 # N * N = 4
addi $t3, $0, 0 # error count = 0
loopcheck:
lw $t4, 0($t0) # item from C 
lw $t5, 0($t1) # item from expected
addi $t0, $t0, 4
addi $t1, $t1, 4
xor $t4, $t5, $t4
beq $t4, $0, skip
addi $t3, $t3, 1
skip:addi $t2, $t2, -1
bne $t2, $0, loopcheck
addi $v0, $0, 1
add $a0, $0, $t3 # move error count
syscall # print error count
addi $v0, $0, 10
syscall # exit
