#! /bin/sh

cd openssl || exit 1

env \
    CROSS_COMPILE="" \
    CC="turbo cc" \
    CXX="turbo cxx" \
    CFLAGS="-O3 -Werror -Qunused-arguments -Wno-shift-count-overflow -fPIC -mbulk-memory -matomics" \
    CPPFLAGS="$CPPFLAGS -D_BSD_SOURCE -D_WASI_EMULATED_GETPID -Dgetuid=getpagesize -Dgeteuid=getpagesize -Dgetgid=getpagesize -Dgetegid=getpagesize" \
    CXXFLAGS="-Werror -Qunused-arguments -Wno-shift-count-overflow" \
    LDFLAGS="-lwasi-emulated-getpid -shared" \
    ./Configure \
    --banner="wasm32-wasi port" \
    no-asm \
    no-async \
    no-egd \
    no-ktls \
    no-module \
    no-posix-io \
    no-secure-memory \
    no-shared \
    no-sock \
    no-stdio \
    no-thread-pool \
    no-threads \
    no-ui-console \
    no-weak-ssl-ciphers \
    no-atexit \
    no-autoload-config \
    no-autoalginit \
    no-autoerrinit \
    no-http \
    wasm32-wasi-threads || exit 1

make -j$(nproc)

cd - || exit 1

mkdir -p precompiled/lib
mv openssl/*.a precompiled/lib

mkdir -p precompiled/include
cp -r openssl/include/openssl precompiled/include
