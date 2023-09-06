# Leet Encoder

1337 is a coffee-time project I undertook during a casual break at my favourite
haunt. Its aim is to delve into the intricacies of low-level programming and
exhibit the beauty of assembly language. Written for Apple Silicon platforms
using AArch64 assembly instructions, it receives bytes from stdin, transforms
standard textual characters into their basic leetspeak representations, and then
outputs the results to stdout.

## Build and Execute

A straightforward Makefile is included to simplify the build process. Executing
`make` without a target will generate artefacts in a newly created **build**
directory. To clean up artefacts, simply run `make clean`.

## Understanding the Code

I've ensured every line in the source code is accompanied by an expressive inline
comment. Thus, if you have a foundational understanding of ARM assembly, you
should find the code eminently readable.

## Design Notes

**ARM Compliance**: The code strictly adheres to ARM's specifications and
conventions, allowing for easy portability to other platforms, albeit with some
platform-specific modifications.

**Memory Management**: The code reserves 32 bytes of the stack pointer (sp). It's
essential to note that for AArch64, the sp shall always be 16-byte aligned. The
upper 16 bytes are allocated for the Frame Pointer (FP) and Link Register (LR).
Meanwhile, an individual byte at sp + 15 is designated for read/write operations.
The decision to position this byte at this specific location is grounded in
optimising cache line utilisation. By strategically placing frequently accessed
data (like our read/write byte) near other commonly used data, there's a higher
likelihood that both will be loaded into the cache together. This approach
minimises cache misses, reducing the need to fetch data from slower memory
sources, thus enhancing the overall efficiency and performance.

**Encoding Logic**: During the encoding process, the input character's ASCII
value is decremented by 65. We then check if the result is less than 57, since
our primary focus is on ASCII characters between 'A' (65) and 'z' (122). Any
character that doesn't require encoding, whether inside this range (like the 6
non-alphabetic characters) or outside it, is left untouched, and we preserve its
original value and return it unchanged. On the other hand, for characters that do
fall within our encoding criteria, a jump table is used. If a match is found, the
corresponding encoding routine is executed.

**Jump Table Utilisation**: The use of a jump table provides a fast and efficient
mechanism for branching based on the input character's ASCII value. Compared to
methods that involve multiple conditional branches to determine whether a value
fits a certain criteria, the jump table approach is more direct and efficient.
By directly indexing into the jump table, our program sidesteps this iterative
process and immediately accesses the relevant encoding routine, resulting in a
more streamlined performance.

### Rough C Implementation of the Encoder

```c
#include <unistd.h>

static char
encode(char c)
{
    switch (c) {
        case 'A': case 'a': return '4';
        case 'B': case 'b': return '8';
        case 'E': case 'e': return '3';
        case 'G': case 'g': return '6';
        case 'L': case 'l': return '1';
        case 'O': case 'o': return '0';
        case 'S': case 's': return '5';
        case 'T': case 't': return '7';
        case 'Z': case 'z': return '2';
        default: return c;
    }
}

int
main(void)
{
    char buf;
    ssize_t nread;
    while ((nread = read(STDIN_FILENO, &buf, 1)) == 1) {
        buf = encode(buf);
        if (write(STDOUT_FILENO, &buf, 1) != 1)
            return 1;
    }

    if (nread < 0)
        return 1;

    return 0;
}
```

## Contributing

If you've spotted an error or see an opportunity for improvement (whether in the
code or documentation), please open a PR. Also, please feel free to open an issue
if you have any questions. Your contributions are always warmly welcomed!

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.
