.data
prompt: .asciiz "Please enter a number: "

.text
main: 
    li $v0, 4          # Print the prompt
    la $a0, prompt
    syscall

    li $v0, 5          # Read user input
    syscall
    move $t3, $v0

    add $t0, $zero, $zero  # Initialize Fibonacci variables
    addi $t1, $zero, 1

fib: 
    beq $t3, $zero, finish # If n == 0, end loop
    add $t2, $t1, $t0
    move $t0, $t1
    move $t1, $t2
    subi $t3, $t3, 1
    j fib

finish: 
    addi $a0, $t0, 0   # Print the result
    li $v0, 1
    syscall

    li $v0, 10         # Exit
    syscall
