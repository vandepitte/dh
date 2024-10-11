#!/usr/bin/env sh

TMP_DIR=$(mktemp -d)

CURRENT_DIR=$(pwd)

cd "$TMP_DIR"

curl -sSL "https://raw.githubusercontent.com/vandepitte/dh/refs/heads/main/dhparam.pem" | openssl genpkey -paramfile /dev/stdin -out private.pem

openssl pkey -in private.pem -pubout -out public.pem

echo "Your API key:"

echo

curl -sSL "https://raw.githubusercontent.com/vandepitte/dh/refs/heads/main/public.pem" | openssl pkeyutl -derive -inkey private.pem -peerkey /dev/stdin | base64 -w 0 | tr '+/' '-_' | tr -d '='

echo

echo "Send next key to DNS Belgium:"

echo

cat public.pem

cd "$CURRENT_DIR"

rm -rf "$TMP_DIR"
