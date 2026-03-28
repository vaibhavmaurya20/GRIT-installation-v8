<div align="center">

# GRIT v8

**General Runtime Intelligence Technology**

*Self-hosting compiler + interpreter for `.gr` programs.*

[![Tests](https://img.shields.io/badge/self--tests-7%2F7%20passing-brightgreen?style=flat-square)](https://github.com/vaibhavmaurya20/GRIT-installation-v8)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![Target](https://img.shields.io/badge/native%20target-Linux%20x86__64-blue?style=flat-square)](#compile-to-native-linux-binaries)
[![Platforms](https://img.shields.io/badge/host-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey?style=flat-square)](#installation)

```grit
fn fib n:int -> int
    if n <= 1 then n else fib(n-1) + fib(n-2)

fn main
    println(fib(10))   // 55
```

</div>

---

## Table of Contents

- [What is GRIT?](#what-is-grit)
- [Installation](#installation)
  - [Linux (fastest path)](#linux-fastest-path)
  - [macOS (Docker)](#macos-docker)
  - [Windows (WSL recommended)](#windows-wsl-recommended)
- [Verify Installation](#verify-installation)
- [Quick Start](#quick-start)
- [Compile to Native Linux Binaries](#compile-to-native-linux-binaries)
- [VS Code Setup](#vs-code-setup)
- [Other IDEs](#other-ides)
- [AI Agent & LLM Integration](#ai-agent--llm-integration)
- [Language Snapshot](#language-snapshot)
- [Project Layout](#project-layout)
- [Troubleshooting](#troubleshooting)

---

## What is GRIT?

GRIT v8 is a **self-hosting language toolchain**. The compiler source is written in GRIT and can compile `.gr` programs to **Linux x86-64 ELF64 binaries**.

- ✅ No LLVM/GCC dependency for GRIT-generated binaries.
- ✅ Includes interpreter workflow (`run.sh`) and compile workflow (`build.sh`).
- ✅ Built-in self-test suite (`7/7 passing` in this repo).

> **Important compatibility note:** native compiled output is currently **Linux ELF64**. On macOS/Windows, use Docker/WSL for compilation and binary execution.

---

## Installation

### Linux (fastest path)

#### Option A — one command (global `grit` in `/usr/local/bin`)

```bash
sudo curl -fsSL https://raw.githubusercontent.com/vaibhavmaurya20/GRIT-installation-v8/main/bin/gritc -o /usr/local/bin/grit && sudo chmod +x /usr/local/bin/grit && grit --version
```

#### Option B — no sudo (user-local)

```bash
mkdir -p "$HOME/.local/bin" && curl -fsSL https://raw.githubusercontent.com/vaibhavmaurya20/GRIT-installation-v8/main/bin/gritc -o "$HOME/.local/bin/grit" && chmod +x "$HOME/.local/bin/grit" && echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc" && export PATH="$HOME/.local/bin:$PATH" && grit --version
```

#### Option C — full repo clone (recommended for development)

```bash
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8.git ~/grit && cd ~/grit && chmod +x bin/gritc run.sh build.sh && sudo ln -sf ~/grit/bin/gritc /usr/local/bin/grit && grit --version
```

---

### macOS (Docker)

`bin/gritc` is a Linux ELF executable. Use Docker on macOS for a seamless setup:

```bash
brew install --cask docker && open -a Docker && mkdir -p "$HOME/grit" && git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8.git "$HOME/grit" && alias grit='docker run --rm -v "$PWD":/workspace -v "$HOME/grit":/grit ubuntu:22.04 bash -lc "/grit/bin/gritc $*"' && echo 'alias grit="docker run --rm -v "$PWD":/workspace -v "$HOME/grit":/grit ubuntu:22.04 bash -lc \"/grit/bin/gritc \$*\""' >> ~/.zshrc
```

Then open a new terminal and run:

```bash
grit --version
```

> If Docker Desktop is already installed, skip the `brew install --cask docker` step.

---

### Windows (WSL recommended)

#### Option A — WSL Ubuntu (recommended)

In **PowerShell (Admin)**:

```powershell
wsl --install -d Ubuntu
```

Then inside Ubuntu:

```bash
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8.git ~/grit && cd ~/grit && chmod +x bin/gritc run.sh build.sh && sudo ln -sf ~/grit/bin/gritc /usr/local/bin/grit && grit --version
```

#### Option B — Docker Desktop

```powershell
docker run --rm -it -v ${PWD}:/workspace ubuntu:22.04 bash -lc "apt-get update -qq && apt-get install -y git -qq && git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8.git /grit && /grit/bin/gritc --version"
```

---

## Verify Installation

Run these checks after installation:

```bash
grit --version
grit run src/bootstrap.gr --self-test
grit run examples/hello.gr
grit run src/bootstrap.gr examples/fibonacci.gr -o fib && ./fib
```

Expected outcomes:
- `--version` prints a version string.
- Self-test ends with `=== Tests complete ===` and all checks pass.
- `examples/hello.gr` prints `Hello, GRIT!`.
- Fibonacci binary prints numbers through `55`.

---

## Quick Start

Create `hello.gr`:

```grit
fn main
    println("Hello, GRIT v8!")
```

Run (interpreted):

```bash
grit run hello.gr
```

Compile (Linux):

```bash
grit run src/bootstrap.gr hello.gr -o hello
./hello
```

Using helper scripts from this repo:

```bash
./run.sh hello.gr
./build.sh hello.gr -o hello && ./hello
```

---

## Compile to Native Linux Binaries

Core command:

```bash
grit run src/bootstrap.gr <program.gr> -o <output>
```

Examples:

```bash
grit run src/bootstrap.gr examples/fizzbuzz.gr -o fizzbuzz && ./fizzbuzz
grit run src/bootstrap.gr examples/primes.gr -o primes && ./primes
grit run src/bootstrap.gr examples/factorial.gr -o factorial && ./factorial
grit run src/bootstrap.gr examples/gcd.gr -o gcd && ./gcd
```

Makefile shortcuts:

```bash
make test
make examples
```

---

## VS Code Setup

Create `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "GRIT: Run current file",
      "type": "shell",
      "command": "grit run ${file}",
      "group": "build",
      "problemMatcher": []
    },
    {
      "label": "GRIT: Compile current file (Linux)",
      "type": "shell",
      "command": "grit run src/bootstrap.gr ${file} -o ${fileDirname}/${fileBasenameNoExtension} && ${fileDirname}/${fileBasenameNoExtension}",
      "group": { "kind": "build", "isDefault": true },
      "problemMatcher": []
    },
    {
      "label": "GRIT: Self-test",
      "type": "shell",
      "command": "grit run src/bootstrap.gr --self-test",
      "group": "test",
      "problemMatcher": []
    }
  ]
}
```

Recommended `settings.json` snippet:

```json
{
  "files.associations": {
    "*.gr": "python"
  },
  "editor.tabSize": 4,
  "editor.insertSpaces": true
}
```

---

## Other IDEs

### JetBrains (IntelliJ, CLion, PyCharm)

Create a Shell Script run configuration:
- Program: `grit`
- Args (run): `run $FilePath$`
- Args (compile): `run src/bootstrap.gr $FilePath$ -o /tmp/grit_out && /tmp/grit_out`

### Neovim (example mappings)

```lua
vim.keymap.set('n', '<F5>', function()
  vim.cmd('terminal grit run ' .. vim.fn.expand('%:p'))
end)

vim.keymap.set('n', '<F6>', function()
  local f = vim.fn.expand('%:p')
  local o = vim.fn.expand('%:p:r')
  vim.cmd('terminal grit run src/bootstrap.gr ' .. f .. ' -o ' .. o .. ' && ' .. o)
end)

vim.filetype.add({ extension = { gr = 'python' } })
```

---

## AI Agent & LLM Integration

GRIT is especially easy for Python-oriented teams because its syntax is indentation-first and expression-friendly.

### Syntax & Readability (Python ↔ GRIT)

Both languages use indentation for blocks. GRIT keeps static types and lightweight function syntax.

**GRIT**
```grit
fn fib n:int -> int
    if n <= 1 then n else fib(n-1) + fib(n-2)

fn main
    let mut i = 0
    while i <= 10
        println(fib(i))
        i += 1
```

**Python equivalent**
```python
def fib(n: int) -> int:
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)

if __name__ == "__main__":
    for i in range(11):
        print(fib(i))
```

### Quick mapping for AI-generated code

| Python concept | GRIT equivalent |
|---|---|
| `def add(a: int, b: int) -> int:` | `fn add a:int b:int -> int` |
| `if cond:` / `else:` | `if cond` / `else` |
| `while cond:` | `while cond` |
| `x = 1` | `let x = 1` |
| mutable variable | `let mut x = 1` |
| `print(x)` | `println(x)` |

### Practical agent workflow

If you are using an AI coding agent, this simple loop works well:

1. Ask the agent to generate GRIT code with `fn main`.
2. Save it as `program.gr`.
3. Run quickly with interpreter mode:
   ```bash
   grit run program.gr
   ```
4. Compile on Linux when ready:
   ```bash
   grit run src/bootstrap.gr program.gr -o program && ./program
   ```

This gives fast iteration first, native output second.

---

## Language Snapshot

### Core syntax

```grit
fn add a:int b:int -> int
    a + b

fn main
    let mut i = 0
    while i < 3
        println(add(i, 10))
        i += 1
```

### Built-ins you will use often

- `println(x)` / `print(x)`
- `len(arr_or_string)`
- `to_string(x)`
- `push(arr, value)`
- `append(a, b)`
- `args()`

See `docs/LANGUAGE_SPEC.md` for fuller details.

---

## Project Layout

```text
bin/gritc             Prebuilt GRIT executable
src/bootstrap.gr      Combined compiler pipeline
src/lexer.gr          Lexer
src/parser.gr         Parser
src/codegen_native.gr Native code generator
src/runtime.gr        Minimal syscall runtime
src/elf64.gr          ELF writer
examples/*.gr         Example programs
run.sh                Interpreter helper
build.sh              Native compile helper
Makefile              test/examples automation
```

---

## Troubleshooting

### `grit: command not found`

```bash
which grit
ls -la /usr/local/bin/grit
```

If missing:

```bash
sudo ln -sf ~/grit/bin/gritc /usr/local/bin/grit
```

### `Permission denied`

```bash
chmod +x bin/gritc
chmod +x ./myprogram
```

### `Exec format error`

You are trying to run a Linux ELF binary on a non-Linux host. Use WSL/Docker (or run interpreted mode if supported in your environment).

### Self-test fails

Run from repository root and verify paths:

```bash
pwd
./bin/gritc run src/bootstrap.gr --self-test
```

---

## Contributing

```bash
git clone https://github.com/vaibhavmaurya20/GRIT-installation-v8.git
cd GRIT-installation-v8
./bin/gritc run src/bootstrap.gr --self-test
```

When editing compiler modules, rebuild `src/bootstrap.gr` by concatenating module files in the project order used by this repo.

---

<div align="center">

**GRIT v8** · MIT Licensed · Linux-native compiler target

[github.com/vaibhavmaurya20/GRIT-installation-v8](https://github.com/vaibhavmaurya20/GRIT-installation-v8)

</div>
