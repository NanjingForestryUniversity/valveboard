#makefile for file_ioctl
CROSS_COMPILE ?= /home/miaow/software/arm-2011.03/bin/arm-none-linux-gnueabi-
TARGET := main
BUILD_DIR := build

ifeq ("$(origin V)", "command line")
  KBUILD_VERBOSE = $(V)
endif
ifndef KBUILD_VERBOSE
  KBUILD_VERBOSE = 0
endif

ifeq ($(KBUILD_VERBOSE),1)
  quiet =
  Q =
else
  quiet=quiet_
  Q = @
endif

ifneq ($(filter 4.%,$(MAKE_VERSION)),)	# make-4
ifneq ($(filter %s ,$(firstword x$(MAKEFLAGS))),)
  quiet=silent_
endif
else					# make-3.8x
ifneq ($(filter s% -s%,$(MAKEFLAGS)),)
  quiet=silent_
endif
endif


SRC := $(wildcard *.c)
ASM_SRC := $(wildcard *.s)
OBJ := $(addprefix $(BUILD_DIR)/, $(notdir $(SRC:.c=.o)))
ASM_OBJ := $(addprefix $(BUILD_DIR)/, $(notdir $(ASM_SRC:.s=.o)))
DIS := $(addprefix $(BUILD_DIR)/, $(notdir $(SRC:.c=.dis)))
ASM_DIS := $(addprefix $(BUILD_DIR)/, $(notdir $(ASM_SRC:.s=.dis)))

_TARGET := $(BUILD_DIR)/$(TARGET)
TARGET_DIS := $(BUILD_DIR)/target.dis

LD		= $(CROSS_COMPILE)ld
CC		= $(CROSS_COMPILE)gcc
CPP		= $(CC) -E
AR		= $(CROSS_COMPILE)ar
LDR		= $(CROSS_COMPILE)ldr
STRIP		= $(CROSS_COMPILE)strip
OBJCOPY		= $(CROSS_COMPILE)objcopy
OBJDUMP		= $(CROSS_COMPILE)objdump
CFLAGS = -g -std=gnu99 -Wall -I.
LDFLAGS = -lpthread -lc -lm -marmelf_linux_eabi

.SECONDARY:

.PHONY:all
all: $(_TARGET) $(DIS) $(ASM_DIS) $(TARGET_DIS)

$(BUILD_DIR)/%.i:%.c Makefile | $(BUILD_DIR)
	$(Q)$(CC) -E $(CFLAGS) $< -o $@
$(BUILD_DIR)/%.s:$(BUILD_DIR)/%.i Makefile | $(BUILD_DIR)
	$(Q)$(CC) -S $(CFLAGS) $< -o $@
$(BUILD_DIR)/%.o:$(BUILD_DIR)/%.s Makefile | $(BUILD_DIR)
	$(Q)$(CC) -c $(CFLAGS) $< -o $@
$(BUILD_DIR)/%.o:%.s Makefile | $(BUILD_DIR)
	$(Q)$(CC) -c $(CFLAGS) $< -o $@
$(BUILD_DIR)/%.dis:$(BUILD_DIR)/%.o Makefile | $(BUILD_DIR)
	$(Q)$(OBJDUMP) -s -d $< > $@
$(TARGET_DIS):$(_TARGET) Makefile | $(BUILD_DIR)
	$(Q)$(OBJDUMP) -s -d $< > $@
$(_TARGET):$(OBJ) $(ASM_OBJ) Makefile | $(BUILD_DIR)
	$(Q)$(CC) $(OBJ) $(ASM_OBJ) $(LDFLAGS) -o $@


.PHONY:clean
clean:
	$(Q)$(RM) $(BUILD_DIR)/* -f

.PHONY:install
install:$(TARGET)
	$(Q)chmod 777 $(TARGET)

.PHONY:$(BUILD_DIR)
$(BUILD_DIR):
	$(Q)if [ ! -d $(BUILD_DIR) ]; then mkdir -p $@; fi
	
	