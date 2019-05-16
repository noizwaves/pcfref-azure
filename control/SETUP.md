## Step X. Deploy Control Plane

```
bosh deploy control-plane-0.0.31-rc.1.yml -d control-plane -o operations/azure-vm-extension.yml -l vars/control-plane-vars.yml
```

## Step X. Deploy Minio

1. `bosh upload-stemcell *xenial*.tgz`
1. `bosh upload-release https://bosh.io/d/github.com/minio/minio-boshrelease`

1. Install `mc` on Ops Manager
1. `export MC_HOST_controlplane=http://admin:$MINIO_SECRET_KEY@10.0.10.14:9000`
1. `mc mb controlplane/products`

## Step X. Log into Control Plane Credhub

1. `credhub login -s https://plane.control.azure.pcfref.com:8844 --ca-cert=plane.pem --client-name=credhub_admin_client --client-secret=$SECRET`, where:
    1. `plane.pem` comes from BOSH Director Credhub `credhub get -n /p-bosh/control-plane/control-plane-ca` (`.certificate`)
    1. `$SECRET` comes from BOSH Director Credhub `credhub get -n /p-bosh/control-plane/credhub_admin_client_password`

## Step X. Push pipelines

Obtain secrets
1. `((credhub-secret))` = `credhub get -n /p-bosh/control-plane/credhub_admin_client_password`
1. `((credhub-ca-cert))` = `credhub get -n /p-bosh/control-plane/control-plane-ca` (`.certificate`)