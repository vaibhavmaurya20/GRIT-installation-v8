#!/bin/bash
# GRIT v8 Build Script
# Compiles a GRIT source file to a native x86_64 ELF64 binary

GRITC="$(dirname "$0")/bin/gritc"
BOOTSTRAP="$(dirname "$0")/src/bootstrap.gr"

if [ ! -f "$GRITC" ]; then
    echo "Error: gritc not found at $GRITC"
    echo "Run: cargo build --release  to build the bootstrap interpreter"
    exit 1
fi

if [ $# -eq 0 ]; then
    echo "GRIT v8 Compiler"
    echo ""
    echo "Usage: ./build.sh <source.gr> [-o output]"
    echo ""
    echo "Examples:"
    echo "  ./build.sh examples/hello.gr"
    echo "  ./build.sh examples/fibonacci.gr -o fib"
    echo "  ./build.sh --self-test"
    exit 0
fi

exec "$GRITC" run "$BOOTSTRAP" "$@"
