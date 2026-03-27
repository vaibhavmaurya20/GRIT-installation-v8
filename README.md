# GRIT v8 — Self-Hosting Native Compiler

**General Runtime Intelligence Technology**
*One language. Zero dependencies. Native speed.*

GRIT v8 is a **self-hosting compiler** written entirely in GRIT that compiles GRIT source code directly to native **x86_64 Linux ELF64 binaries** — no GCC, no LLVM, no C runtime, no libc. Just pure Linux syscalls.

---

## What's Included

```
grit-v8/
├── README.md               ← This file
├── src/                    ← GRIT v8 compiler source (all in GRIT)
│   ├── bootstrap.gr        ← Complete combined single-file compiler (3235 lines)
│   ├── bytes.gr            ← Byte manipulation utilities (little-endian encoding)
│   ├── elf64.gr            ← ELF64 binary writer
│   ├── x86_64.gr           ← x86_64 instruction encoder
│   ├── runtime.gr          ← Linux syscall runtime (no libc)
│   ├── lexer.gr            ← GRIT tokenizer
│   ├── parser.gr           ← Pratt parser → AST
│   ├── codegen_native.gr   ← AST → native x86_64 machine code
│   └── grit8.gr            ← Compiler driver (main, self-test, CLI)
├── examples/               ← Ready-to-compile GRIT programs
│   ├── hello.gr
│   ├── fibonacci.gr
│   ├── fizzbuzz.gr
│   ├── factorial.gr
│   ├── primes.gr
│   ├── gcd.gr
│   └── power.gr
└── bin/
    ├── gritc               ← Bootstrap interpreter (runs .gr files)
    └── fibonacci_demo      ← Pre-built native demo binary
```

---

## Quick Start

### Run a GRIT program immediately (no compilation step):
```bash
./bin/gritc run examples/hello.gr
./bin/gritc run examples/fibonacci.gr
```

### Compile to a native binary:
```bash
./bin/gritc run src/bootstrap.gr examples/hello.gr -o hello
./hello
# → Hello, GRIT!
```

### Compile fibonacci to native binary:
```bash
./bin/gritc run src/bootstrap.gr examples/fibonacci.gr -o fib
./fib
# → 0 1 1 2 3 5 8 13 21 34 55
```

---

## Installation

### Prerequisites
- Linux x86_64 (Ubuntu 20.04+, Debian 11+, or similar)
- No other dependencies required

### Option 1: Use the included bootstrap interpreter
The `bin/gritc` binary is the GRIT v7 bootstrap interpreter.
It can both run `.gr` files directly and compile them via the v8 compiler:

```bash
# Make executable
chmod +x bin/gritc

# Run any .gr file:
./bin/gritc run examples/fibonacci.gr

# Compile to native binary:
./bin/gritc run src/bootstrap.gr <source.gr> -o <output>
```

### Option 2: Build from source (requires Rust)
```bash
# Clone and build the interpreter
git clone <repo>
cd grit
cargo build --release
./target/release/grit run src/bootstrap.gr examples/hello.gr -o hello
```

### System-wide install
```bash
sudo cp bin/gritc /usr/local/bin/grit
# Now use:
grit run examples/hello.gr
grit run src/bootstrap.gr myprogram.gr -o myprogram
```

---

## The GRIT Language

GRIT uses **indentation-based syntax** (like Python) with static types and functional features.

### Hello World
```grit
fn main
    println("Hello, GRIT!")
```

### Functions
```grit
fn add a:int b:int -> int
    a + b

fn greet name:str -> str
    "Hello, " + name + "!"

fn main
    println(add(3, 4))      // → 7
    println(greet("World")) // → Hello, World!
```

### Variables
```grit
fn main
    let x = 42              // immutable
    let mut count = 0       // mutable
    count += 1
    println(x)              // → 42
    println(count)          // → 1
```

### Conditionals
```grit
fn classify n:int -> int
    if n < 0
        println("negative")
    else if n == 0
        println("zero")
    else
        println("positive")
    n

// Inline form:
fn max a:int b:int -> int
    if a > b then a else b
```

### Loops
```grit
fn main
    let mut i = 0
    while i < 5
        println(i)
        i += 1

fn sum_to n:int -> int
    let mut s = 0
    let mut i = 1
    while i <= n
        s += i
        i += 1
    s
```

### Recursion
```grit
fn fib n:int -> int
    if n <= 1 then n else fib(n-1) + fib(n-2)

fn factorial n:int -> int
    if n <= 1 then 1 else n * factorial(n-1)
```

### Multiple functions
```grit
fn is_prime n:int -> int
    if n < 2
        return 0
    let mut i = 2
    while i * i <= n
        if n % i == 0
            return 0
        i += 1
    1

fn main
    if is_prime(97)
        println("97 is prime")
```

### Boolean expressions
```grit
fn main
    println(true)           // → true
    println(false)          // → false
    println(3 > 2)          // → true
    println(5 == 5)         // → true
    println(4 != 3)         // → true
    println(10 <= 10)       // → true
```

---

## Language Reference

### Types
| Type | Description | Example |
|------|-------------|---------|
| `int` | 64-bit signed integer | `42`, `-17`, `0` |
| `str` | UTF-8 string | `"hello"` |
| `bool` | Boolean | `true`, `false` |
| `[T]` | Array of T | `[1, 2, 3]` |
| `[[T]]` | Nested array | `[["a","b"], ["c"]]` |

