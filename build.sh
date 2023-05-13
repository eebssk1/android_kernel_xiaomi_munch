#!/bin/sh

sudo apt-get install -y libelf-dev libssl-dev dwarves bc jitterentropy-rngd device-tree-compiler curl python2

curl -L "https://github.com/eebssk1/arm-gcc/releases/download/c1f751eb/arm-gcc.tgz" | tar --gz -xf -

export PATH=${PWD}/arm-gcc/aarch64-linux-musl/bin:${PWD}/arm-gcc/arm-linux-musleabi/bin:$PATH

mkdir out

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-musl-
export CROSS_COMPILE_ARM32=arm-linux-musleabi-

export XXYH="-fmodulo-sched -freschedule-modulo-scheduled-loops -fipa-pta -flimit-function-alignment -fsched-spec-load -fsched-stalled-insns=6 -fsched-stalled-insns-dep=16 -fira-loop-pressure --param=predictable-branch-outcome=5 --param=max-crossjump-edges=320 --param=max-delay-slot-insn-search=325 --param=inline-heuristics-hint-percent=650 --param=inline-min-speedup=34 --param=max-inline-recursive-depth-auto=10 --param=max-inline-recursive-depth=12 --param=min-inline-recursive-probability=14 --param=modref-max-adjustments=15 --param=modref-max-depth=325 --param=min-vect-loop-bound=3 --param=gcse-cost-distance-ratio=13 --param=gcse-unrestricted-cost=2 --param=max-hoist-depth=90 --param=dse-max-object-size=368 --param=dse-max-alias-queries-per-store=320 --param=scev-max-expr-size=128 --param=scev-max-expr-complexity=12 --param=max-predicted-iterations=154 --param=max-reload-search-insns=185 --param=max-cselib-memory-locations=600 --param=max-sched-ready-insns=190 --param=sched-autopref-queue-depth=2 --param=analyzer-max-recursion-depth=5 --param=gimple-fe-computed-hot-bb-threshold=3 --param=max-cse-path-length=16 --param=max-rtl-if-conversion-insns=20 --param=max-sched-extend-regions-iters=4 --param=max-stores-to-sink=4 --param=ranger-logical-depth=15 --param=vect-partial-vector-usage=1 --param=analyzer-bb-explosion-factor=6 --param=analyzer-max-enodes-per-program-point=10 --param=hash-table-verification-limit=16 --param=fsm-scale-path-blocks=4 --param=fsm-scale-path-stmts=3 --param=graphite-max-arrays-per-scop=160 --param=sms-max-ii-factor=3 --param=sms-dfa-history=5 --param=sms-loop-average-count-threshold=5 --param=unroll-jam-min-percent=4 --param=max-ssa-name-query-depth=4  --param=max-slsr-cand-scan=120 --param=max-sched-extend-regions-iters=3 --param=scev-max-expr-complexity=16 --param=scev-max-expr-size=128 --param=min-vect-loop-bound=3"
export KCFLAGS="-fgraphite -fgraphite-identity -floop-nest-optimize ${XXYH}"

make munch_defconfig O=out
make -j3 O=out

if [ ! -e out/arch/arm64/boot/Image ]
then
exit 1
fi
