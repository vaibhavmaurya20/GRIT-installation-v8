#!/bin/bash
# Run a GRIT source file directly (interpreted, no compilation)
GRITC="$(dirname "$0")/bin/gritc"
exec "$GRITC" run "$@"
