#!/bin/bash
set -e
. set_devkit_path.sh
cd freetype-$BUILD_FREETYPE_VERSION

echo "Building Freetype"

export PATH=$TOOLCHAIN/bin:$PATH
CFLAGS="-fno-rtti -O3 -mcpu=cortex-a725 -flto=thin -fwhole-program-vtables -mllvm -polly -mllvm -polly-vectorizer=stripmine -fno-semantic-interposition -fvisibility=hidden -fvisibility-inlines-hidden -fno-plt -ffunction-sections -fdata-sections" LDFLAGS="-mcpu=cortex-a725 -flto=thin -fwhole-program-vtables -fuse-ld=lld -fno-semantic-interposition -fvisibility=hidden -fvisibility-inlines-hidden -fno-plt -ffunction-sections -fdata-sections -Wl,--gc-sections -Wl,--as-needed -Wl,--exclude-libs,ALL -Wl,-Bsymbolic" ./configure \
  --host=$TARGET \
  --prefix=${PWD}/build_android-${TARGET_SHORT} \
  --without-zlib \
  --with-png=no \
  --with-harfbuzz=no $EXTRA_ARGS \
  || error_code=$?

if [[ "$error_code" -ne 0 ]]; then
  echo "\n\nCONFIGURE ERROR $error_code , config.log:"
  cat ${PWD}/builds/unix/config.log
  exit $error_code
fi

make -j4
make install