#!/bin/sh

sudo apt-get install -y libelf-dev libssl-dev dwarves bc jitterentropy-rngd device-tree-compiler curl python2 clang

curl -L "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz?rev=6750d007ffbf4134b30ea58ea5bf5223&hash=6C7D2A7C9BD409C42077F203DF120385AEEBB3F5" | tar -xf - --xz
curl -L "https://developer.arm.com/-/media/Files/downloads/gnu/12.2.rel1/binrel/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz?rev=9929cb6c0e8948f0ba1a621167fcd56d&hash=1259035C716B41C675DCA7D76913684B5AD8C239" | tar -xf - --xz

export PATH=${PWD}/arm-gnu-toolchain-12.2.rel1-x86_64-aarch64-none-linux-gnu/bin:${PWD}/arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-linux-gnueabihf/bin:$PATH

mkdir out

export ARCH=arm64
export CROSS_COMPILE=aarch64-none-linux-gnu-
export CROSS_COMPILE_ARM32=arm-none-linux-gnueabihf-

export XXYH="-mllvm --enable-tail-merge=true -mllvm --enable-newgvn=true -mllvm --enable-loopinterchange=true -mllvm --enable-gvn-hoist=true -mllvm --optimize-regalloc=true -mllvm --use-gvn-after-vectorization=true -mllvm --enable-partial-inlining=true -mllvm --disable-sched-live-uses=false -mllvm --disable-sched-stalls=false -mllvm --unroll-allow-partial=true -mllvm --hot-cold-split=true -mllvm --extra-vectorizer-passes=true"
export KCFLAGS="-mllvm -polly=true -mllvm -polly-run-inliner=true -mllvm -polly-run-dce=true -mllvm -polly-vectorizer=stripmine -mllvm -polly-detect-profitability-min-per-loop-insts=56  -mllvm -polly-default-tile-size=30 -mllvm -polly-2nd-level-tiling=true -mllvm -polly-2nd-level-default-tile-size=14 -mllvm -polly-register-tiling=true -mllvm -polly-register-tiling-default-tile-size=3 -mllvm -polly-opt-max-coefficient=30 -mllvm -polly-opt-max-constant-term=30 ${XXYH}"

make munch_defconfig CC=clang O=out
make -j3 CC=clang O=out

if [ ! -e out/arch/arm64/boot/Image ]
then
exit 1
fi
