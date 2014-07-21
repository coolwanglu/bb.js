#!/bin/bash
set -e
[ -z $EM_DIR] && EM_DIR=~/src/emscripten
[ -z $AALib_DIR] && AALib_DIR=~/src/aalib.js

do_config() {
    echo config
# something wrong with emcc + cproto, use gcc as CPP instead
CPPFLAGS="-Os -I$AALib_DIR/src" \
$EM_DIR/emconfigure ./configure \
  --without-x \

}

do_make() {
$EM_DIR/emmake make CFLAGS="-Os -I$AALib_DIR/src" 
}

do_link() {
pushd web
cp ../bb bb.bc 
$EM_DIR/emcc \
    -Oz \
    -profiling \
    -s ASYNCIFY=1 \
    -o bb.js \
    bb.bc \
    $AALib_DIR/src/.libs/libaa.a \
    --js-library $AALib_DIR/web/aaweb.js \
    --memory-init-file 1 \
    --preload-file pdcfont.bmp \

popd
}

#do_config
do_make
do_link
