# [Your Game] — build + raylib bootstrap.
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
LDLIBS  += -lraylib -lGL -lm -lpthread -ldl -lrt -lX11

GAME := game

.PHONY: all run clean distclean

all: $(GAME)

# The game: rebuild when main.c or raylib's static library changes.
$(GAME): main.c $(RAYLIB_DIR)/src/libraylib.a
	$(CC) $(CFLAGS) main.c -o $@ $(LDFLAGS) $(LDLIBS)

# raylib bootstrap: clone once, build the static library once.
$(RAYLIB_DIR)/src/libraylib.a:
	git clone --depth 1 --branch $(RAYLIB_VERSION) $(RAYLIB_REPO) $(RAYLIB_DIR)
	$(MAKE) -C $(RAYLIB_DIR)/src PLATFORM=PLATFORM_DESKTOP RAYLIB_LIBTYPE=STATIC -j$(shell nproc)

run: $(GAME)
	./$(GAME)

clean:
	rm -f $(GAME)

distclean: clean
	rm -rf external
