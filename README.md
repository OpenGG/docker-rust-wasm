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

## Different tags

There are three tags of this image.

| tag              | dependencies         | example wasm build size | notes                                                                                       |
|------------------|----------------------|-------------------------|---------------------------------------------------------------------------------------------|
| latest (default) | rust, llvm, binaryen | 0.4KB                   | Generating a smallest possible, zero overhead wasm file.                                    |
| emscripten       | rust, emscripten     | 156KB                   | Generating a wasm file and a companion js file, both come with emscripten syscall wrapping. |
| unknown          | rust, wasm-gc        | 150KB                   | Generating a bloat wasm file, then shrink it with wasm-gc.                                  |

If you don't known what to choose, use `emscripten` tag:

```bash
docker run -it --rm -v "$(pwd):/work" opengg/rust-wasm:emscripten add.rs
```

if you want smallest possible wasm files, use `latest` tag.

If you want to try the newly introduced `wasm32-unknown-unknown` target, use `unknown` tag:

```bash
docker run -it --rm -v "$(pwd):/work" opengg/rust-wasm:unknown add.rs
```
