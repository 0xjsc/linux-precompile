FROM debian:bookworm-slim

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends git build-essential flex bison dwarves libssl-dev libelf-dev cpio qemu-utils python

RUN git clone https://github.com/microsoft/WSL2-Linux-Kernel --depth 1
RUN cd WSL2-Linux-Kernel

RUN make -j$(($(nproc) - 1)) alldefconfig KCONFIG_CONFIG=Microsoft/config-wsl
RUN make -j$(nproc) KCONFIG_CONFIG=Microsoft/config-wsl

RUN make INSTALL_MOD_PATH="$PWD/modules" modules_install

RUN ./Microsoft/scripts/gen_modules_vhdx.sh "$PWD/modules" $(make -s kernelrelease) modules.vhdx

RUN make clean && rm -r "$PWD/modules"

