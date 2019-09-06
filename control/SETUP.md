## Step X. Update Cloud Config

1. export cloud config to `cc.yml`
1. `cat config/cloud-config-extra-vm-types.ymlsnippet >> cc.yml`
1. update cloud config

## Step X. Deploy Control Plane

1. Download Control Plane tile.
1. Download stemcell.
1. Upload tile and stemcell.

## Step X. Deploy Minio

1. `bosh upload-stemcell *xenial*.tgz`
1. `bosh upload-release https://bosh.io/d/github.com/minio/minio-boshrelease`

1. Install `mc` on Ops Manager
1. `mc config host add control-plane http://10.0.10.13:9000 $STORAGE_ACCOUNT $STORAGE_ACCOUNT_KEY`
1. `mc ls control-plane/products`

## Step X. Log into Control Plane Credhub

1. `credhub login -s https://credhub.control.azure.pcfref.com:8844 --ca-cert=terraform/generated-certs/chain.pem --client-name=credhub_admin_client --client-secret=$SECRET`, where:
    1. `chain.pem` comes from `./terraform/extract-certs.sh`
    1. `$SECRET` comes from `om credentials -p control-plane -c .uaa.credhub_admin_client_credentials`

## Step X. Push pipelines

Obtain secrets
1. `((credhub-secret))` = `credhub get -n /p-bosh/control-plane/credhub_admin_client_password`