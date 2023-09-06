SRC = 1337.s
OBJ = build/1337.o

all: build/1337

build/1337: build/1337.o
	ld $< -o $@ -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path`

build/1337.o: 1337.s
	@mkdir -p build
	as $< -o $@

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
