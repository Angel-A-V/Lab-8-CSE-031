.data
prompt: .asciiz "Please enter an integer: "

.text
main:
    addi $sp, $sp, -4      # Adjust stack pointer to allocate space for local variables

    # TPS 2 #3 (display input prompt)
    li $v0, 4              # Load system call code for printing a string
    la $a0, prompt         # Load the address of the prompt string
    syscall                # Execute the system call to display the prompt

    # TPS 2 #4 (read user input)
    li $v0, 5              # Load system call code for reading an integer
    syscall                # Execute the system call to read an integer from the user
    move $a0, $v0          # Move the input value into $a0 for further processing

    jal recursion          # Call the recursion function with the user's input

    # TPS 2 #6 (print out returned value)
    move $a0, $v0          # Move the returned value to $a0 for printing
    li $v0, 1              # Load system call code for printing an integer
    syscall                # Execute the system call to print the result

    j end                  # Jump to the program termination section

# Implementing recursion
recursion:
    addi $sp, $sp, -12     # Adjust stack pointer to make room for saving return address and local variables
    sw $ra, 0($sp)         # Save the return address to the stack

    addi $t0, $a0, 1
    bne $t0, $zero, not_minus_one  # Check if $a0 is not -1

    # TPS 2 #8 (update returned value)
    addi $v0, $zero, 1      # Return 1 for m == -1
    j end_recur

not_minus_one:
    bne $a0, $zero, not_zero  # Check if $a0 is not 0

    # TPS 2 #9 (update returned value)
    addi $v0, $zero, 3      # Return 3 for m==0
    j end_recur

not_zero:
    	# Save the current value of $a0 for later use
    	sw $a0, 4($sp)

    	# TPS 2 #11 (Prepare new input argument, i.e. m - 2)
    	addi $a0, $a0, -2      # Update $a0 to m - 2
    	jal recursion          # Recursively call recursion(m - 2)
	
	# TPS 2 #12
    	# Save the result of the first recursive call
    	sw $v0, 8($sp)
	
	# TPS 2 #13 (Prepare new input argument, i.e. m - 1)
    	lw $a0, 4($sp)         # Restore the original value of $a0 (m)
    	addi $a0, $a0, -1      # Update $a0 to m - 1
    	jal recursion          # Recursively call recursion(m - 1)

    	# TPS 2 #14 (update returned value)
    	lw $t0, 8($sp)         # Load the result of the first recursive call
    	add $v0, $t0, $v0      # Add the two results to obtain the final value

end_recur:
    	# TPS 2 #15
    	lw $ra, 0($sp)         # Load the saved return address
    	addi $sp, $sp, 12      # Adjust the stack pointer to remove local variables
    	jr $ra                 # Return to the caller

# Terminating the program
end:
    addi $sp, $sp, 4       # Restore the stack pointer to its original state
    li $v0, 10             # Load system call code for program exit
    syscall                # Exit the program
