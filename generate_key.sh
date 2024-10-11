#!/usr/bin/env sh

set -euo pipefail  # Exit on error, treat unset variables as an error, and return the exit status of the last command in a pipeline.

# Check if openssl is installed
if ! command -v openssl &> /dev/null; then
    echo "Error: openssl is not installed."
    exit 1
fi

TMP_DIR=$(mktemp -d)

CURRENT_DIR=$(pwd)

cd "$TMP_DIR"

curl -sSL "https://raw.githubusercontent.com/vandepitte/dh/refs/heads/main/dhparam.pem" | openssl genpkey -paramfile /dev/stdin -out private.pem

openssl pkey -in private.pem -pubout -out public.pem

echo "Your API key:"

echo

curl -sSL "https://raw.githubusercontent.com/vandepitte/dh/refs/heads/main/public.pem" | openssl pkeyutl -derive -inkey private.pem -peerkey /dev/stdin | base64 | tr -d '\n'| tr '+/' '-_' | tr -d '='

echo

echo

echo "Send next key to DNS Belgium:"

echo

cat public.pem

cd "$CURRENT_DIR"

rm -rf "$TMP_DIR"
