#ifndef TESTMACRO_ATOMIC_H
#define TESTMACRO_ATOMIC_H

#include "print_atomic.h"
#include <stdint.h>

/* ================= AMOADD ================= */

#define AMOADD_TEST(op1, op2, testnum) \
{ \
uint32_t mem = (op1); \
uint32_t operand = (op2); \
uint32_t rd; \
\
asm volatile( \
"amoadd.w %0,%2,(%1)" \
: "=r"(rd) \
: "r"(&mem), "r"(operand) \
: "memory" \
); \
\
PRINT_RESULT_ATOMIC(mem, operand, rd, testnum, "AMOADD"); \
}

/* ================= AMOXOR ================= */

#define AMOXOR_TEST(op1, op2, testnum) \
{ \
uint32_t mem = (op1); \
uint32_t operand = (op2); \
uint32_t rd; \
\
asm volatile( \
"amoxor.w %0,%2,(%1)" \
: "=r"(rd) \
: "r"(&mem), "r"(operand) \
: "memory" \
); \
\
PRINT_RESULT_ATOMIC(mem, operand, rd, testnum, "AMOXOR"); \
}

#endif
