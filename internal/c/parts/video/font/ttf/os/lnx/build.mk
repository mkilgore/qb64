
QB_FONT_OBJS := $(PATH_INTERNAL_C)/parts/video/font/ttf/src/freetypeamalgam.o

QB_FONT_LIB := $(PATH_INTERNAL_C)/parts/video/font/ttf/os/lnx/src.a

$(QB_FONT_LIB): $(QB_FONT_OBJS)
	$(AR) rcs $@ $(QB_FONT_OBJS)

CLEAN_LIST += $(QB_FONT_OBJS) $(QB_FONT_LIB)

