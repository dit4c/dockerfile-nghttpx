FROM alpine:edge
MAINTAINER Tim Dettrick <t.dettrick@uq.edu.au>

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  addgroup -S nghttpx && \
  adduser -S -D -h /dev/null -s /sbin/nologin -G nghttpx nghttpx && \
  apk add --update nghttp2 && \
  rm -rf /var/cache/apk/*

EXPOSE 3000
USER nghttpx
ENTRYPOINT ["/usr/bin/nghttpx"]
CMD ["--help"]
