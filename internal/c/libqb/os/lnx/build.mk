
QB_LIBQB_SETUP_OBJS := $(PATH_INTERNAL_C)/libqb.o

QB_LIBQB_SETUP_LIB := $(PATH_INTERNAL_C)/libqb/os/lnx/src.a

$(QB_LIBQB_SETUP_LIB): $(QB_LIBQB_SETUP_OBJS)
	$(AR) rcs $@ $(QB_LIBQB_SETUP_OBJS)

CLEAN_LIST += $(QB_LIBQB_SETUP_OBJS) $(QB_LIBQB_SETUP_LIB)

