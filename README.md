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
[![Platform](https://img.shields.io/badge/platform-Linux%20x86--64-orange?style=flat-square)](https://github.com/vaibhavmaurya20/GRIT-installation-v8)
[![Written In](https://img.shields.io/badge/written%20in-GRIT-00FF88?style=flat-square)](https://github.com/vaibhavmaurya20/GRIT-installation-v8)

*One language. Zero dependencies. Native speed.*

GRIT v8 is a **self-hosting compiler** written in GRIT that can compile `.gr` source into Linux x86-64 ELF64 binaries.

[Quick Start](#-60-second-quick-start) · [Installation](#-installation) · [Compiler Usage](#-compiler-usage) · [Examples](#-examples) · [Architecture](#-architecture) · [Troubleshooting](#-troubleshooting)

</div>

---

## ✨ What Makes GRIT v8 Special

| Feature | Description |
|---------|-------------|
| 🚀 **Self-hosting** | Compiler source is GRIT (`src/bootstrap.gr`) |
| ⚡ **Zero external compiler deps** | GRIT-generated binaries do not require GCC/LLVM |
| 🪶 **Tiny runtime** | Minimal syscall-only runtime embedded in output |
| 🧠 **Native output** | Emits Linux x86-64 ELF64 binaries |
| 📖 **Readable syntax** | Indentation-first, Python-like style |
| ✅ **Built-in self-test** | `--self-test` verifies lexer/parser/codegen/ELF pipeline |

---

## ⚡ 60-Second Quick Start

```bash
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8
cd GRIT-installation-v8
chmod +x bin/gritc build.sh run.sh

# Run interpreted
./run.sh examples/hello.gr

# Compile and run native binary
./build.sh examples/hello.gr -o hello && ./hello
```

Expected output includes:

```text
Hello, GRIT!
```

---

## 📦 Installation

## Platform Support

| Platform | Run Interpreted | Compile to ELF | Run Compiled Binary |
|----------|:---------------:|:--------------:|:-------------------:|
| Linux x86-64 | ✅ | ✅ | ✅ |
| macOS (Intel/Apple Silicon) | ✅ via Docker | ✅ via Docker | ✅ via Docker |
| Windows (WSL2 Ubuntu) | ✅ | ✅ | ✅ |
| Linux ARM | ❌ | ❌ | ❌ |

> `bin/gritc` and generated binaries are Linux x86-64 ELF64. Use Docker/WSL on non-Linux hosts.

### 🐧 Linux

**Recommended (repo-local use):**

```bash
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8 ~/grit
cd ~/grit
chmod +x bin/gritc build.sh run.sh
./build.sh --self-test
```

**System-wide install (optional):**

```bash
sudo cp ~/grit/bin/gritc /usr/local/bin/grit
sudo chmod +x /usr/local/bin/grit
/usr/local/bin/grit --version
```

**User-local install (no sudo):**

```bash
mkdir -p "$HOME/.local/bin"
cp ~/grit/bin/gritc "$HOME/.local/bin/grit"
chmod +x "$HOME/.local/bin/grit"

touch "$HOME/.bashrc"
(grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc")

export PATH="$HOME/.local/bin:$PATH"
grit --version
```

> If you installed only `grit` globally, compile commands that reference `src/bootstrap.gr` still require the GRIT repo path. Example:
>
> `grit run ~/grit/src/bootstrap.gr ~/grit/examples/hello.gr -o hello`

### 🍎 macOS (Docker)

1) Install and start Docker Desktop.

```bash
brew install --cask docker
open -a Docker
```

2) Clone GRIT once:

```bash
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8 "$HOME/.grit-v8"
chmod +x "$HOME/.grit-v8/bin/gritc"
```

3) Add this helper function to `~/.zshrc` (or `~/.bashrc`):

```bash
grit() {
  docker run --rm \
    -v "$HOME/.grit-v8":/grit \
    -v "$PWD":/work -w /work \
    ubuntu:22.04 \
    /grit/bin/gritc "$@"
}
```

Reload shell and test:

```bash
source ~/.zshrc

grit --version
grit run /grit/examples/hello.gr
grit run /grit/src/bootstrap.gr /grit/examples/hello.gr -o /work/hello && ./hello
```

### 🪟 Windows (WSL2)

In PowerShell (Admin):

```powershell
wsl --install -d Ubuntu
```

Then in Ubuntu:

```bash
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8 ~/grit
cd ~/grit
chmod +x bin/gritc build.sh run.sh
./build.sh --self-test
```

---

## ✅ Verify Your Installation

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
- fibonacci prints up through `55`.

---

## 🔧 Compiler Usage

### Two modes

```bash
# Interpreted mode (fast iteration)
./run.sh <program.gr>
# same as: ./bin/gritc run <program.gr>

# Native compile mode (Linux ELF64 output)
./build.sh <program.gr> -o <output>
./<output>
```

### Command reference

```text
./run.sh <source.gr>
./build.sh <source.gr> -o <output>
./build.sh --self-test
./build.sh --version
./build.sh --help
```

### Verbose compilation

```bash
./build.sh examples/fibonacci.gr -o fib -v
```

---

## 📝 Your First GRIT Program

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

- Indentation-based blocks (4 spaces)
- Comments use `#`
- Entry point is `fn main`
- Last expression is returned if not explicitly `return`

### Example syntax

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

Built-ins commonly used:
- `println(x)`, `print(x)`
- `to_string(x)`
- `len(x)`
- `push(arr, val)`, `append(a, b)`
- `read_file(path)`, `write_file(path, s)`
- `args()`

For full details, see `docs/LANGUAGE_SPEC.md`.

---

## 🎯 Examples

Run interpreted:

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

Run self-test automation:

```bash
make test
```

---

## 🏗 Architecture

### 4-pass pipeline

```text
Source (.gr)
  -> Lexer (src/lexer.gr)
  -> Parser (src/parser.gr)
  -> Native codegen (src/codegen_native.gr)
  -> ELF writer (src/elf64.gr)
  -> Linux ELF64 binary
```

### Core modules

| File | Lines | Purpose |
|------|------:|---------|
| `src/bootstrap.gr` | 3235 | Combined self-hosting compiler |
| `src/lexer.gr` | 304 | Lexer |
| `src/parser.gr` | 1064 | Parser |
| `src/codegen_native.gr` | 980 | Native code generator |
| `src/elf64.gr` | 103 | ELF64 writer |
| `src/x86_64.gr` | 252 | x86-64 instruction encoder |
| `src/runtime.gr` | 222 | Syscall runtime |
| `src/bytes.gr` | 63 | Byte utilities |
| `src/grit8.gr` | 246 | CLI driver and self-tests |

For deeper details, see `docs/ARCHITECTURE.md`.

---

## 🔴 Troubleshooting

### `Permission denied`

```bash
chmod +x bin/gritc build.sh run.sh
```

### `Exec format error` / `cannot execute binary file`

You are likely on non-Linux-x86_64. Use Docker (macOS) or WSL2 (Windows).

### Self-test fails

```bash
cd ~/grit
./bin/gritc run src/bootstrap.gr --self-test
```

### `grit: command not found`

```bash
which grit
```

If missing, use either full path (`~/grit/bin/gritc`) or re-export PATH.

---

## 📁 Repository Structure

```text
GRIT-installation-v8/
├── README.md
├── Makefile
├── build.sh
├── run.sh
├── bin/gritc
├── src/
│   ├── bootstrap.gr
│   ├── lexer.gr
│   ├── parser.gr
│   ├── codegen_native.gr
│   ├── elf64.gr
│   ├── x86_64.gr
│   ├── runtime.gr
│   ├── bytes.gr
│   └── grit8.gr
├── examples/
└── docs/
```

---

## 🤝 Contributing

```bash
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8.git
cd GRIT-installation-v8
./build.sh --self-test
```

When modifying compiler modules, rebuild bootstrap in this order:

```bash
cat src/bytes.gr src/elf64.gr src/x86_64.gr src/runtime.gr src/lexer.gr src/parser.gr src/codegen_native.gr src/grit8.gr > src/bootstrap.gr
```

---

## 📄 License

MIT License — see [LICENSE](LICENSE).

<div align="center">

**GRIT v8** · Written in GRIT · MIT Licensed · Linux x86-64

</div>
