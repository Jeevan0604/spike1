ENTRY(_start)

MEMORY
{
    IMEM (rx) : ORIGIN = 0x80000000, LENGTH = 64K
    DMEM (rw) : ORIGIN = 0x80010000, LENGTH = 64K
}

SECTIONS
{

.text :
{
    KEEP(*(.text.start))
    *(.text*)
} > IMEM


.rodata :
{
    *(.rodata*)
} > IMEM


.data :
{
    *(.data*)
} > DMEM


.bss :
{
    *(.bss*)
    *(COMMON)
} > DMEM


. = ALIGN(8);
_stack_top = ORIGIN(DMEM) + LENGTH(DMEM);


/* spike communication */

.tohost :
{
    tohost = .;
    . += 8;
} > DMEM

.fromhost :
{
    fromhost = .;
    . += 8;
} > DMEM

}
