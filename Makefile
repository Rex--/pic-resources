###############################################################################
# Simple Makefile to get started with the xc8 Compiler
# Drop in your source directory, builds will go in ./builds/

###############################################################################
#    Project Configuration    #

## The name of your project
# TARGET = example
TARGET = $(lastword $(subst /, ,$(CURDIR)))# # Name target after the enclosing directory

## The device you'd like to compile for
MCU = 16LF19195

## Build directory
BUILD_DIR := build

###############################################################################
#    Compiler Setup   #

CC := xc8-cc

TARGET_ARCH := -mcpu=$(MCU)# Target Arch flag
CFLAGS := -c# Options for the xc8 compiler

###############################################################################
#    Match n' Making    #

SOURCES := $(wildcard *.c)#   # Find all .c files in current directory
OBJECTS := $(SOURCES:%=$(BUILD_DIR)/%.p1)#    # Generate list of p-code intermediate files from sources
#HEADERS := $(wildcard *.h)#     # Generate list of header files from sources

# Generate p-code files
$(BUILD_DIR)/%.c.p1: %.c
	mkdir -p $(dir $@)
	$(CC) $(TARGET_ARCH) $(CFLAGS) $< -o $@

# Generate bin files (.hex and .elf)
$(BUILD_DIR)/$(TARGET).hex: $(OBJECTS)
	$(CC) $(TARGET_ARCH) $(OBJECTS) -o $@

.PHONY: all info clean clean-all

all: $(BUILD_DIR)/$(TARGET).hex

clean:
	rm -f $(BUILD_DIR)/$(TARGET).*

clean-all:
	rm -f build/*

info:
	@echo
	@echo "Name:" $(TARGET)
	@echo "Source files:" $(SOURCES)
	@echo  "Object files:" $(OBJECTS)
	@echo "Build directory:" $(BUILD_DIR)/
	@echo "Target Arch:" $(MCU)
