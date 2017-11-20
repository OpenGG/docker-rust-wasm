# docker-rust-wasm
Minimal docker image for rust to wasm compilation

Based on [Compiling Rust to Wasm manually with the LLVM wasm-backend (without Emscripten)](https://gist.github.com/LukasKalbertodt/821ab8b85a25f4c54544cc43bed2c39f)

## Usage

First, prepare your rust source file, e.g. `add.rs`.

```rust
#[no_mangle]
pub fn add_twenty_seven(n: i32) -> i32 {
  n + 27
}
```

Then run this docker image, compiling rust into wasm.

```bash
docker run -it --rm -v "$(pwd):/work" opengg/rust-wasm add.rs
```

## Run an interactive shell

Alternatively, you can run an interactive shell, exploring
this docker image freely.

```bash
docker run -it --rm -v "$(pwd):/work" --entrypoint bash opengg/rust-wasm
```
