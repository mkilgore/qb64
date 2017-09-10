
QB_VERSION := 1.1
QB_VERSION_UNDERSCORE := $(patsubst .,_,$(QB_VERSION))

OS := lnx
# EXE := $(firstword $(MAKECMDGOALS))
ifdef BUILD_QB64
	EXE := qb64
else

ifneq ($(filter clean,$(MAKECMDGOALS)),)
	EXE := blah
endif

ifndef EXE
$(error Please provide executable name as 'EXE=executable')
endif
endif

all: $(EXE)

CP := cp

CLEAN_LIST :=

PATH_INTERNAL := ./internal
PATH_INTERNAL_C := ./internal/c

CXXFLAGS := -w -DFREEGLUT_STATIC

CXXLIBS  := -lGL -lGLU -lX11 -lpthread -ldl -lrt

QB_QBX_OBJ := $(PATH_INTERNAL_C)/qbx.o

$(QB_QBX_OBJ): $(wildcard $(PATH_INTERNAL_C)/temp/*.txt)

EXE_OBJS += $(QB_QBX_OBJ)

CLEAN_LIST += $(QB_QBX_OBJ)

include ./internal/c/libqb/os/$(OS)/build.mk
include ./internal/c/parts/audio/conversion/os/$(OS)/build.mk
include ./internal/c/parts/audio/decode/mp3_mini/os/$(OS)/build.mk
include ./internal/c/parts/audio/decode/ogg/os/$(OS)/build.mk
include ./internal/c/parts/audio/out/os/$(OS)/build.mk
include ./internal/c/parts/core/os/$(OS)/build.mk
include ./internal/c/parts/input/game_controller/os/$(OS)/build.mk
include ./internal/c/parts/user_mods/os/$(OS)/build.mk
include ./internal/c/parts/video/font/ttf/os/$(OS)/build.mk

.PHONY: all clean

QBLIB_NAME := libqb_make_

CLEAN_LIST += $(wildcard $(PATH_INTERNAL_C)/libqb/os/$(OS)/$(QBLIB_NAME)*.o)

ifdef BUILD_QB64
	_shell := $(shell $(CP) ./internal/source/* ./internal/temp/)
	DEP_FONT := y
	DEP_ICON := y
endif

ifneq ($(filter y,$(DEP_GL)),)
	CXXFLAGS += -DDEPENDENCY_GL
	QBLIB_NAME := $(addsuffix 1,$(QBLIB_NAME))
else
	QBLIB_NAME := $(addsuffix 0,$(QBLIB_NAME))
endif

ifneq ($(filter y,$(DEP_SCREENIMAGE) $(DEP_IMAGE_CODEC)),)
	CXXFLAGS += -DDEPENDENCY_IMAGE_CODEC
	QBLIB_NAME := $(addsuffix 1,$(QBLIB_NAME))
else
	QBLIB_NAME := $(addsuffix 0,$(QBLIB_NAME))
endif

ifneq ($(filter y,$(DEP_CONSOLE_ONLY)),)
	CXXFLAGS += -DDEPENDENCY_CONSOLE_ONLY
	QBLIB_NAME := $(addsuffix 1,$(QBLIB_NAME))
else
	QBLIB_NAME := $(addsuffix 0,$(QBLIB_NAME))
endif

ifneq ($(filter y,$(DEP_SOCKETS)),)
	CXXFLAGS += -DDEPENDENCY_SOCKETS
	QBLIB_NAME := $(addsuffix 1,$(QBLIB_NAME))
else
	CXXFLAGS += -DDEPENDENCY_NO_SOCKETS
	QBLIB_NAME := $(addsuffix 0,$(QBLIB_NAME))
endif

ifneq ($(filter y,$(DEP_PRINTER)),)
	CXXFLAGS += -DDEPENDENCY_PRINTER
	QBLIB_NAME := $(addsuffix 1,$(QBLIB_NAME))
else
	CXXFLAGS += -DDEPENDENCY_NO_PRINTER
	QBLIB_NAME := $(addsuffix 0,$(QBLIB_NAME))
endif

ifneq ($(filter y,$(DEP_ICON)),)
	CXXFLAGS += -DDEPENDENCY_ICON
	QBLIB_NAME := $(addsuffix 1,$(QBLIB_NAME))
else
	CXXFLAGS += -DDEPENDENCY_NO_ICON
	QBLIB_NAME := $(addsuffix 0,$(QBLIB_NAME))
endif

ifneq ($(filter y,$(DEP_SCREENIMAGE)),)
	CXXFLAGS += -DDEPENDENCY_SCREENIMAGE
	QBLIB_NAME := $(addsuffix 1,$(QBLIB_NAME))
else
	CXXFLAGS += -DDEPENDENCY_NO_SCREENIMAGE
	QBLIB_NAME := $(addsuffix 0,$(QBLIB_NAME))
endif

ifneq ($(filter y,$(DEP_FONT)),)
	EXE_OBJS += $(QB_FONT_LIB)
	CXXFLAGS += -DDEPENDENCY_LOADFONT
	QBLIB_NAME := $(addsuffix 1,$(QBLIB_NAME))
else
	QBLIB_NAME := $(addsuffix 0,$(QBLIB_NAME))
endif

ifneq ($(filter y,$(DEP_DEVICEINPUT)),)
	EXE_OBJS += $(QB_DEVICE_INPUT_LIB)
	CXXFLAGS += -DDEPENDENCY_DEVICEINPUT
	QBLIB_NAME := $(addsuffix 1,$(QBLIB_NAME))
else
	QBLIB_NAME := $(addsuffix 0,$(QBLIB_NAME))
endif

ifneq ($(filter y,$(DEP_AUDIO_CONVERSION) $(DEP_AUDIO_DECODE)),)
	EXE_OBJS += $(QB_AUDIO_CONVERSION_LIB)
	CXXFLAGS += -DDEPENDENCY_AUDIO_CONVERSION
	QBLIB_NAME := $(addsuffix 1,$(QBLIB_NAME))
else
	QBLIB_NAME := $(addsuffix 0,$(QBLIB_NAME))
endif

ifneq ($(filter y,$(DEP_AUDIO_DECODE)),)
	EXE_OBJS += $(QB_AUDIO_DECODE_MP3_LIB) $(QB_AUDIO_DECODE_OGG_LIB)
	CXXFLAGS += -DDEPENDENCY_AUDIO_DECODE
	QBLIB_NAME := $(addsuffix 1,$(QBLIB_NAME))
else
	QBLIB_NAME := $(addsuffix 0,$(QBLIB_NAME))
endif

ifneq ($(filter y,$(DEP_AUDIO_OUT) $(DEP_AUDIO_CONVERSION) $(DEP_AUDIO_DECODE)),)
	EXE_OBJS += $(QB_AUDIO_OUT_LIB)
	CXXFLAGS += -DDEPENDENCY_AUDIO_OUT
	ifeq ($(OS),mac)
		CXXLIBS += -framework AudioUnit -framework AudioToolbox
	endif
	QBLIB_NAME := $(addsuffix 1,$(QBLIB_NAME))
else
	QBLIB_NAME := $(addsuffix 0,$(QBLIB_NAME))
endif

ifneq ($(filer y,$(DEP_USER_MODS)),)
	EXE_OBJS += $(QB_USER_MODS_LIB)
	CXXFLAGS += -DDEPENDENCY_USER_MODS
	QBLIB_NAME := $(addsuffix 1,$(QBLIB_NAME))
else
	QBLIB_NAME := $(addsuffix 0,$(QBLIB_NAME))
endif

ifneq ($(OS),mac)
	EXE_OBJS += $(QB_CORE_LIB)
endif

QBLIB := $(PATH_INTERNAL_C)/libqb/os/$(OS)/$(QBLIB_NAME).o

$(QBLIB): $(PATH_INTERNAL_C)/libqb.cpp
	$(CXX) $(CXXFLAGS) $< -c -o $@

# QBLIB has to go first to ensure correct linking
EXE_OBJS := $(QBLIB) $(EXE_OBJS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $< -c -o $@

clean:
	rm -fr $(CLEAN_LIST)

$(EXE): $(EXE_OBJS)
	$(CXX) $(CXXFLAGS) $(EXE_OBJS) -o $@ $(CXXLIBS)

