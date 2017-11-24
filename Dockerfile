FROM debian:stable

LABEL maintainer="OpenGG <liy099@gmail.com>"

# Compiling Rust to Wasm with the LLVM wasm-backend (without Emscripten)
# https://gist.github.com/LukasKalbertodt/821ab8b85a25f4c54544cc43bed2c39f

# install deps
RUN cd / \
  # apt source
  # && sed -i "s|deb.debian.org|mirrors.ustc.edu.cn|" /etc/apt/sources.list \
  # && sed -i "s|security.debian.org|mirrors.ustc.edu.cn/debian-security|" /etc/apt/sources.list \
  # deps
  && apt-get update \
  && apt-get install -y git build-essential cmake curl g++ python \
  # base dir
  && mkdir /rust-wasm-bin \
  && mkdir /rust-wasm \
  # git clone rust
  && cd /rust-wasm \
  && git clone --single-branch --depth=1 https://github.com/rust-lang/rust.git \
  && cd rust \
  # build rust
  && ./configure \
    --set llvm.experimental-targets=WebAssembly \
    --set build.target=wasm32-unknown-unknown \
    --set build.docs=false \
    --set install.prefix=/rust-wasm-bin/rust \
  && ./x.py build \
  && ./x.py install \
  # clean
  && apt-get purge -y --auto-remove git build-essential cmake curl g++ python \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /rust-wasm

# enviroment
ENV PATH /rust-wasm-bin/rust/bin:${PATH}

# working directory of container
VOLUME ["/work"]
WORKDIR /work

# entrypoint script
ENTRYPOINT [ "rust-wasm.sh" ]

ADD "rust-wasm.sh" /usr/local/bin/
