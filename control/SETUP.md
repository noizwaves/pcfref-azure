## Step X. Deploy Control Plane

```
bosh deploy control-plane-0.0.31-rc.1.yml -d control-plane -o operations/azure-vm-extension.yml -l vars/control-plane-vars.yml
```