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
  && cd /rust-wasm-bin \
  # emsdk
  && curl https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz | tar -zxf - \
  && cd emsdk-portable \
  && ./emsdk update \
  && ./emsdk install sdk-incoming-64bit --shallow \
  && ./emsdk activate sdk-incoming-64bit \
  # clean up emsdk
  && rm -rf ./clang/*/src \
  && find . -name "*.o" -exec rm {} \; \
  && find . -name "*.a" -exec rm {} \; \
  && find . -name "*.tmp" -exec rm {} \; \
  && find . -type d -name ".git" -prune -exec rm -rf {} \; \
  # rustup
  && curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly \
  # clean
  && apt-get purge -y --auto-remove git build-essential cmake curl g++ python \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# enviroment
ENV PATH /root/.cargo/bin:${PATH}

# working directory of container
VOLUME ["/work"]
WORKDIR /work

# entrypoint script
ENTRYPOINT [ "rust-wasm.sh" ]

ADD "rust-wasm.sh" /usr/local/bin/
