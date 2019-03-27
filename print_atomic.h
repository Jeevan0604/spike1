#ifndef PRINT_ATOMIC_H
#define PRINT_ATOMIC_H

#include <stdio.h>

#define PRINT_RESULT_ATOMIC(mem, op, rd, testnum, instr) \
printf("RESULT %d %s MEM=%d OP=%d RD=%d\n", testnum, instr, mem, op, rd)

#endif
