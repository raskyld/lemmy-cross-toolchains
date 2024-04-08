# syntax=docker/dockerfile:1.6

ARG BASE_IMAGE=debian:bookworm

FROM --platform=amd64 ${BASE_IMAGE} AS buildroot

LABEL org.opencontainers.image.authors="Enzo Nocera <enzo@nocera.eu>"
LABEL org.opencontainers.image.source="https://github.com/raskyld/lemmy-cross-toolchains/aarch64-lemmy-linux-gnu"
LABEL org.opencontainers.image.licenses="Apache-2.0"
LABEL org.opencontainers.image.description="A cross toolchain from amd64 to aarch64 for the lemmy project"

ARG BR2_VERSION="e091e31831122b60b084bd755e94df4dfe7188d2"
ARG BR2_GIT_REPO="https://github.com/buildroot/buildroot.git"
ARG RUST_VERSION=1.77

RUN apt-get update && \
   apt-get install -y build-essential binutils diffutils bzip2 perl unzip rsync cpio bc git file wget curl

# We run as non-root user, your average SRE will thank me for that ;)
RUN groupadd -g 10001 lemmy && \
   useradd -m -u 10001 -g lemmy lemmy

USER 10001:10001
WORKDIR /home/lemmy

RUN set -ex; \
    git clone ${BR2_GIT_REPO} --recurse-submodules --shallow-submodules --branch="master" && \
    cd buildroot && git checkout ${BR2_VERSION}; \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain "${RUST_VERSION}"

COPY --chown=lemmy:lemmy br_config ./buildroot/.config

RUN cd buildroot && make

RUN rm -rf buildroot

ENV CROSS_ROOT="/home/lemmy/cross" \
    CROSS_TRIPLET="aarch64-lemmy-linux-gnu" \
    CARGO_BUILD_TARGET="aarch64-unknown-linux-gnu"

ENV AS="${CROSS_ROOT}/bin/${CROSS_TRIPLET}-as" \
    AR="${CROSS_ROOT}/bin/${CROSS_TRIPLET}-ar" \
    CC="${CROSS_ROOT}/bin/${CROSS_TRIPLET}-gcc" \
    CPP="${CROSS_ROOT}/bin/${CROSS_TRIPLET}-cpp" \
    LD="${CROSS_ROOT}/bin/${CROSS_TRIPLET}-ld" \
    PATH="${PATH}:${CROSS_ROOT}/bin" \
    CROSS_SYSROOT="${CROSS_ROOT}/${CROSS_TRIPLET}/sysroot" \
    CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER="$CROSS_TRIPLET-gcc" \
    CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_RUSTFLAGS="-C link-arg=--sysroot=${CROSS_ROOT}/${CROSS_TRIPLET}/sysroot"

RUN bash -c "source $HOME/.cargo/env && rustup target add $CARGO_BUILD_TARGET"

ENV AARCH64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR="${CROSS_SYSROOT}/usr/lib" \
    AARCH64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR="${CROSS_SYSROOT}/usr/include/openssl"

COPY --chown=lemmy:lemmy --chmod=744 entrypoint.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
