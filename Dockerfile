FROM alpine:edge
MAINTAINER Tim Dettrick <t.dettrick@uq.edu.au>

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  addgroup -S nghttpx && \
  adduser -S -D -h /dev/null -s /sbin/nologin -G nghttpx nghttpx && \
  apk add --update nghttp2 python openssl ca-certificates && \
  rm -rf /var/cache/apk/*

USER nghttpx
ENTRYPOINT ["/usr/bin/nghttpx"]
CMD ["--help"]

EXPOSE 3000/tcp
