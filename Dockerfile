FROM debian:stable

LABEL maintainer="OpenGG <liy099@gmail.com>"

# Compiling Rust to Wasm with `wasm32-unknown-unknown`
# https://github.com/rust-lang/rust/pull/45905

# install deps
RUN cd / \
  # apt source
  # && sed -i "s|deb.debian.org|mirrors.ustc.edu.cn|" /etc/apt/sources.list \
  # && sed -i "s|security.debian.org|mirrors.ustc.edu.cn/debian-security|" /etc/apt/sources.list \
  # deps
  && apt-get update \
  && apt-get install -y curl \
  # rustup
  && curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly \
  && cargo install --git https://github.com/alexcrichton/wasm-gc \
  # clean
  && apt-get purge -y --auto-remove curl \
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
