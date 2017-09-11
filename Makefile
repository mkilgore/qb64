
QB_VERSION := 1.1
QB_VERSION_UNDERSCORE := $(patsubst .,_,$(QB_VERSION))

PATH_INTERNAL := ./internal
PATH_INTERNAL_C := $(PATH_INTERNAL)/c

ifndef OS
	OS := lnx
endif

ifeq ($(OS),lnx)
	CP := cp
	RM := rm -fr
endif

ifeq ($(OS),win)
	CP := copy
	AR := $(PATH_INTERNAL_C)/c_compiler/bin/ar.exe
	CC := $(PATH_INTERNAL_C)/c_compiler/bin/gcc.exe
	CXX := $(PATH_INTERNAL_C)/c_compiler/bin/c++.exe
	RM := del
endif

ifdef BUILD_QB64
	EXE := qb64
else

ifneq ($(filter clean,$(MAKECMDGOALS)),)
	# We have to define this for the Makefile to work,
	# but it doesn't actually matter what it is since we won't actually compile anything
	EXE := blah
endif

ifndef EXE
$(error Please provide executable name as 'EXE=executable')
endif
endif

all: $(EXE)

CLEAN_LIST :=

CXXFLAGS := -w

ifeq ($(OS),lnx)
	CXXLIBS := -lGL -lGLU -lX11 -lpthread -ldl -lrt
	CXXFLAGS += -DFREEGLUT_STATIC
endif

ifeq ($(OS),win)
	CXXLIBS := -static-libgcc -static-libstdc++
	CXXFLAGS += -DGLEW_STATIC -DFREEGLUT_STATIC
endif

ifeq ($(OS),osx)
	CXXLIBS := -framework OpenGL -framework IOKit -framework GLUT -framework Cocoa
endif

QB_QBX_OBJ := $(PATH_INTERNAL_C)/qbx.o

$(QB_QBX_OBJ): $(wildcard $(PATH_INTERNAL_C)/temp/*.txt)

EXE_OBJS += $(QB_QBX_OBJ)

CLEAN_LIST += $(QB_QBX_OBJ)

include $(PATH_INTERNAL_C)/libqb/os/lnx/build.mk
include $(PATH_INTERNAL_C)/parts/audio/conversion/os/lnx/build.mk
include $(PATH_INTERNAL_C)/parts/audio/decode/mp3_mini/os/lnx/build.mk
include $(PATH_INTERNAL_C)/parts/audio/decode/ogg/os/lnx/build.mk
include $(PATH_INTERNAL_C)/parts/audio/out/os/lnx/build.mk
include $(PATH_INTERNAL_C)/parts/core/os/lnx/build.mk
include $(PATH_INTERNAL_C)/parts/input/game_controller/os/lnx/build.mk
include $(PATH_INTERNAL_C)/parts/user_mods/os/lnx/build.mk
include $(PATH_INTERNAL_C)/parts/video/font/ttf/os/lnx/build.mk

.PHONY: all clean

QBLIB_NAME := libqb_make_$(QB_VERSION_UNDERSCORE)_

CLEAN_LIST += $(wildcard $(PATH_INTERNAL_C)/libqb/os/$(OS)/$(QBLIB_NAME)*.o)

ifdef BUILD_QB64
	# _shell := $(shell $(CP) ./internal/source/* ./internal/temp/)
	DEP_FONT := y
	DEP_ICON := y
	DEP_SOCKETS := y
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

ifeq ($(OS),win)
	ifneq ($(filter y,$(DEP_CONSOLE_ONLY)),)
		CXXLIBS += -mconsole
		CXXFLAGS := $(filter-out -DFREEGLUT_STATIC,$(CXXFLAGS))
		EXE_OBJS := $(filter-out $(QB_CORE_LIB),$(EXE_OBJS))
	else
		CXXLIBS += -mwindows -lopengl32 -lglu32
		CXXFLAGS += -DFREEGLUT_STATIC -DGLEW_STATIC

		CXXLIBS += -lwinmm
	endif

	ifneq ($(filter y,$(DEP_SOCKETS)),)
		CXXLIBS += -lws2_32
	endif

	ifneq ($(filter y,$(DEP_PRINTER)),)
		CXXLIBS += -lwinspool
	endif

	ifneq ($(filter y,$(DEP_AUDIO_OUT)),)
		CXXLIBS += -lwinmm -lksguid -ldxguid -lole32
	endif

	ifneq ($(filter y,$(DEP_ICON)),)
		CXXLIBS += -lgdi32
	endif
endif

QBLIB := $(PATH_INTERNAL_C)/libqb/os/lnx/$(QBLIB_NAME).o

ifneq ($(OS),osx)
$(QBLIB): $(PATH_INTERNAL_C)/libqb.cpp
	$(CXX) $(CXXFLAGS) $< -c -o $@
else
$(QBLIB): $(PATH_INTERNAL_C)/libqb.mm
	$(CXX) $(CXXFLAGS) $< -c -o $@
endif

# QBLIB has to go first to ensure correct linking
EXE_OBJS := $(QBLIB) $(EXE_OBJS)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $< -c -o $@

clean:
	$(RM) $(CLEAN_LIST)

$(EXE): $(EXE_OBJS)
	$(CXX) $(CXXFLAGS) $(EXE_OBJS) -o $@ $(CXXLIBS)