### Operators
| Category | Operators |
|----------|-----------|
| Arithmetic | `+`, `-`, `*`, `/`, `%` |
| Comparison | `==`, `!=`, `<`, `<=`, `>`, `>=` |
| Assignment | `=`, `+=`, `-=`, `*=`, `/=`, `%=` |
| Boolean | `&&`, `\|\|`, `!` |

### Built-in Functions
| Function | Description |
|----------|-------------|
| `println(x)` | Print value + newline |
| `print(x)` | Print without newline |
| `to_string(x)` | Convert to string |
| `len(arr)` | Array length |
| `push(arr, x)` | Append to array |
| `append(a, b)` | Concatenate arrays |
| `read_file(path)` | Read file → Ok(str)/Err(str) |
| `write_file(path, s)` | Write string to file |
| `args()` | Command-line args as [str] |

---

## Compiler Usage

```
USAGE:
  gritc run src/bootstrap.gr <source.gr> [options]

OPTIONS:
  -o <output>        Output binary path (default: a.out)
  -v, --verbose      Show compilation steps
  --version          Show GRIT version
  --help             Show help
  --self-test        Run built-in test suite

EXAMPLES:
  # Compile and run
  gritc run src/bootstrap.gr hello.gr -o hello && ./hello

  # Compile with verbose output
  gritc run src/bootstrap.gr fibonacci.gr -o fib -v

  # Run self-test suite (7 tests)
  gritc run src/bootstrap.gr --self-test
```

---

## Architecture

GRIT v8 compiles in 4 passes:

```
Source (.gr)
    │
    ▼ [1] Lexer (lexer.gr)
Tokens
    │
    ▼ [2] Parser (parser.gr)  
AST (nested [str] arrays)
    │
    ▼ [3] Code Generator (codegen_native.gr)
x86_64 machine code + data section + fixup table
    │
    ▼ [4] ELF Builder (elf64.gr)
Native ELF64 binary (runnable on Linux x86_64)
```

### ELF64 Layout
```
[ELF header: 64 bytes]
[Program header: 56 bytes]
[Runtime: 500 bytes]     ← pure syscall routines, no libc
[User code: variable]    ← compiled user functions + _start
[Data section: variable] ← string literals
```

### Runtime Functions (offset from runtime start)
| Offset | Function | Description |
|--------|----------|-------------|
| 0 | grit_write | sys_write wrapper |
| 26 | grit_strlen | string length |
| 43 | grit_itoa | integer → ASCII |
| 200 | grit_println_i | print integer + newline |
| 250 | grit_println_s | print string + newline |
| 320 | grit_println_b | print bool + newline |
| 380 | grit_alloc | heap allocator (brk syscall) |
| 430 | grit_panic | print error + exit(1) |

---

## Self-Test

Run the built-in test suite to verify everything works:

```bash
./bin/gritc run src/bootstrap.gr --self-test
```

Expected output:
```
=== GRIT v8 Self-Test Suite ===

[ 1 ] Lexer
      PASS — 18 tokens
[ 2 ] Parser
      PASS — AST root = MODULE, 1 items
[ 3 ] Byte utils
      PASS — little-endian correct
[ 4 ] x86_64 encoder
      PASS — RET = 0xC3
      PASS — PUSH RAX = 0x50
[ 5 ] ELF64 header builder
      PASS — ELF magic correct
[ 6 ] Compile hello world → ELF
  ✓ 711 bytes → /tmp/hello_v8_test
      PASS — binary runs! Output: Hello from GRIT v8!
[ 7 ] Compile fibonacci → ELF
  ✓ 893 bytes → /tmp/fib_v8
      PASS — fib(0)=0, fib(10)=55

=== Tests complete ===
```

---

## Building Your First Program

1. Create `myprogram.gr`:
```grit
fn greet name:str -> int
    println("Hello, " + name + "!")
    0

fn main
    greet("World")
    greet("GRIT")
    let result = 1 + 2 + 3 + 4 + 5
    println(result)
```

2. Compile to native binary:
```bash
./bin/gritc run src/bootstrap.gr myprogram.gr -o myprogram
```

3. Run it:
```bash
./myprogram
# Hello, World!
# Hello, GRIT!
# 15
```

---

## Version Info

- **GRIT v8.0.0** — Complete Self-Hosting Compiler
- **Target**: Linux x86_64 ELF64
- **Runtime**: 500 bytes of pure syscall stubs (no libc)
- **Bootstrap**: Written entirely in GRIT
- **License**: MIT

---

## Troubleshooting

**"Permission denied" when running binary**
```bash
chmod +x ./myprogram
```

**"Exec format error"**
- Ensure you're on Linux x86_64
- The binary is 64-bit ELF — won't run on 32-bit or ARM

**Segmentation fault**
- Check that your recursive functions have proper base cases
- Deeply nested recursion may exhaust the stack

**Compilation is slow for large files**
- The bootstrap compiler runs through the v7 interpreter which is interpreted
- Programs under ~500 lines compile in under 1 second
- For larger programs, split into multiple source files

**"undefined variable" errors**
- All variables must be declared with `let` before use
- Mutable variables need `let mut`
