#! /bin/sh

cd openssl || exit 1

env \
    CROSS_COMPILE="" \
    AR="zig ar" \
    RANLIB="zig ranlib" \
    CC="zig cc --target=wasm32-wasi" \
    CFLAGS="-Ofast -Werror -Qunused-arguments -Wno-shift-count-overflow -fPIC" \
    CPPFLAGS="$CPPFLAGS -D_BSD_SOURCE -D_WASI_EMULATED_GETPID -Dgetuid=getpagesize -Dgeteuid=getpagesize -Dgetgid=getpagesize -Dgetegid=getpagesize" \
    CXXFLAGS="-Werror -Qunused-arguments -Wno-shift-count-overflow" \
    LDFLAGS="-s -lwasi-emulated-getpid -shared" \
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
    wasm32-wasi || exit 1

make -j$(nproc)

cd - || exit 1

mkdir -p precompiled/lib
mv openssl/*.a precompiled/lib

mkdir -p precompiled/include
cp -r openssl/include/openssl precompiled/include
