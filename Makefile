# =========================
# Toolchain
# =========================
RISCV = /home/vv2trainee8/Desktop/Sourabh/review/spike/firmware/riscv64im/bin

CC      = $(RISCV)/riscv64-unknown-elf-gcc
OBJCOPY = $(RISCV)/riscv64-unknown-elf-objcopy
OBJDUMP = $(RISCV)/riscv64-unknown-elf-objdump

# =========================
# Architecture
# =========================
CFLAGS = -march=rv32ia -mabi=ilp32 -O0 -nostdlib -Iinclude

# =========================
# Folders
# =========================
SRC = programs
# =========================
# Toolchain
# =========================
RISCV = /home/vv2trainee8/Desktop/Sourabh/review/spike/firmware/riscv64im

CC      = $(RISCV)/bin/riscv64-unknown-elf-gcc
OBJCOPY = $(RISCV)/bin/riscv64-unknown-elf-objcopy
OBJDUMP = $(RISCV)/bin/riscv64-unknown-elf-objdump
SPIKE   = $(RISCV)/bin/spike

# =========================
# Architecture
# =========================
ARCH = -march=rv32ia
ABI  = -mabi=ilp32
CFLAGS = $(ARCH) $(ABI) -O0 -nostdlib -Wall

# =========================
# Directories
# =========================
SRC = programs
OUT = out

# =========================
# Programs
# =========================
PROGRAMS = lr sc amoswap amoadd amoxor amoand amoor amomin amomax amominu amomaxu

ifeq ($(TEST),)
TARGETS = $(PROGRAMS)
else
TARGETS = $(TEST)
endif

# =========================
# Default Target
# =========================
all: $(TARGETS:%=$(OUT)/%.hex) $(TARGETS:%=$(OUT)/%.objdump)

# =========================
# Compile ELF
# =========================
$(OUT)/%.elf: $(SRC)/%.c linker.ld startup/startup.S
	@mkdir -p $(OUT)
	$(CC) $(CFLAGS) -T linker.ld startup/startup.S $< -o $@

# =========================
# ELF ? BIN
# =========================
$(OUT)/%.bin: $(OUT)/%.elf
	$(OBJCOPY) -O binary $< $@

# =========================
# BIN ? HEX
# =========================
$(OUT)/%.hex: $(OUT)/%.bin
	hexdump -v -e '1/4 "%08x\n"' $< > $@

# =========================
# Disassembly
# =========================
$(OUT)/%.objdump: $(OUT)/%.elf
	$(OBJDUMP) -d $< > $@

# =========================
# Run on SPIKE
# =========================
spike: $(OUT)/$(TEST).elf
	@echo "Running on SPIKE..."
	$(SPIKE) --isa=RV32IA $(OUT)/$(TEST).elf

# =========================
# Clean
# =========================
clean:
	rm -rf $(OUT)

.PHONY: all clean spike
