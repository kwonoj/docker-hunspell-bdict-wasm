### Simple script wraps invocation of emcc compiler, also prepares preprocessor
### for wasm binary lookup in node.js

# It is important call in forms of ./build.sh -o outputfilePath ...rest,
# as we'll pick up output filename from parameter
outputFilename=$(basename $2)

# Injecting -o option's filename into each targets preprocessor.
sed -i -e "s/___wasm_binary_name___/${outputFilename%.*}/g" ./preprocessor-wasm.js
sed -i -e "s/___asm_memfile_name___/${outputFilename%.*}/g" ./preprocessor-asm.js

echo "building binary for $@"

# invoke emscripten to build binary targets. Check Dockerfile for build targets.
em++ \
-O3 \
-Oz \
--llvm-lto 1 \
-s NO_EXIT_RUNTIME=1 \
-s ALLOW_MEMORY_GROWTH=1 \
-s EXPORTED_FUNCTIONS="['_Hunspell_create', '_Hunspell_destroy', '_Hunspell_spell', '_Hunspell_suggest']" \
./src/hunspell/.libs/libhunspell-1.6.a \
$@

# disable closure optimization for now
# --closure 1 \