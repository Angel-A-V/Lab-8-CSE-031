recursion:
    addi $sp, $sp, -12       # Adjust stack pointer for saving registers
    sw $ra, 0($sp)           # Save the return address to the stack
    sw $a0, 4($sp)           # Save the argument $a0 to the stack

    # Base case: m == -1
    beq $a0, -1, if_negative_one

    # Base case: m <= -2
    ble $a0, -2, if_less_equal_negative_two

    # Recursive case
    addi $t0, $a0, -3        # Prepare argument m - 3
    move $a0, $t0
    jal recursion            # Call recursion(m - 3)

    move $t1, $v0            # Save the result of recursion(m - 3)
    lw $a0, 4($sp)           # Restore original $a0
    add $t1, $t1, $a0        # Add m to recursion(m - 3)

    addi $a0, $a0, -2        # Prepare argument m - 2
    jal recursion            # Call recursion(m - 2)

    add $v0, $t1, $v0        # Combine results of recursion(m - 3) + m + recursion(m - 2)

    j end_recur              # Jump to end of recursion

if_negative_one:
    li $v0, 3                # Return 3 for m == -1
    j end_recur

if_less_equal_negative_two:
    li $v0, 1                # Return 1 for m <= -2
    j end_recur

end_recur:
    lw $ra, 0($sp)           # Restore return address
    lw $a0, 4($sp)           # Restore argument $a0
    addi $sp, $sp, 12        # Restore stack pointer
    jr $ra                   # Return to caller
