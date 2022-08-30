###############################################################################
# Simple Makefile to get started with the xc8 Compiler
# Drop in your source directory, builds will go in ./builds/

###############################################################################
#    Project Configuration    #

## The name of your project
# Name target after the enclosing directory
TARGET := $(lastword $(subst /, ,$(CURDIR)))
# TARGET := example
# Static name

## The device you'd like to compile for
MCU := 16LF19196

## Build directory
BUILD_DIR := build

## Optional include directories (separated by a space).
# The directory of the Makefile is included automatically.
INC_DIR :=

###############################################################################
#    Compiler Setup   #

CC := xc8-cc

TARGET_ARCH := -mcpu=$(MCU)#			# Target Arch flag
CFLAGS := -O2 $(addprefix -I,$(INC_DIR))#	# Options for the xc8 compiler
LFLAGS := -Wl,-Map=${BUILD_DIR}/${TARGET}.map

###############################################################################
#    Match n' Making    #

SOURCES := $(wildcard *.c)#   				# Find all .c files in current directory
ASOURCES := $(wildcard *.S)#				# Find all .S files 
OBJECTS := $(SOURCES:%=$(BUILD_DIR)/%.p1)#	# Generate list of p-code files from C sources
AOBJECTS := $(ASOURCES:%=$(BUILD_DIR)/%.o)#	# Generate list of assembly object files
DEPENDS := $(OBJECTS:%.p1=%.d)				# Generate list of depends files from objects (pcode)

# Generate p-code object files from C source files
$(BUILD_DIR)/%.c.p1: %.c Makefile
	@mkdir -p $(dir $@)
	$(CC) $(TARGET_ARCH) $(CFLAGS) -c $< -o $@

# Generate p-code object files from assembly source files
$(BUILD_DIR)/%.S.o: %.S Makefile
	@mkdir -p $(dir $@)
	$(CC) $(TARGET_ARCH) $(CFLAGS) -c $< -o $@

# Generate bin files (.hex and .elf)
$(BUILD_DIR)/$(TARGET).hex: $(OBJECTS) $(AOBJECTS) Makefile
	$(CC) $(TARGET_ARCH) $(CFLAGS) ${LFLAGS} $(OBJECTS) $(AOBJECTS) -o $@

.PHONY: all info clean fclean

all: $(BUILD_DIR)/$(TARGET).hex

clean:
	rm -f $(OBJECTS)
	rm -f $(AOBJECTS)
	rm -f $(DEPENDS)
	rm -f $(BUILD_DIR)/$(TARGET).*

fclean:
	rm -f build/*

info:
	@echo
	@echo "Name:" $(TARGET)
	@echo "Source files:" $(SOURCES)
	@echo "Assembly files:" $(ASOURCES)
	@echo "Object files:" $(OBJECTS) $(AOBJECTS)
	@echo "Build directory:" $(BUILD_DIR)/
	@echo "Target Arch:" $(MCU)

# Include dependency files
-include $(DEPENDS)
