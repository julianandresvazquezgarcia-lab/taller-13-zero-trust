
#!/usr/bin/env bash
set -euo pipefail
umask 077

cd "$(dirname "$0")/../pki"

for n in $(seq "$1" "$2"); do
    id="bus-${n}"

    openssl genrsa -out "${id}.key" 2048

    openssl req -new \
      -key "${id}.key" \
      -subj "/C=CO/O=MetroMIO/OU=Flota/CN=${id}" \
      -out "${id}.csr"

    openssl x509 -req \
      -in "${id}.csr" \
      -CA ca.crt \
      -CAkey ca.key \
      -CAcreateserial \
      -out "${id}.crt" \
      -days 30 \
      -sha256 \
      -extfile client.ext

    echo "Certificado emitido: ${id}"
    openssl verify -CAfile ca.crt "${id}.crt"
done
