    .section    __TEXT,__text,regular,pure_instructions
    .p2align    2
encode:
    mov x8, x0                          ; Back up the input character
    sub w9, w0, #65                     ; Calculate distance from 'A'
    cmp w9, #57                         ; Check if within the range of 'A' to 'z'
    b.hi case_default                   ; Branch to case_default if character is greater than 'z'
    mov w0, #52                         ; Default to '4' for 'A' or 'a'
    adrp x10, jump_table@PAGE           ; Get the page address of jump_table
    add x10, x10, jump_table@PAGEOFF    ; Adjust to get the exact address of jump_table
    adr x11, case_b                     ; Load the address of case_b into x11
    ldrb w12, [x10, x9]                 ; Fetch offset from jump_table based on input character
    add x11, x11, x12, lsl #2           ; Calculate the final target address
    br x11                              ; Branch to the desired code block

case_b:
    mov w0, #56                         ; '8'
    ret
case_e:
    mov w0, #51                         ; '3'
    ret
case_l:
    mov w0, #49                         ; '1'
    ret
case_o:
    mov w0, #48                         ; '0'
    ret
case_g:
    mov w0, #54                         ; '6'
    ret
case_s:
    mov w0, #53                         ; '5'
    ret
case_t:
    mov w0, #55                         ; '7'
    ret
case_z:
    mov w0, #50                         ; '2'
    ret
case_default:
    mov x0, x8                          ; Restore original character
case_return:
    ret

    .section    __TEXT,__const
jump_table:
    .byte (case_return-case_b)>>2       ; char 'A'
    .byte (case_b-case_b)>>2            ; char 'B'
    .byte (case_default-case_b)>>2      ; char 'C'
    .byte (case_default-case_b)>>2      ; char 'D'
    .byte (case_e-case_b)>>2            ; char 'E'
    .byte (case_default-case_b)>>2      ; char 'F'
    .byte (case_g-case_b)>>2            ; char 'G'
    .byte (case_default-case_b)>>2      ; char 'H'
    .byte (case_default-case_b)>>2      ; char 'I'
    .byte (case_default-case_b)>>2      ; char 'J'
    .byte (case_default-case_b)>>2      ; char 'K'
    .byte (case_l-case_b)>>2            ; char 'L'
    .byte (case_default-case_b)>>2      ; char 'M'
    .byte (case_default-case_b)>>2      ; char 'N'
    .byte (case_o-case_b)>>2            ; char 'O'
    .byte (case_default-case_b)>>2      ; char 'P'
    .byte (case_default-case_b)>>2      ; char 'Q'
    .byte (case_default-case_b)>>2      ; char 'R'
    .byte (case_s-case_b)>>2            ; char 'S'
    .byte (case_t-case_b)>>2            ; char 'T'
    .byte (case_default-case_b)>>2      ; char 'U'
    .byte (case_default-case_b)>>2      ; char 'V'
    .byte (case_default-case_b)>>2      ; char 'W'
    .byte (case_default-case_b)>>2      ; char 'X'
    .byte (case_default-case_b)>>2      ; char 'Y'
    .byte (case_z-case_b)>>2            ; char 'Z'
    .byte (case_default-case_b)>>2      ; char '['
    .byte (case_default-case_b)>>2      ; char '\'
    .byte (case_default-case_b)>>2      ; char ']'
    .byte (case_default-case_b)>>2      ; char '^'
    .byte (case_default-case_b)>>2      ; char '_'
    .byte (case_default-case_b)>>2      ; char '`'
    .byte (case_return-case_b)>>2       ; char 'a'
    .byte (case_b-case_b)>>2            ; char 'b'
    .byte (case_default-case_b)>>2      ; char 'c'
    .byte (case_default-case_b)>>2      ; char 'd'
    .byte (case_e-case_b)>>2            ; char 'e'
    .byte (case_default-case_b)>>2      ; char 'f'
    .byte (case_g-case_b)>>2            ; char 'g'
    .byte (case_default-case_b)>>2      ; char 'h'
    .byte (case_default-case_b)>>2      ; char 'i'
    .byte (case_default-case_b)>>2      ; char 'j'
    .byte (case_default-case_b)>>2      ; char 'k'
    .byte (case_l-case_b)>>2            ; char 'l'
    .byte (case_default-case_b)>>2      ; char 'm'
    .byte (case_default-case_b)>>2      ; char 'n'
    .byte (case_o-case_b)>>2            ; char 'o'
    .byte (case_default-case_b)>>2      ; char 'p'
    .byte (case_default-case_b)>>2      ; char 'q'
    .byte (case_default-case_b)>>2      ; char 'r'
    .byte (case_s-case_b)>>2            ; char 's'
    .byte (case_t-case_b)>>2            ; char 't'
    .byte (case_default-case_b)>>2      ; char 'u'
    .byte (case_default-case_b)>>2      ; char 'v'
    .byte (case_default-case_b)>>2      ; char 'w'
    .byte (case_default-case_b)>>2      ; char 'x'
    .byte (case_default-case_b)>>2      ; char 'y'
    .byte (case_z-case_b)>>2            ; char 'z'

    .section    __TEXT,__text,regular,pure_instructions
    .globl      _main
    .p2align    2
_main:
    sub sp, sp, #32                     ; Allocate space on the stack
    stp x29, x30, [sp, #16]             ; Save Frame Pointer and Link Register on the stack
    add x29, sp, #32                    ; Set Frame Pointer for the current stack frame
read:
    add x1, sp, #15                     ; Address to store the byte read from stdin
    mov w0, #0                          ; File descriptor for stdin
    mov w2, #1                          ; Request to read 1 byte
    mov x16, #3                         ; Syscall number for "read"
    svc #0x80                           ; Invoke the syscall
    cmp x0, #1                          ; Check if 1 byte is read
    b.lt exit                           ; Branch to exit if the return value is 0 (EOF) or negative
write:
    ldrsb w0, [sp, #15]                 ; Load byte read from stdin for encoding
    bl encode                           ; Branch to encode
    strb w0, [sp, #15]                  ; Store the encoded byte back on the stack
    add x1, sp, #15                     ; Address of the byte to write to stdout
    mov w0, #1                          ; File descriptor for stdout
    mov w2, #1                          ; Request to write 1 byte
    mov x16, #4                         ; Syscall number for "write"
    svc #0x80                           ; Invoke the syscall
    cmp x0, #1                          ; Check if 1 byte is written
    b.eq read                           ; If successful, loop back to the read operation
exit:
    cmp x0, #0                          ; Check the return value of the last syscal
    cset x0, ne                         ; Set x0 to 1 in case of an error, otherwise set to 0
    ldp x29, x30, [sp, #16]             ; Restore frame pointer and link register
    add sp, sp, #32                     ; Deallocate stack space
    ret
