#!/bin/bash

GPG=gpg2

mkdir -p tmp
TMP_KEYRING=$(mktemp -p tmp)
GPG_FLAGS="--batch --no-default-keyring --keyring $TMP_KEYRING"
$GPG $GPG_FLAGS --import signing.key
for f in "$@"; do
  rm -f "${f}.asc"
  $GPG $GPG_FLAGS --armour --detach-sign "$f"
done
rm $TMP_KEYRING
