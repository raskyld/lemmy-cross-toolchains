# lemmy-cross-toolchains

This repository contains cross toolchains made for the specific needs of the
[Lemmy][lemmy] project, it's not general purpose but feel free to get in touch
with me if you need help with cross-compilation in the Rust ecosystem as I was
close to lose my mental sanity building those toolchains.

[lemmy]: https://github.com/LemmyNet/lemmy

## Toolchains

### aarch64-lemmy-linux-gnu

Build: `amd64`

Host: `aarch64`

Components:
- `libpq`
- `openssl`
- `glibc`
- `gcc`
