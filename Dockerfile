FROM ojkwon/arch-emscripten:42db8f11-base

# Build time args
ARG BRANCH=""
ARG TARGET=""

RUN echo building for $BRANCH

# Setup output / build source path
RUN mkdir -p /out && mkdir /hunspell-$TARGET

# Copy source host
COPY . /hunspell-$TARGET/

# Copy build script and preprocess into hunspell directory
COPY ./preprocessor.js ./build.sh /hunspell-$TARGET/hunspell/

# Set workdir to hunspell
WORKDIR /hunspell-$TARGET/hunspell

# Checkout branch to build
RUN git checkout $BRANCH && git show --summary

# Configure & make via emscripten
RUN echo running autoconf && autoreconf -vfi
RUN echo running configure && emconfigure ./configure
RUN echo running make && emcc -v && emmake make

CMD echo dockerfile ready