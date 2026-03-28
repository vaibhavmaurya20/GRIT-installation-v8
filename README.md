<div align="center">

```
  ██████╗ ██████╗ ██╗████████╗
 ██╔════╝ ██╔══██╗██║╚══██╔══╝
 ██║  ███╗██████╔╝██║   ██║
 ██║   ██║██╔══██╗██║   ██║
 ╚██████╔╝██║  ██║██║   ██║
  ╚═════╝ ╚═╝  ╚═╝╚═╝   ╚═╝
```

# GRIT v8 — Self-Hosting Native Compiler

**General Runtime Intelligence Technology**

[![Version](https://img.shields.io/badge/version-v8.0.0-00FF88?style=flat-square&logo=github)](https://github.com/vaibhavmaurya20/GRIT-installation-v8)
[![Tests](https://img.shields.io/badge/tests-7%2F7%20passing-00FF88?style=flat-square)](https://github.com/vaibhavmaurya20/GRIT-installation-v8)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Linux%20x86--64-orange?style=flat-square)](https://github.com/vaibhavmaurya20/GRIT-installation-v8)
[![Written In](https://img.shields.io/badge/written%20in-GRIT-00FF88?style=flat-square)](https://github.com/vaibhavmaurya20/GRIT-installation-v8)

*One language. Zero dependencies. Native speed.*

**GRIT v8 is a self-hosting compiler** — written entirely in GRIT — that compiles `.gr` source files directly to native **x86-64 Linux ELF64 binaries**. No GCC. No LLVM. No libc. Just pure Linux syscalls.

[Quick Start](#-60-second-quick-start) · [Installation](#-installation) · [Language Guide](#-the-grit-language) · [Examples](#-examples) · [Architecture](#-architecture) · [Automation Notes](#-automation-notes)

</div>

---

## ✨ What Makes GRIT v8 Special

| Feature | Description |
|---------|-------------|
| 🚀 **Self-hosting** | The compiler is written in GRIT — 3,235 lines, compiles itself |
| ⚡ **Zero dependencies** | Compiled binaries use pure Linux syscalls, not libc |
| 🪶 **Tiny runtime** | Only 500 bytes of runtime code embedded in every binary |
| 🧠 **Native speed** | x86-64 ELF64 output with lightweight native binaries |
| 📖 **Python-like syntax** | Indentation-based, easy to read and write |
| ✅ **7/7 self-tests** | Complete test suite built into the compiler |

---

## ⚡ 60-Second Quick Start

```bash
# 1. Clone
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8
cd GRIT-installation-v8

# 2. Make scripts executable
chmod +x bin/gritc build.sh run.sh

# 3. Run hello world (interpreted — no compilation needed)
./run.sh examples/hello.gr

# 4. Compile to a native binary and run it
./build.sh examples/hello.gr -o hello && ./hello
```

**Output:** `Hello, GRIT!`

---

## 📦 Installation

### Platform Support

| Platform | Run Interpreted | Compile to ELF | Run Compiled Binary |
|----------|:--------------:|:--------------:|:-------------------:|
| Linux x86-64 | ✅ | ✅ | ✅ |
| macOS (Intel + Apple Silicon) | ✅ via Docker | ✅ via Docker | ✅ via Docker |
| Windows (WSL2) | ✅ | ✅ | ✅ |
| Linux ARM (Raspberry Pi) | ❌ | ❌ | ❌ |

> **Note:** The `gritc` bootstrap interpreter and compiled ELF binaries are **Linux x86-64 only**. macOS and Windows users should use Docker (see below).

---

### 🐧 Linux (Ubuntu / Debian / Fedora / Arch)

**Recommended — use the pre-built binary (no dependencies):**

```bash
# Clone the repository
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8
cd GRIT-installation-v8

# Make executable
chmod +x bin/gritc build.sh run.sh

# Verify it works
./build.sh --self-test
```

**Expected output:** All 7 tests PASS.

**Optional — install system-wide:**

```bash
sudo cp bin/gritc /usr/local/bin/grit
# Now usable from anywhere:
grit run examples/hello.gr
```

**No Rust/LLVM/GCC setup required:**

```bash
# GRIT v8 ships with a ready-to-run bootstrap binary in this repo.
# Just keep using the bundled toolchain:
./run.sh examples/hello.gr
./build.sh examples/hello.gr -o hello && ./hello
```

---

### 🍎 macOS (Intel & Apple Silicon)

macOS cannot run Linux ELF64 binaries natively, but you can use GRIT v8 fully via **Docker** — with a single command:

**Step 1 — Install Docker Desktop:**

```bash
# Using Homebrew (recommended):
brew install --cask docker

# Start Docker Desktop, then verify:
docker --version
```

**Step 2 — Run GRIT v8 in one command:**

```bash
# Run hello world instantly — no setup needed
docker run --rm -v "$PWD":/work -w /work \
  ubuntu:22.04 \
  bash -c "apt-get update -qq && apt-get install -y -qq git > /dev/null && \
  git clone -q https://github.com/vaibhavmaurya20/GRIT-installation-v8 /grit && \
  chmod +x /grit/bin/gritc && \
  /grit/run.sh /grit/examples/hello.gr"
```

**Step 3 — Create a reusable shell function (add to `~/.zshrc` or `~/.bashrc`):**

```bash
# Add this to your shell config:
grit() {
  docker run --rm \
    -v "$HOME/.grit-v8:/grit" \
    -v "$(pwd):/work" \
    -w /work \
    ubuntu:22.04 \
    /grit/bin/gritc "$@"
}

grit_compile() {
  docker run --rm \
    -v "$HOME/.grit-v8:/grit" \
    -v "$(pwd):/work" \
    -w /work \
    ubuntu:22.04 \
    bash -c "/grit/bin/gritc run /grit/src/bootstrap.gr $1 -o /work/$2"
}
```

**Step 4 — One-time setup:**

```bash
# Clone GRIT into your home directory (done once)
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8 ~/.grit-v8
chmod +x ~/.grit-v8/bin/gritc

# Reload shell config
source ~/.zshrc  # or source ~/.bashrc

# Test it
grit run /grit/examples/hello.gr
```

**Alternative — use the Makefile Docker target:**

```bash
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8
cd GRIT-installation-v8

# Run self-test via Docker
docker run --rm -v "$(pwd)":/grit ubuntu:22.04 \
  bash -c "chmod +x /grit/bin/gritc && /grit/bin/gritc run /grit/src/bootstrap.gr --self-test"
```

---

### 🪟 Windows (WSL2)

```powershell
# 1. Enable WSL2 (PowerShell as Administrator):
wsl --install -d Ubuntu

# 2. Open Ubuntu terminal, then follow Linux instructions above:
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8
cd GRIT-installation-v8
chmod +x bin/gritc build.sh run.sh
./build.sh --self-test
```

---

## ✅ Verify Your Installation

Run the built-in 7-test suite to confirm everything works:

```bash
./build.sh --self-test
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

## 🔧 Compiler Usage

### Two modes of operation

```bash
# MODE 1: Run interpreted (fast development, no output binary)
./run.sh myprogram.gr
# or:
./bin/gritc run myprogram.gr

# MODE 2: Compile to native ELF64 binary (for distribution/production)
./build.sh myprogram.gr -o myprogram
./myprogram
```

### Full CLI reference

```
USAGE:
  ./run.sh <source.gr>                    # Run interpreted
  ./build.sh <source.gr> -o <output>      # Compile to native binary
  ./build.sh --self-test                  # Run 7-test suite
  ./build.sh --version                    # Show version info

OPTIONS:
  -o <path>         Output binary path (default: a.out)
  -v, --verbose     Show compilation steps (lex count, parse count, byte size)
  --self-test       Run all 7 built-in tests
  --version         Show GRIT v8.0.0 version string
  --help            Show usage

EXAMPLES:
  ./run.sh examples/fibonacci.gr              # Run interpreted
  ./build.sh examples/hello.gr -o hello       # Compile
  ./build.sh examples/hello.gr -o hello -v    # Compile with verbose output
  ./hello                                     # Run the compiled binary
```

### Verbose compilation output

```bash
./build.sh examples/fibonacci.gr -o fib -v
```

```
GRIT v8: examples/fibonacci.gr → fib
  [1/4] Read 216 bytes
  [2/4] Lexed 68 tokens
  [3/4] Parsed 2 items
  ✓ 893 bytes → fib
  ✓ Done → fib
```

---

## 📝 Your First GRIT Program

**Step 1 — Create `hello.gr`:**

```grit
fn main
    println("Hello, GRIT!")
```

**Step 2 — Run it:**

```bash
./run.sh hello.gr
# Hello, GRIT!
```

**Step 3 — Compile to a native binary:**

```bash
./build.sh hello.gr -o hello
./hello
# Hello, GRIT!

# Check the binary — it's tiny and self-contained:
ls -lh hello    # → ~700 bytes
file hello      # → ELF 64-bit LSB executable, x86-64, statically linked
```

---

## 📚 The GRIT Language

### Syntax Rules

- Indentation = 4 spaces (like Python — **no tabs**)
- Comments start with `#`
- Every program needs `fn main`
- Last expression in a function is the return value

---

### Variables

```grit
fn main
    let x = 42              # immutable — cannot be changed
    let mut count = 0       # mutable — can be reassigned
    count += 1
    count = count * 2
    println(x)              # → 42
    println(count)          # → 2
```

### Types

| Type | Size | Description | Examples |
|------|------|-------------|---------|
| `int` | 64-bit | Signed integer | `42`, `-17`, `0` |
| `str` | Variable | UTF-8 text | `"hello"`, `""` |
| `bool` | 1-bit | Boolean | `true`, `false` |
| `[T]` | Variable | Array of T | `[1, 2, 3]`, `[]` |
| `[[T]]` | Variable | Nested array | `[["a", "b"]]` |

### Functions

```grit
# Basic function
fn add a:int b:int -> int
    a + b

# Inline (arrow syntax)
fn square x:int -> int => x * x

# Multiple parameters, any types
fn greet name:str times:int -> int
    let mut i = 0
    while i < times
        println("Hello, " + name + "!")
        i += 1
    times

fn main
    println(add(10, 32))       # → 42
    println(square(7))         # → 49
    greet("World", 3)          # prints 3 times
```

### Conditionals

```grit
fn classify n:int -> int
    if n > 0
        println("positive")
    else if n < 0
        println("negative")
    else
        println("zero")
    n

# Inline ternary form
fn abs_val n:int -> int
    if n < 0 then 0 - n else n

fn max a:int b:int -> int => if a > b then a else b

fn main
    classify(42)          # → positive
    classify(-7)          # → negative
    classify(0)           # → zero
    println(abs_val(-5))  # → 5
    println(max(10, 20))  # → 20
```

### Loops

```grit
fn sum_to n:int -> int
    let mut total = 0
    let mut i = 1
    while i <= n
        total += i
        i += 1
    total

fn count_down from:int -> int
    let mut n = from
    while n > 0
        println(n)
        n -= 1
    0

fn main
    println(sum_to(100))    # → 5050
    count_down(5)           # → 5 4 3 2 1
```

### Recursion

```grit
fn fib n:int -> int
    if n <= 1 then n else fib(n-1) + fib(n-2)

fn factorial n:int -> int
    if n <= 1 then 1 else n * factorial(n-1)

fn gcd a:int b:int -> int
    if b == 0 then a else gcd(b, a % b)

fn main
    println(fib(10))         # → 55
    println(factorial(10))   # → 3628800
    println(gcd(48, 18))     # → 6
```

### Structs

```grit
struct Point
    x: int
    y: int

fn distance_sq p:Point -> int
    p.x * p.x + p.y * p.y

fn translate p:Point dx:int dy:int -> Point
    Point { x: p.x + dx, y: p.y + dy }

fn main
    let p = Point { x: 3, y: 4 }
    println(distance_sq(p))      # → 25
    let p2 = translate(p, 1, 1)
    println(p2.x)                # → 4
    println(p2.y)                # → 5
```

### Operators

| Category | Operators |
|----------|-----------|
| Arithmetic | `+` `-` `*` `/` `%` |
| Comparison | `==` `!=` `<` `<=` `>` `>=` |
| Assignment | `=` `+=` `-=` `*=` `/=` `%=` |
| Logical | `&&` `\|\|` `!` |
| String | `+` (concatenation) |

### Built-in Functions

| Function | Returns | Description |
|----------|---------|-------------|
| `println(x)` | void | Print value + newline |
| `print(x)` | void | Print without newline |
| `to_string(n)` | str | Convert int/bool to string |
| `len(arr)` | int | Array or string length |
| `push(arr, x)` | `[T]` | Append element, return new array |
| `append(a, b)` | `[T]` | Concatenate two arrays |
| `read_file(path)` | Ok/Err | Read file contents |
| `write_file(path, s)` | Ok/Err | Write string to file |
| `args()` | `[str]` | Command-line arguments |

---

## 🎯 Examples

All examples live in `examples/` and can be run immediately.

### Run interpreted

```bash
./run.sh examples/hello.gr
./run.sh examples/fibonacci.gr
./run.sh examples/fizzbuzz.gr
./run.sh examples/factorial.gr
./run.sh examples/primes.gr
./run.sh examples/gcd.gr
./run.sh examples/power.gr
```

### Compile all examples at once

```bash
make examples
# Produces: bin/hello  bin/fibonacci  bin/fizzbuzz  bin/factorial  bin/primes  bin/gcd  bin/power
```

### Run a compiled binary

```bash
./build.sh examples/fibonacci.gr -o fib
./fib
# 0
# 1
# 1
# 2
# 3
# 5
# 8
# 13
# 21
# 34
# 55
```

### Write your own program

```bash
cat > my_first.gr << 'EOF'
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
    println("Primes up to 50:")
    let mut n = 2
    while n <= 50
        if is_prime(n)
            println(n)
        n += 1
EOF

./run.sh my_first.gr
# Primes up to 50:
# 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47

# Or compile it:
./build.sh my_first.gr -o primes_50
./primes_50
```

---

## 🏗 Architecture

### The 4-Pass Compilation Pipeline

```
Source (.gr file)
        │
        ▼  Pass 1: Lexer  (src/lexer.gr)
   Token stream: [(kind, value, line), ...]
        │
        ▼  Pass 2: Parser  (src/parser.gr)
   Abstract Syntax Tree: nested [str] arrays
        │
        ▼  Pass 3: Code Generator  (src/codegen_native.gr)
   x86-64 machine bytes + data section + fixup table
        │
        ▼  Pass 4: ELF Builder  (src/elf64.gr)
   Native Linux ELF64 binary
```

### Source Modules

| File | Lines | Purpose |
|------|-------|---------|
| `src/bootstrap.gr` | 3235 | Complete compiler (all modules combined) |
| `src/lexer.gr` | 310 | Tokenizer — source text → token stream |
| `src/parser.gr` | 1065 | Pratt parser — tokens → AST |
| `src/codegen_native.gr` | 982 | Code generator — AST → x86-64 bytes |
| `src/elf64.gr` | 85 | ELF64 binary writer |
| `src/x86_64.gr` | 280 | x86-64 instruction encoder |
| `src/runtime.gr` | 222 | 500-byte embedded runtime (no libc) |
| `src/bytes.gr` | 63 | Little-endian byte utilities |
| `src/grit8.gr` | 249 | Compiler driver, CLI, self-test |

### Binary Layout

```
Virtual address 0x400000
├── [0x400000] ELF header (64 bytes)
├── [0x400040] Program header (56 bytes)
├── [0x400078] Runtime (500 bytes) ← pure syscall stubs, no libc
│    offset 0:   grit_write(rdi=ptr, rsi=len)
│    offset 26:  grit_strlen(rdi=ptr) → rax
│    offset 43:  grit_itoa(rdi=n, rsi=buf) → rax
│    offset 200: grit_println_i(rdi=n)
│    offset 250: grit_println_s(rdi=ptr, rsi=len)
│    offset 320: grit_println_b(rdi=bool)
│    offset 380: grit_alloc(rdi=bytes) → rax=ptr
│    offset 430: grit_panic(rdi=ptr, rsi=len)
├── [0x400264+] User code — compiled functions + _start
└── [end]       Data section — string literals
```

### x86-64 Calling Convention (System V AMD64)

| Role | Register | Notes |
|------|----------|-------|
| 1st argument | `RDI` | |
| 2nd argument | `RSI` | |
| 3rd argument | `RDX` | |
| Return value | `RAX` | |
| Frame pointer | `RBP` | |
| Stack pointer | `RSP` | Must be 16-byte aligned at `CALL` |

---

## 🔴 Troubleshooting

### `Permission denied` when running

```bash
chmod +x bin/gritc build.sh run.sh
```

### `Exec format error`

You're on macOS or ARM Linux. The pre-built binaries are Linux x86-64 only.
→ Use [Docker (macOS)](#-macos-intel--apple-silicon) or [WSL2 (Windows)](#-windows-wsl2).

### On macOS — `cannot execute binary file`

The `gritc` binary and compiled ELF64 outputs are Linux-only.
→ Use Docker: see [macOS installation](#-macos-intel--apple-silicon).

### All 7 tests fail immediately

```bash
# Ensure the binary is executable and has correct arch:
file bin/gritc
# Expected: ELF 64-bit LSB pie executable, x86-64

# If wrong arch, build from source:
Use the bundled `bin/gritc` from this repository
```

### `Illegal instruction (SIGILL)` when running compiled binary

This can happen with array operations. The issue is the `grit_alloc` syscall.
The fix requires rebuilding `src/runtime.gr` to use `mmap` instead of `brk`.
See [Architecture](#architecture) for details or open an issue.

### Compilation is slow for large files

- Programs under ~300 lines compile in under 1 second
- Programs over 1000 lines may take longer because bootstrap compilation is compute-heavy
- Split large programs into smaller files and concatenate them

### `undefined variable` error

All variables must be declared before use:
```grit
# Wrong:
x = 42          # Error: undefined variable x

# Right:
let x = 42      # Declare first
let mut y = 0   # Declare mutable
y = 10          # Now you can assign
```

### Self-test shows `PARTIAL` for test 7

This is normal if the interpreter has a minor issue. Tests 1–6 are the critical path.

---

## 📁 Repository Structure

```
GRIT-installation-v8/
├── README.md                    ← This file
├── Makefile                     ← Build targets: test, examples, clean
├── build.sh                     ← Wrapper: compile .gr → native binary
├── run.sh                       ← Wrapper: run .gr interpreted
│
├── bin/
│   ├── gritc                    ← Bootstrap interpreter (Linux x86-64 ELF)
│   ├── hello                    ← Pre-built: Hello World binary
│   ├── fibonacci                ← Pre-built: Fibonacci binary
│   ├── fizzbuzz                 ← Pre-built: FizzBuzz binary
│   ├── factorial                ← Pre-built: Factorial binary
│   ├── primes                   ← Pre-built: Prime numbers binary
│   ├── gcd                      ← Pre-built: GCD/LCM binary
│   └── power                    ← Pre-built: Power function binary
│
├── src/                         ← GRIT v8 compiler source (all in GRIT!)
│   ├── bootstrap.gr             ← Single-file combined compiler (3235 lines)
│   ├── lexer.gr                 ← Tokenizer
│   ├── parser.gr                ← Pratt parser
│   ├── codegen_native.gr        ← x86-64 code generator
│   ├── elf64.gr                 ← ELF64 binary writer
│   ├── x86_64.gr                ← Instruction encoder
│   ├── runtime.gr               ← 500-byte syscall runtime
│   ├── bytes.gr                 ← Byte utilities
│   └── grit8.gr                 ← Compiler driver + CLI
│
├── examples/                    ← Ready-to-run GRIT programs
│   ├── hello.gr                 ← Hello World
│   ├── fibonacci.gr             ← Fibonacci sequence (recursive)
│   ├── fizzbuzz.gr              ← FizzBuzz classic
│   ├── factorial.gr             ← Factorial (iterative)
│   ├── primes.gr                ← Prime number sieve
│   ├── gcd.gr                   ← GCD and LCM
│   └── power.gr                 ← Integer power function
│
└── docs/
    ├── ARCHITECTURE.md          ← Deep-dive compiler internals
    └── LANGUAGE_SPEC.md         ← Complete language specification
```

---

## 🤖 Automation Notes

For AI agents and automation scripts, keep usage minimal and deterministic:

```bash
# Run interpreted
./run.sh <program.gr>

# Compile to native Linux ELF64
./build.sh <program.gr> -o <output>

# Validate toolchain
./build.sh --self-test
```

Recommended workflow:
1. Edit only the relevant `src/*.gr` module.
2. Rebuild `src/bootstrap.gr` when compiler modules change.
3. Run `./build.sh --self-test` (all 7 tests should pass).
4. Verify with a focused example program.

This repository already includes the bootstrap binary (`bin/gritc`), so normal usage does not require external compiler toolchains.

---

## 📊 Version Info

| Property | Value |
|----------|-------|
| Version | v8.0.0 |
| Compiler source | 3,235 lines of GRIT |
| Target | Linux x86-64 ELF64 |
| Runtime size | 500 bytes |
| Dependencies | Zero (pure Linux syscalls) |
| Self-tests | 7/7 passing |
| License | MIT |
| Repository | [vaibhavmaurya20/GRIT-installation-v8](https://github.com/vaibhavmaurya20/GRIT-installation-v8) |

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/my-feature`
3. Make your changes in `src/` (the GRIT source files)
4. Rebuild bootstrap: `cat src/bytes.gr src/elf64.gr src/x86_64.gr src/runtime.gr src/lexer.gr src/parser.gr src/codegen_native.gr src/grit8.gr > src/bootstrap.gr`
5. Verify: `./build.sh --self-test` (all 7 must pass)
6. Commit: `git commit -m 'Add: my feature'`
7. Push and open a pull request

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

```
Copyright (c) 2026 Vaibhav Maurya
GRIT v8 — General Runtime Intelligence Technology
github.com/vaibhavmaurya20/GRIT-installation-v8
```

---

<div align="center">

**GRIT v8.0.0** · Written in GRIT · MIT Licensed · Linux x86-64

[⭐ Star this repo](https://github.com/vaibhavmaurya20/GRIT-installation-v8) · [🐛 Report Issue](https://github.com/vaibhavmaurya20/GRIT-installation-v8/issues) · [📖 Docs](docs/)

</div>
