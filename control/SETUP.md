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