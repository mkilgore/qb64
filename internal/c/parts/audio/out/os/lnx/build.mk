
AUDIO_OUT_SRCS := $(wildcard $(PATH_INTERNAL_C)/parts/audio/out/src/*.c)
AUDIO_OUT_OBJS := $(AUDIO_OUT_SRCS:.c=.o)

$(PATH_INTERNAL_C)/parts/audio/out/src/%.o: $(PATH_INTERNAL_C)/parts/audio/out/%.c
	$(CC) -Wall $< -c -o $@

QB_AUDIO_OUT_LIB := $(PATH_INTERNAL_C)/parts/audio/out/os/$(OS)/src.a

$(QB_AUDIO_OUT_LIB): $(AUDIO_OUT_OBJS)
	$(AR) rcs $@ $(AUDIO_OUT_OBJS)

CLEAN_LIST += $(AUDIO_OUT_OBJS) $(QB_AUDIO_OUT_LIB)

