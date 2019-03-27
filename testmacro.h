#ifndef ATOMIC_TESTMACRO_H
#define ATOMIC_TESTMACRO_H

#include <stdint.h>
#include <stdio.h>

#define MKSTR(s) #s

/* Atomic instruction assembly templates */

#define AMOADD_ASM  "amoadd.w %[rd], %[rs2], (%[rs1])\n\t"
#define AMOXOR_ASM  "amoxor.w %[rd], %[rs2], (%[rs1])\n\t"
#define AMOAND_ASM  "amoand.w %[rd], %[rs2], (%[rs1])\n\t"
#define AMOOR_ASM   "amoor.w  %[rd], %[rs2], (%[rs1])\n\t"
#define AMOMIN_ASM  "amomin.w %[rd], %[rs2], (%[rs1])\n\t"
#define AMOMAX_ASM  "amomax.w %[rd], %[rs2], (%[rs1])\n\t"

/* ============================================================= */
/*                PRINT MACRO                                    */
/* ============================================================= */

#define PRINT_RESULT_ATOMIC(op1, op2, a_result, e_result, test_num, instr) \
    if(a_result == e_result) \
        printf("Test/> [%3d] %s : MEM=%10d OP=%10d : E-result=%10d A-result=%10d : Status=[PASS]\n", \
                test_num, MKSTR(instr), op1, op2, e_result, a_result); \
    else \
        printf("Test/> [%3d] %s : MEM=%10d OP=%10d : E-result=%10d A-result=%10d : Status=[FAIL]\n", \
                test_num, MKSTR(instr), op1, op2, e_result, a_result);


/* ============================================================= */
/*                AMOADD TEST                                    */
/* ============================================================= */

#define AMOADD_TEST(op1, op2, testnum) \
{ \
    uint32_t mem = op1; \
    uint32_t operand = op2; \
    uint32_t result; \
    uint32_t expected = mem + operand; \
    asm volatile ( \
        AMOADD_ASM \
        : [rd] "=r"(result), [rs1] "+r"(&mem) \
        : [rs2] "r"(operand) \
        : "memory" \
    ); \
    PRINT_RESULT_ATOMIC(op1, op2, result, expected, testnum, AMOADD); \
}


/* ============================================================= */
/*                AMOXOR TEST                                    */
/* ============================================================= */

#define AMOXOR_TEST(op1, op2, testnum) \
{ \
    uint32_t mem = op1; \
    uint32_t operand = op2; \
    uint32_t result; \
    uint32_t expected = mem ^ operand; \
    asm volatile ( \
        AMOXOR_ASM \
        : [rd] "=r"(result), [rs1] "+r"(&mem) \
        : [rs2] "r"(operand) \
        : "memory" \
    ); \
    PRINT_RESULT_ATOMIC(op1, op2, result, expected, testnum, AMOXOR); \
}


/* ============================================================= */
/*                AMOAND TEST                                    */
/* ============================================================= */

#define AMOAND_TEST(op1, op2, testnum) \
{ \
    uint32_t mem = op1; \
    uint32_t operand = op2; \
    uint32_t result; \
    uint32_t expected = mem & operand; \
    asm volatile ( \
        AMOAND_ASM \
        : [rd] "=r"(result), [rs1] "+r"(&mem) \
        : [rs2] "r"(operand) \
        : "memory" \
    ); \
    PRINT_RESULT_ATOMIC(op1, op2, result, expected, testnum, AMOAND); \
}


/* ============================================================= */
/*                AMOOR TEST                                     */
/* ============================================================= */

#define AMOOR_TEST(op1, op2, testnum) \
{ \
    uint32_t mem = op1; \
    uint32_t operand = op2; \
    uint32_t result; \
    uint32_t expected = mem | operand; \
    asm volatile ( \
        AMOOR_ASM \
        : [rd] "=r"(result), [rs1] "+r"(&mem) \
        : [rs2] "r"(operand) \
        : "memory" \
    ); \
    PRINT_RESULT_ATOMIC(op1, op2, result, expected, testnum, AMOOR); \
}

#endif
