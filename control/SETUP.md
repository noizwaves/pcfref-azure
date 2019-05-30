## Step X. Update Cloud Config

1. export cloud config to `cc.yml`
1. `cat config/cloud-config-extra-vm-types.ymlsnippet >> cc.yml`
1. update cloud config

## Step X. Deploy Control Plane

```
bosh deploy control-plane-0.0.31-rc.1.yml -d control-plane
    -o operations/azure-vm-extension.yml
    -o operations/larger-worker-disk.yml
    -o operations/use-lets-encrypt-certificates.yml
    -l vars/control-plane-vars.yml
    -l vars/lets-encrypt-secrets.yml
```

## Step X. Deploy Minio

1. `bosh upload-stemcell *xenial*.tgz`
1. `bosh upload-release https://bosh.io/d/github.com/minio/minio-boshrelease`

1. Install `mc` on Ops Manager
1. `mc config host add control-plane http://10.0.10.13:9000 $STORAGE_ACCOUNT $STORAGE_ACCOUNT_KEY`
1. `mc ls control-plane/products`

## Step X. Log into Control Plane Credhub

1. `credhub login -s https://plane.control.azure.pcfref.com:8844 --ca-cert=plane.pem --client-name=credhub_admin_client --client-secret=$SECRET`, where:
    1. `plane.pem` comes from BOSH Director Credhub `credhub get -n /p-bosh/control-plane/control-plane-ca` (`.certificate`)
    1. `$SECRET` comes from BOSH Director Credhub `credhub get -n /p-bosh/control-plane/credhub_admin_client_password`

## Step X. Push pipelines

Obtain secrets
1. `((credhub-secret))` = `credhub get -n /p-bosh/control-plane/credhub_admin_client_password`