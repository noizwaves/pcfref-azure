#! /bin/sh

rm -rf generated-certs
mkdir -p generated-certs

terraform output lets_encrypt_cert > generated-certs/cert.pem
terraform output lets_encrypt_chain > generated-certs/chain.pem
terraform output lets_encrypt_privkey > generated-certs/privkey.pem
