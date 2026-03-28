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

[![Tests](https://img.shields.io/badge/tests-7%2F7%20passing-00FF88?style=flat-square)](https://github.com/vaibhavmaurya20/GRIT-installation-v8)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)
[![Target](https://img.shields.io/badge/target-Linux%20x86--64-orange?style=flat-square)](#platform-support)
[![Written In](https://img.shields.io/badge/written%20in-GRIT-00FF88?style=flat-square)](https://github.com/vaibhavmaurya20/GRIT-installation-v8)

*One language. Zero dependencies. Native speed.*

GRIT v8 is a self-hosting compiler (written in GRIT) that compiles `.gr` source files to native Linux x86-64 ELF64 binaries.

[Quick Start](#-60-second-quick-start) · [Installation](#-installation) · [Usage](#-compiler-usage) · [Language](#-the-grit-language) · [Examples](#-examples) · [Architecture](#-architecture) · [Troubleshooting](#-troubleshooting)

</div>

---

## Table of Contents

- [✨ What Makes GRIT v8 Special](#-what-makes-grit-v8-special)
- [⚡ 60-Second Quick Start](#-60-second-quick-start)
- [📦 Installation](#-installation)
  - [Platform Support](#platform-support)
  - [Linux](#-linux)
  - [macOS (Docker)](#-macos-docker)
  - [Windows (WSL2)](#-windows-wsl2)
- [✅ Verify Installation](#-verify-installation)
- [🔧 Compiler Usage](#-compiler-usage)
- [📝 Your First Program](#-your-first-program)
- [📚 The GRIT Language](#-the-grit-language)
- [🎯 Examples](#-examples)
- [🏗 Architecture](#-architecture)
- [🤖 AI Agent Build Notes](#-ai-agent-build-notes)
- [🔴 Troubleshooting](#-troubleshooting)
- [📁 Repository Structure](#-repository-structure)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## ✨ What Makes GRIT v8 Special

| Feature | Description |
|---------|-------------|
| 🚀 Self-hosting | Compiler source lives in `src/bootstrap.gr` (GRIT code) |
| ⚡ Native output | Emits Linux x86-64 ELF64 binaries |
| 🪶 Minimal runtime | Syscall-based runtime; no libc requirement for generated binaries |
| 🧠 Clean syntax | Indentation-first, expression-friendly language style |
| ✅ Built-in self-test | `--self-test` validates compiler pipeline end-to-end |

---

## ⚡ 60-Second Quick Start

```bash
# 1) Clone
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8
cd GRIT-installation-v8

# 2) Mark executables
chmod +x bin/gritc run.sh build.sh

# 3) Run interpreted
./run.sh examples/hello.gr

# 4) Compile and run native binary
./build.sh examples/hello.gr -o hello && ./hello
```

Expected output:

```text
Hello, GRIT!
```

---

## 📦 Installation

### Platform Support

| Platform | Interpreted | Compile to ELF | Run Compiled |
|----------|:-----------:|:--------------:|:------------:|
| Linux x86-64 | ✅ | ✅ | ✅ |
| macOS (Intel/Apple Silicon) | ✅ via Docker | ✅ via Docker | ✅ via Docker |
| Windows (WSL2 Ubuntu) | ✅ | ✅ | ✅ |
| Linux ARM | ❌ | ❌ | ❌ |

> `bin/gritc` and produced binaries are Linux x86-64. Use Docker/WSL on non-Linux hosts.

### 🐧 Linux

Recommended (repo-local workflow):

```bash
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8 ~/grit
cd ~/grit
chmod +x bin/gritc run.sh build.sh
./build.sh --self-test
```

Optional system-wide install:

```bash
sudo cp ~/grit/bin/gritc /usr/local/bin/grit
sudo chmod +x /usr/local/bin/grit
/usr/local/bin/grit --version
```

Optional user-local install (no sudo):

```bash
mkdir -p "$HOME/.local/bin"
cp ~/grit/bin/gritc "$HOME/.local/bin/grit"
chmod +x "$HOME/.local/bin/grit"
touch "$HOME/.bashrc"
(grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc")
export PATH="$HOME/.local/bin:$PATH"
grit --version
```

> Important: commands that reference `src/bootstrap.gr` still need the repository path (for example `~/grit/src/bootstrap.gr`).

### 🍎 macOS (Docker)

1) Install Docker Desktop:

```bash
brew install --cask docker
open -a Docker
```

2) Clone GRIT once:

```bash
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8 "$HOME/.grit-v8"
chmod +x "$HOME/.grit-v8/bin/gritc"
```

3) Add helper function to `~/.zshrc` or `~/.bashrc`:

```bash
grit() {
  docker run --rm \
    -v "$HOME/.grit-v8":/grit \
    -v "$PWD":/work -w /work \
    ubuntu:22.04 \
    /grit/bin/gritc "$@"
}
```

4) Reload shell and test:

```bash
source ~/.zshrc   # or: source ~/.bashrc
grit --version
grit run /grit/examples/hello.gr
grit run /grit/src/bootstrap.gr /grit/examples/hello.gr -o /work/hello && ./hello
```

### 🪟 Windows (WSL2)

In PowerShell (Administrator):

```powershell
wsl --install -d Ubuntu
```

Then in Ubuntu:

```bash
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8 ~/grit
cd ~/grit
chmod +x bin/gritc run.sh build.sh
./build.sh --self-test
```

---

## ✅ Verify Installation

```bash
cd ~/grit
./bin/gritc --version
./build.sh --self-test
./run.sh examples/hello.gr
./build.sh examples/fibonacci.gr -o fib && ./fib
```

Expected:
- version string prints,
- self-test ends with `=== Tests complete ===`,
- `examples/hello.gr` prints `Hello, GRIT!`,
- fibonacci prints through `55`.

---

## 🔧 Compiler Usage

Two primary modes:

```bash
# Interpreted mode (fast iteration)
./run.sh myprogram.gr
# equivalent:
./bin/gritc run myprogram.gr

# Native compile mode (Linux ELF64)
./build.sh myprogram.gr -o myprogram
./myprogram
```

Useful commands:

```bash
./build.sh --self-test
./build.sh --version
./build.sh --help
./build.sh examples/fibonacci.gr -o fib -v
```

---

## 📝 Your First Program

Create `hello.gr`:

```grit
fn main
    println("Hello, GRIT!")
```

Run interpreted:

```bash
./run.sh hello.gr
```

Compile and run:

```bash
./build.sh hello.gr -o hello
./hello
```

---

## 📚 The GRIT Language

Core rules:
- 4-space indentation
- line comments with `#`
- every executable program defines `fn main`
- last expression returns automatically if not using explicit `return`

Example:

```grit
fn add a:int b:int -> int
    a + b

fn fib n:int -> int
    if n <= 1 then n else fib(n-1) + fib(n-2)

fn main
    let mut i = 0
    while i <= 10
        println(fib(i))
        i += 1
```

Common built-ins:
- `println(x)`, `print(x)`
- `to_string(x)`
- `len(x)`
- `push(arr, value)`, `append(a, b)`
- `read_file(path)`, `write_file(path, content)`
- `args()`

Full syntax/reference: `docs/LANGUAGE_SPEC.md`.

---

## 🎯 Examples

Run examples interpreted:

```bash
./run.sh examples/hello.gr
./run.sh examples/fibonacci.gr
./run.sh examples/fizzbuzz.gr
./run.sh examples/factorial.gr
./run.sh examples/primes.gr
./run.sh examples/gcd.gr
./run.sh examples/power.gr
```

Compile all examples:

```bash
make examples
```

Run built-in self-test via Makefile:

```bash
make test
```

---

## 🏗 Architecture

4-pass compiler pipeline:

```text
Source (.gr)
  -> Lexer (src/lexer.gr)
  -> Parser (src/parser.gr)
  -> Native codegen (src/codegen_native.gr)
  -> ELF writer (src/elf64.gr)
  -> Linux ELF64
```

Current core modules:

| File | Lines | Role |
|------|------:|------|
| `src/bootstrap.gr` | 3235 | Combined compiler |
| `src/bytes.gr` | 63 | Byte helpers |
| `src/elf64.gr` | 103 | ELF writer |
| `src/x86_64.gr` | 252 | Instruction encoding |
| `src/runtime.gr` | 222 | Syscall runtime |
| `src/lexer.gr` | 304 | Lexer |
| `src/parser.gr` | 1064 | Parser |
| `src/codegen_native.gr` | 980 | Native codegen |
| `src/grit8.gr` | 246 | CLI driver + self-tests |

Deep dive: `docs/ARCHITECTURE.md`.

---

## 🤖 AI Agent Build Notes

When changing compiler internals (`src/*.gr`):

1. Edit module(s).
2. Rebuild bootstrap in module order:

```bash
cat src/bytes.gr src/elf64.gr src/x86_64.gr src/runtime.gr src/lexer.gr src/parser.gr src/codegen_native.gr src/grit8.gr > src/bootstrap.gr
```

3. Run validations:

```bash
./build.sh --self-test
./run.sh examples/hello.gr
./build.sh examples/fibonacci.gr -o fib && ./fib
```

---

## 🔴 Troubleshooting

### `Permission denied`

```bash
chmod +x bin/gritc run.sh build.sh
```

### `Exec format error` / `cannot execute binary file`

You're likely on non-Linux-x86_64 host. Use Docker (macOS) or WSL2 (Windows).

### Self-test fails

```bash
cd ~/grit
./bin/gritc run src/bootstrap.gr --self-test
```

### `grit: command not found`

```bash
which grit
```

If missing, use `~/grit/bin/gritc` directly or add the correct PATH export.

---

## 📁 Repository Structure

```text
GRIT-installation-v8/
├── README.md
├── Makefile
├── run.sh
├── build.sh
├── bin/gritc
├── examples/
├── src/
│   ├── bootstrap.gr
│   ├── bytes.gr
│   ├── elf64.gr
│   ├── x86_64.gr
│   ├── runtime.gr
│   ├── lexer.gr
│   ├── parser.gr
│   ├── codegen_native.gr
│   └── grit8.gr
└── docs/
    ├── LANGUAGE_SPEC.md
    └── ARCHITECTURE.md
```

---

## 🤝 Contributing

```bash
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8.git
cd GRIT-installation-v8
./build.sh --self-test
```

When modifying compiler modules, regenerate `src/bootstrap.gr` (see command above), then rerun tests.

---

## 📄 License

MIT License — see [LICENSE](LICENSE).

<div align="center">

**GRIT v8** · Written in GRIT · MIT Licensed · Linux x86-64

</div>
