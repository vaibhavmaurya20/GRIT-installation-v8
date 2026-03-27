# GRIT v8 Architecture

## Overview

GRIT v8 is a self-hosting compiler: every part of the compiler is written in GRIT itself.

## Source Modules

### bytes.gr (63 lines)
Low-level byte encoding utilities.
- `b_u8(n)` → 1-byte little-endian
- `b_u16(n)` → 2-byte little-endian  
- `b_u32(n)` → 4-byte little-endian
- `b_u64(n)` → 8-byte little-endian
- `b_zeros(n)` → n zero bytes
- `b_cat(a, b)` → concatenate byte arrays
- `b_patch(code, at, val)` → patch 4 bytes at offset

### elf64.gr (85 lines)
Builds valid Linux ELF64 executables.
- `elf_header(entry_va, total_size)` → 64-byte ELF header
- `prog_header(file_size, mem_size)` → 56-byte PT_LOAD segment
- `elf_build_entry(code, data, entry_va)` → complete binary
- `elf_write_entry(path, code, data, entry_va)` → write + chmod +x

### x86_64.gr (280 lines)
x86-64 instruction encoder. Generates raw machine code bytes.
Key functions: `push_r64`, `pop_r64`, `mov_r64_r64`, `mov_r64_imm64`,
`add_r64_r64`, `sub_r64_r64`, `imul_r64_r64`, `idiv_r64`, `cmp_r64_r64`,
`je_rel32`, `jmp_rel32`, `call_rel32`, `syscall_op`, `fn_prologue`, `fn_epilogue`

### runtime.gr (222 lines)
500-byte pure-syscall runtime embedded in every binary.
No libc dependency. Uses only Linux syscall numbers.
- Offset 0:   `grit_write(rdi=ptr, rsi=len)`
- Offset 26:  `grit_strlen(rdi=ptr) → rax`
- Offset 43:  `grit_itoa(rdi=n, rsi=buf) → rax=len`
- Offset 200: `grit_println_i(rdi=n)` — print integer
- Offset 250: `grit_println_s(rdi=ptr, rsi=len)` — print string
- Offset 320: `grit_println_b(rdi=n)` — print bool
- Offset 380: `grit_alloc(rdi=bytes) → rax=ptr` — brk allocator
- Offset 430: `grit_panic(rdi=ptr, rsi=len)` — print + exit(1)

### lexer.gr (310 lines)
Converts GRIT source text into a flat token array.
Each token is `[kind, value, line]`.
Token kinds: KW, IDENT, INT, FLOAT, STR, BOOL,
NEWLINE, INDENT, DEDENT, EOF, and all operators.

Handles:
- Indentation tracking → INDENT/DEDENT tokens
- `#` line comments
- String escapes `\n`, `\t`, `\\`, `\"`
- Bracket depth tracking (suppresses NEWLINE inside `()[]{}`)

### parser.gr (1065 lines)
Pratt parser that builds a nested `[str]` AST.

Key functions:
- `parse_module(ps)` → `["MODULE", fn1, fn2, ...]`
- `parse_fn(ps)` → `["FN", name, params, body]`
- `parse_stmt(ps)` → stmt node
- `parse_expr(ps, min_bp)` → expr node
- `parse_block(ps)` → `["BLOCK", stmt1, ...]`

AST node types:
```
["FN", name, params, body]
["LET", name, type, expr]
["IF", cond, then, else]
["WHILE", cond, body]
["CALL", callee, args]
["BIN", op, lhs, rhs]
["VAR", name]
["INT", value_str]
["STR", value_str]
["BOOL", "true"|"false"]
["RETURN", expr]
["BLOCK", stmt...]
```

### codegen_native.gr (982 lines)
Walks the AST and emits x86-64 machine code.

State: `CompileCtx` struct containing:
- `code: [int]` — emitted machine code bytes
- `data: [int]` — string literal data section
- `fixups: [str]` — relocation records `[offset, label, ...]`
- `fn_table: [str]` — function name→offset map
- `locals: [str]` — local variable name list
- `frame_size: int` — current stack frame size

Calling convention: System V AMD64 ABI
- Args: RDI, RSI, RDX, RCX, R8, R9
- Return: RAX
- Stack: 16-byte aligned before CALL

Fixup labels:
- `"FN:name"` → resolve to user function VA
- `"RT:grit_*"` → resolve to runtime function VA
- `"DATA:offset"` → resolve to data section VA

### grit8.gr (249 lines)
The compiler driver — CLI parsing, self-test suite, compile pipeline.

## Bootstrap Chain

```
Stage 0: gritc (Rust interpreter)
         Interprets GRIT source files

Stage 1: gritc run src/bootstrap.gr source.gr -o binary
         • gritc interprets bootstrap.gr
         • bootstrap.gr's GRIT code lexes/parses source.gr
         • bootstrap.gr's codegen emits x86-64 machine code
         • bootstrap.gr's ELF builder writes a native binary

Stage 2 (planned): ./grit8 src/bootstrap.gr -o grit8_v2
         • The native grit8 binary compiles bootstrap.gr
         • This is true self-hosting
```

## Memory Layout

```
Virtual address 0x400000 (ELF_BASE)
│
├── 0x400000  ELF header (64 bytes)
├── 0x400040  Program header (56 bytes)
├── 0x400078  Runtime code (500 bytes, HDR_TOTAL=120)
├── 0x400264  User function code
│   ├── fn1 code
│   ├── fn2 code
│   └── _start: and rsp,-16; call main; xor rdi,rdi; mov rax,60; syscall
└── 0x4002xx  Data section (string literals, null-terminated)
```
