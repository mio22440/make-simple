
#编译使用的平台 Windows Linux
HOST_OS = Linux
BIN_NAME = main

#要编译的文件
obj-y += main.o
obj-y += func.o

#相关配置
ifeq ($(HOST_OS), Windows)
	CC  	= gcc
	LD  	= gcc
	DBG		= gdb

	RM 		= del
	MK_DIR 	= mkdir
	RM_DIR 	= rmdir /s /q

	OUT_BIN = $(BIN_NAME).exe

	CINCLUDE_FILE_FLAG = -Iinclude
else
	CC  	= gcc
	LD  	= gcc
	DBG		= gdb

	RM 		= rm
	MK_DIR 	= mkdir
	RM_DIR 	= rm -rf

	OUT_BIN = $(BIN_NAME)

	CINCLUDE_FILE_FLAG = -Iinclude
endif

CLINK_FLAGS += -g
CFLAGS		+= -g

#不需要处理的目录路径
SRC_DIR = src
OUT_DIR = output
#需要处理的目录路径
OBJ_DIR_LINUX = $(OUT_DIR)/obj
BIN_DIR_LINUX = $(OUT_DIR)/bin

#处理要编译的文件
OBJ_TARGET_LINUX = $(patsubst %,$(OBJ_DIR_LINUX)/%,$(obj-y))

ifeq ($(HOST_OS), Windows)
OBJ_DIR_WINDOWS = $(subst /,\\,$(OBJ_DIR_LINUX))
BIN_DIR_WINDOWS = $(subst /,\\,$(BIN_DIR_LINUX))
OBJ_TARGET_WINDOWS = $(subst /,\\,$(OBJ_TARGET_LINUX))
endif

all: $(OUT_BIN)

ifeq ($(HOST_OS), Windows)
$(OUT_BIN): $(BIN_DIR_WINDOWS) $(OBJ_TARGET_WINDOWS)
	$(LD) $(CLINK_FLAGS) -o $(BIN_DIR_WINDOWS)\\$@ $(OBJ_TARGET_WINDOWS)

$(BIN_DIR_WINDOWS):
	$(MK_DIR) $(OUT_DIR)
	$(MK_DIR) $(OBJ_DIR_WINDOWS)
	$(MK_DIR) $(BIN_DIR_WINDOWS)

$(OBJ_DIR_WINDOWS)\\%.o: $(SRC_DIR)\\%.c
	$(CC) $(CINCLUDE_FILE_FLAG) $(CFLAGS) -o $@ -c $<

run: $(BIN_DIR_WINDOWS)\\$(OUT_BIN)
	@$(BIN_DIR_WINDOWS)\\$(OUT_BIN)

dbg: $(BIN_DIR_WINDOWS)\\$(OUT_BIN)
	gdb $(BIN_DIR_WINDOWS)\\$(OUT_BIN)
else
$(OUT_BIN): $(BIN_DIR_LINUX) $(OBJ_TARGET_LINUX)
	$(LD) $(CLINK_FLAGS) -o $(BIN_DIR_LINUX)/$@ $(OBJ_TARGET_LINUX)

$(BIN_DIR_LINUX):
	$(MK_DIR) $(OUT_DIR)
	$(MK_DIR) $(OBJ_DIR_LINUX)
	$(MK_DIR) $(BIN_DIR_LINUX)

$(OBJ_DIR_LINUX)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CINCLUDE_FILE_FLAG) $(CFLAGS) -o $@ -c $<

run: $(BIN_DIR_LINUX)/$(OUT_BIN)
	@$(BIN_DIR_LINUX)/$(OUT_BIN)

dbg: $(BIN_DIR_LINUX)/$(OUT_BIN)
	gdb $(BIN_DIR_LINUX)/$(OUT_BIN)
endif


clean:
	$(RM_DIR) $(OUT_DIR)


