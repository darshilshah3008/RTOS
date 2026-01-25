# ===== CI Makefile for TM4C123 (Cortex-M4F) =====
# Builds with arm-none-eabi-gcc on Linux (Jenkins container)

TARGET := rtos_ci
BUILD  := build

CC  := arm-none-eabi-gcc
AS  := arm-none-eabi-gcc
LD  := arm-none-eabi-gcc
OBJCOPY := arm-none-eabi-objcopy
SIZE := arm-none-eabi-size

# Repo root is one level up from ci/
ROOT := ..

# MCU flags for TM4C123 (Cortex-M4F with FPU)
CPUFLAGS := -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard

# Common compile flags
CFLAGS := $(CPUFLAGS) -O0 -g3 -ffunction-sections -fdata-sections \
          -Wall -Wextra \
          -Wno-error \
          -Wno-unused-parameter -Wno-unused-variable -Wno-format -Wno-sign-compare \
          -Wno-builtin-declaration-mismatch -Wno-return-type


# Linker flags (uses our CI linker script)
LDFLAGS := $(CPUFLAGS) -Wl,--gc-sections -T linker.ld -Wl,-Map=$(BUILD)/$(TARGET).map

# Source files in repo root
C_SRCS := \
  $(ROOT)/rtos.c \
  $(ROOT)/uart0.c \
  $(ROOT)/wait.c \
  startup_ci.c
  asm_stubs.c
  syscalls.c

ASM_SRCS := 

INCLUDES := -I$(ROOT)
CFLAGS += -include ci/ci_compat.h


C_OBJS   := $(patsubst $(ROOT)/%.c,$(BUILD)/%.o,$(C_SRCS))
ASM_OBJS := $(patsubst $(ROOT)/%.s,$(BUILD)/%.o,$(ASM_SRCS))
OBJS := $(C_OBJS) $(ASM_OBJS)

all: $(BUILD)/$(TARGET).elf $(BUILD)/$(TARGET).bin

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/%.o: $(ROOT)/%.c | $(BUILD)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(BUILD)/%.o: $(ROOT)/%.s | $(BUILD)
	$(AS) $(CPUFLAGS) -c $< -o $@

$(BUILD)/$(TARGET).elf: $(OBJS) linker.ld | $(BUILD)
	$(LD) $(OBJS) $(LDFLAGS) -o $@
	$(SIZE) $@

$(BUILD)/$(TARGET).bin: $(BUILD)/$(TARGET).elf | $(BUILD)
	$(OBJCOPY) -O binary $< $@

clean:
	rm -rf $(BUILD)

.PHONY: all clean
