all: static-build dynamic-build

static-build: ./src/logger.c3
	mkdir -p ./build/static
	c3c static-lib -o ./build/static/logger ./src/logger.c3 -O5 -g0

dynamic-build: ./src/logger.c3
	mkdir -p ./build/dynamic
	c3c dynamic-lib -o ./build/dynamic/logger ./src/logger.c3 -O5 -g0