
GAMEPAD_SRCS := $(wildcard $(PATH_INTERNAL_C)/parts/input/game_controller/src/*.c)
GAMEPAD_OBJS := $(GAMEPAD_SRCS:.c=.o)

$(PATH_INTERNAL_C)/parts/input/game_controller/src/%.o: $(PATH_INTERNAL_C)/parts/input/game_controller/src/%.c
	$(CC) -Wall $< -c -o $@

QB_DEVICE_INPUT_LIB := $(PATH_INTERNAL_C)/parts/input/game_controller/os/$(OS)/src.a

$(QB_DEVICE_INPUT_LIB): $(GAMEPAD_OBJS)
	$(AR) rcs $@ $(GAMEPAD_OBJS)

