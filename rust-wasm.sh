#!/bin/bash

# https://gist.github.com/LukasKalbertodt/821ab8b85a25f4c54544cc43bed2c39f

# Super simple script to compile Rust to wasm. Usage:
# ./rust-wasm.sh foo.rs

if [ -z ${1+x} ]; then
  echo "missing argument: rust source file"
  exit 1
fi

BASENAME="${1%.rs}"

INPUT="${BASENAME}.rs"

if [ ! -f "${INPUT}" ]; then
  echo "File not found: ${INPUT}"
  exit 2
fi

rustc -O --crate-type=lib --emit=llvm-bc "${INPUT}" && \
  llc -march=wasm32 "${BASENAME}.bc" && \
  s2wasm -o "${BASENAME}.wast" "${BASENAME}.s" && \
  wasm-as "${BASENAME}.wast"
