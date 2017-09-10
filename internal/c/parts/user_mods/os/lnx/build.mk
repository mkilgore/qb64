
USER_MODS_SRCS := $(wildcard $(PATH_INTERNAL_C)/parts/user_mods/src/*.cpp)
USER_MODS_OBJS := $(USER_MODS_SRCS:.cpp=.o)

USER_MODS_LIB := $(PATH_INTERNAL_C)/parts/user_mods/os/lnx/src.a

$(PATH_INTERNAL_C)/parts/user_mods/src/%.o: $(PATH_INTERNAL_C)/parts/user_mods/src/%.cpp
	$(CXX) $(CXXFLAGS) -I./internal/c -I./internal/c/parts/user_mods/include $< -c -o $@

$(USER_MODS_LIB): $(USER_MODS_OBJS)
	$(AR) rcs $@ $(USER_MODS_OBJS)

QB_USER_MODS_OBJS := $(USER_MODS_LIB)

CLEAN_LIST += $(USER_MODS_OBJS) $(USER_MODS_LIB)

