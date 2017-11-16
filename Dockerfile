FROM debian:stable

LABEL maintainer="OpenGG <liy099@gmail.com>"

# Compiling Rust to Wasm with the LLVM wasm-backend (without Emscripten)
# https://gist.github.com/LukasKalbertodt/821ab8b85a25f4c54544cc43bed2c39f

# source
RUN sed -i "s|deb.debian.org|mirrors.ustc.edu.cn|" /etc/apt/sources.list \
  && sed -i "s|security.debian.org|mirrors.ustc.edu.cn/debian-security|" /etc/apt/sources.list \
  # deps
  && apt-get update \
  && apt-get install -y git cmake curl g++ python \
  # base dir
  && mkdir /rust-wasm-bin \
  && mkdir /rust-wasm \
  && cd /rust-wasm \
  # llvm
  && git clone --single-branch --depth=1 https://github.com/llvm-mirror/llvm.git \
  && cd llvm \
  && mkdir build \
  && cd build \
  && cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly .. \
  && make -j8 \
  && cd .. \
  && cp -r build /rust-wasm-bin/llvm \
  # binaryen
  && cd /rust-wasm \
  && git clone --single-branch --depth=1 https://github.com/WebAssembly/binaryen.git \
  && mkdir build \
  cd build \
  && cmake .. \
  && make -j8 \
  && cd .. \
  && cp -r build /rust-wasm-bin/binaryen \
  # rustup
  && cd /rust-wasm \
  && curl https://sh.rustup.rs -sSf | sh \
  # clean
  && apt-get autoclean \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH /rust-wasm-bin/llvm/bin:/rust-wasm-bin/binaryen/bin:${PATH}

VOLUME ["/work"]
WORKDIR /work

CMD ["bash"]
