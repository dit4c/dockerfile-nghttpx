# dit4c/nghttpx

[![](https://badge.imagelayers.io/dit4c/nghttpx:latest.svg)](https://imagelayers.io/?images=dit4c/nghttpx:latest)

Very simple [nghttpx](https://nghttp2.org/documentation/nghttpx.1.html) image.

Python and CA certificates are included for OCSP support.

# Example Usage

Reverse-proxy <http://mirror.aarnet.edu.au/> on port 81 (<abbr title="HTTP/2 cleartext">h2c</abbr>):

```shell
docker run -i --rm -p 81:3000 dit4c/nghttpx \
  --frontend-no-tls \
  --host-rewrite \
  -b mirror.aarnet.edu.au,80
```

Reverse-proxy <http://mirror.aarnet.edu.au/> on port 443 using self-signed certs:

```shell
# Create self-signed certs (elliptic curve)
openssl ecparam -genkey -name prime256v1 -out server.key
openssl req -new -key server.key -out server.csr
openssl req -x509 -days 365 -key server.key -in server.csr -out server.crt
# Run nghttpx
docker run -i --rm -p 443:3000 \
  -v `pwd`:/data:ro \
  dit4c/nghttpx \
  --host-rewrite \
  -b mirror.aarnet.edu.au,80 \
  /data/server.key /data/server.crt
```

Reverse-proxy container `myappserver` with exposed port 8080 on port 443 using self-signed certs:

```shell
# (Self-signed certs, as above)
# Run nghttpx in background
docker run -d --name myappserver-reverse-proxy \
  -p 443:3000 \
  --link myappserver:backend \
  -v `pwd`:/data:ro \
  dit4c/nghttpx \
  -b backend,8080 \
  /data/server.key /data/server.crt
```

Check it works using `nghttp`:

```shell
# (Self-signed certs, as above)
# Run nghttpx in background
docker run -ti --rm \
  --link myappserver-reverse-proxy:target \
  --entrypoint /usr/bin/nghttp \
  dit4c/nghttpx \
  -v https://target:3000/
```
