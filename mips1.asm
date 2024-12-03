.data
x: .word 2
y: .word 4
z: .word 6

stringfoo: .asciiz "p + q: "
newline: .asciiz "\n"

.text
main:
    # Load x, y, z into $s0, $s1, $s2
    la $t0, x
    lw $s0, 0($t0)        # x ? $s0
    la $t1, y
    lw $s1, 0($t1)        # y ? $s1
    la $t2, z
    lw $s2, 0($t2)        # z ? $s2

    # Pass x, y, z to foo
    move $a0, $s0         # x ? $a0
    move $a1, $s1         # y ? $a1
    move $a2, $s2         # z ? $a2
    jal foo               # Call foo()

    # Print "p + q: "
    la $a0, stringfoo     # Load address of string
    li $v0, 4             # Syscall to print string
    syscall               # Print "p + q: "

    # Print result (p + q)
    move $a0, $v0         # Result from foo ? $a0
    li $v0, 1             # Syscall to print integer
    syscall               # Print the integer result

    # Print newline
    la $a0, newline       # Load address of newline string
    li $v0, 4             # Syscall to print string
    syscall               # Print the newline

    # Exit program
    li $v0, 10
    syscall

foo:
    # Save registers on the stack
    addi $sp, $sp, -24    # Allocate 24 bytes
    sw $a0, 0($sp)        # Save $a0
    sw $a1, 4($sp)        # Save $a1
    sw $a2, 8($sp)        # Save $a2
    sw $s0, 12($sp)       # Save $s0
    sw $s1, 16($sp)       # Save $s1
    sw $ra, 20($sp)       # Save $ra

    # First BAR call: p = bar(x + z, y + z, x + y)
    addu $t0, $a0, $a2    # x + z
    addu $t1, $a1, $a2    # y + z
    addu $t2, $a0, $a1    # x + y
    move $a0, $t0         # m ? $a0
    move $a1, $t1         # n ? $a1
    move $a2, $t2         # o ? $a2
    jal bar               # Call bar()
    move $s0, $v0         # Save result of p in $s0

    # Second BAR call: q = bar(x - z, y - x, y + y)
    lw $a0, 0($sp)        # Restore x ? $a0
    lw $a1, 4($sp)        # Restore y ? $a1
    lw $a2, 8($sp)        # Restore z ? $a2
    subu $t0, $a0, $a2    # x - z
    subu $t1, $a1, $a0    # y - x
    addu $t2, $a1, $a1    # y + y
    move $a0, $t0         # m ? $a0
    move $a1, $t1         # n ? $a1
    move $a2, $t2         # o ? $a2
    jal bar               # Call bar()
    move $s1, $v0         # Save result of q in $s1

    # Calculate p + q
    addu $v0, $s0, $s1    # p + q ? $v0

    # Restore registers from the stack
    lw $ra, 20($sp)       # Restore $ra
    lw $s1, 16($sp)       # Restore $s1
    lw $s0, 12($sp)       # Restore $s0
    addi $sp, $sp, 24     # Deallocate stack space
    jr $ra                # Return to main

bar:
    # Perform bar(a, b, c): (b - a) << c
    subu $t0, $a1, $a0    # b - a
    sllv $t0, $t0, $a2    # (b - a) << c
    move $v0, $t0         # Store result in $v0
    jr $ra                # Return to caller

