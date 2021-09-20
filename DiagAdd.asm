.text
.globl DiagAdd
DiagAdd:
# ARGUMENTS WILL BE PASSED AS FOLLOWS:
#a0 = address of row-major NxN matrix A; Equivalently, address of A[0][0]
#a1 = address row-major N-vector B; Equivalently, address of B[0]
#a2 = address of row-major NxN matrix C; Equivalently, address of C[0][0]
#a3 = N
# 
# Assume N >= 1; A, B, C elements all 32-bit integers

# EXPECTED BEHAVIOR AFTER EXECUTION:
# Sets the value of C = A except along diagonal, where B is added to the diagonal, i.e.
# when i!=j C[i][j] = A[i][j]; when i==j, C[i][j]=A[i][j]+B[i]

# Provided code currently loops over all i, j values, but does nothing -- replace with code implementing expected behavior

add $t0, $0, $0 		# i = 0;
  iLOOP:			#  horizontal Loop
    add $t1, $0, $0 		#   j = 0;
    sll $t7, $t0, 2		#   itemp = i*4 > mult i by 4 for offset
    mult $t7, $a3		#   itemp = i*N > mult i by N to find row
    mflo $t7			#   retrieve mult result
    sll $t0, $t0, 2		#   i *= 4 for B
    add $t4, $t0, $a1		#   $t4 = address of B[i]
    srl $t0, $t0, 2		#   i /= 4 to change back
    lw $t4, ($t4)		#   diagAddVal ($t4) = B[i]
    jLOOP:			#   DO {
    sll $t6, $t1, 2		#	jtemp = j * 4 > mult j by 4 for offset
    add $t5, $a0, $t7		#	$t5 = A[i}
    add $t5, $t5, $t6		#	$t5 = A[i][j] address
    lw $t5, ($t5)		#	$t5 = value of A[i][j]
    add $t2, $a2, $t7		#	$t2 = address of C[i]
    add $t2, $t2, $t6		#	$t2 = address of C[i][j]
    bne $t0, $t1, nondiag	#	if (i==j) > branch on $t1 vs $t0
    add $t3, $0, $t5		#		C[i][j] = A[i][j]
    add $t3, $t3, $t4 		#		C[i][j] += B[i] 
    sw $t3, ($t2)		#		Save C[i][j] value to address of C[i][j]
    j diag			#	else
nondiag:sw $t5, ($t2)		#		C[i][j] = A[i][j]
diag:addi $t1, $t1, 1 		#     j++
    bne $t1, $a3, jLOOP		#   } while j < N
    addi $t0, $t0, 1		#   i++
  bne $t0, $a3, iLOOP		# } while i < N
jr $ra 				# return
