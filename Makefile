# [Your Game] — build + raylib bootstrap.
#
# Linux, macOS and Windows (MSYS2/WSL) are supported — link flags auto-detect.
#
# `make`           fetch raylib (once), build it, then build ./game
# `make run`       build and launch
# `make clean`     remove the game binary
# `make distclean` also remove the fetched raylib
#
# Upgrade raylib: change RAYLIB_VERSION (or run `make RAYLIB_VERSION=master`),
# then `make distclean && make`.

RAYLIB_VERSION ?= 6.0
RAYLIB_REPO    ?= https://github.com/raysan5/raylib.git
RAYLIB_DIR     := external/raylib

CC      ?= cc
CFLAGS  += -std=c17 -Wall -Wextra -g -I$(RAYLIB_DIR)/src
LDFLAGS += -L$(RAYLIB_DIR)/src

# The static raylib needs a different set of system libraries per OS.
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
  LDLIBS += -lraylib -framework OpenGL -framework Cocoa -framework IOKit -framework CoreAudio -framework CoreVideo
else ifneq ($(filter MINGW% MSYS%,$(UNAME_S)),)
  LDLIBS += -lraylib -lopengl32 -lgdi32 -lwinmm
else
  LDLIBS += -lraylib -lGL -lm -lpthread -ldl -lrt -lX11
endif

# MSYS2/MinGW ships no `cc`; fall back to gcc when nothing else chose a compiler.
ifeq ($(origin CC),default)
  ifeq ($(shell command -v cc 2>/dev/null),)
    CC := gcc
  endif
endif

# Parallel build jobs (nproc on Linux/WSL/MSYS2, sysctl on macOS).
JOBS := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

GAME := game

.PHONY: all run clean distclean

all: $(GAME)

# The game: rebuild when main.c or raylib's static library changes.
$(GAME): main.c $(RAYLIB_DIR)/src/libraylib.a
	$(CC) $(CFLAGS) main.c -o $@ $(LDFLAGS) $(LDLIBS)

# raylib bootstrap: clone once, build the static library once.
$(RAYLIB_DIR)/src/libraylib.a:
	git clone --depth 1 --branch $(RAYLIB_VERSION) $(RAYLIB_REPO) $(RAYLIB_DIR)
	$(MAKE) -C $(RAYLIB_DIR)/src PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=STATIC -j$(JOBS)

run: $(GAME)
	./$(GAME)

clean:
	rm -f $(GAME)

distclean: clean
	rm -rf external
