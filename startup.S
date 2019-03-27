.option norvc

.section .text.start
.globl _start

_start:

    # initialize stack pointer
    la sp, _stack_top

    # call main
    call main

end:
    # stop simulation
    ebreak


.section .bss
.align 4

_stack_space:
    .space 2048

_stack_top:
