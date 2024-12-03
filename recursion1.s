.data
prompt: .asciiz "Please enter an integer: "

.text
main:
    addi $sp, $sp, -16      # Adjust stack pointer to allocate space for local variables

    # TPS 2 #3 (display input prompt)
    la $a0, prompt          # Load the address of the prompt string
    li $v0, 4               # Load system call code for printing a string
    syscall                 # Execute the system call to display the prompt

    # TPS 2 #4 (read user input)
    li $v0, 5               # Load system call code for reading an integer
    syscall                 # Execute the system call to read an integer
    move $s0, $v0           # Store user input in $s0 (local variable)
    move $a0, $s0           # Prepare argument for recursion(x)

    jal recursion           # Call the recursion function with user's input

    # TPS 2 #6 (print out returned value)
    move $a0, $v0           # Move the returned value to $a0 for printing
    li $v0, 1               # Load system call code for printing an integer
    syscall                 # Execute the system call to print the result

    j end                   # Jump to program termination section

# TPS 2 #7: Implementing recursion
recursion:
    addi $sp, $sp, -32      # Adjust stack pointer to create space for stack frame
    sw $s0, 16($sp)         # Save $s0 to the stack frame
    sw $ra, 20($sp)         # Save return address to the stack frame
    sw $s1, 24($sp)         # Save $s1 (local variable) to the stack frame
    sw $a0, 32($sp)         # Save $a0 (current argument) to the stack

    # TPS 2 #8: Base case for recursion (m == -1)
    addi $t0, $a0, 1
    bne $t0, $zero, not_minus_one  # If $a0 != -1, jump to `not_minus_one`
    addiu $v0, $zero, 3            # Return 3 for m == -1
    j end_recur

not_minus_one:
    # TPS 2 #9: Base case for recursion (m <= -2)
    li $t0, -2
    bgt $a0, $t0, not_lte_negative_two  # If $a0 > -2, jump to `not_lte_negative_two`
    bge $a0, $t0, not_lt_negative_two   # If $a0 >= -2, jump to `not_lt_negative_two`
    addiu $v0, $zero, 2                 # Return 2 for m < -2
    j end_recur

not_lt_negative_two:
    addiu $v0, $zero, 1                 # Return 1 for m == -2
    j end_recur

not_lte_negative_two:
    # TPS 2 #10: Recursive case: m > -2
    sw $a0, 4($sp)          # Save $a0 (current m) to stack

    # TPS 2 #11: Prepare first argument (m - 3) for recursion
    lw $a0, 32($sp)         # Restore $a0 from stack
    subiu $a0, $a0, 3       # Set $a0 to m - 3
    jal recursion           # Call recursion(m - 3)

    # TPS 2 #12: Save result of recursion(m - 3)
    addu $s1, $v0, $zero    # Store result of recursion(m - 3) in $s1
    lw $a0, 32($sp)         # Restore $a0 from stack (current m)
    addu $s1, $s1, $a0      # Add m to recursion(m - 3)

    # TPS 2 #13: Prepare second argument (m - 2) for recursion
    lw $a0, 32($sp)         # Restore $a0 from stack
    subiu $a0, $a0, 2       # Set $a0 to m - 2
    jal recursion           # Call recursion(m - 2)

    # TPS 2 #14: Update returned value
    addu $v0, $v0, $s1      # Combine results of recursion(m - 3) and recursion(m - 2)

end_recur:
    # TPS 2 #15: Restore stack and return
    lw $s0, 16($sp)         # Restore $s0 from stack
    lw $ra, 20($sp)         # Restore return address
    lw $s1, 24($sp)         # Restore local variable $s1
    addi $sp, $sp, 32       # Deallocate stack frame
    jr $ra                  # Return to caller

end:
    addi $sp, $sp, 16        # Restore stack pointer to its original state
    li $v0, 10              # Load system call code for program exit
    syscall                 # Exit the program
	