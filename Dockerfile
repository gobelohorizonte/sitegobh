FROM alpine:3.5 as build
LABEL maintainer Eduardo Figueiredo Gonçalves <oi@eduardofg.dev>
ENV HUGO_VERSION 0.55.6
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.tar.gz
#https://github.com/gohugoio/hugo/releases/download/v0.55.6/hugo_0.55.6_Linux-64bit.tar.gz

# We add git to the build stage, because Hugo needs it with --enableGitInfo
RUN apk add --no-cache git

# Install Hugo
RUN set -x && \
apk add --update wget ca-certificates && \
wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} && \
tar xzf ${HUGO_BINARY} && \
rm -r ${HUGO_BINARY} && \
mv hugo /usr/bin && \
apk del wget ca-certificates && \
rm /var/cache/apk/*

COPY . /site

WORKDIR /site

# And then we just run Hugo
RUN /usr/bin/hugo --minify --enableGitInfo

# By default, serve site alterar para https://gobh.dev/ no deploy
ENV HUGO_BASE_URL https://gobh.dev/
CMD hugo server -D \
        --baseUrl=${HUGO_BASE_URL} \
        --port=80 \
        --appendPort=false \
        --bind=0.0.0.0 \
        --disableLiveReload=false
