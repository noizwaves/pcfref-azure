## Backlog

- Document growing pcfref-azure
- Update nonprod to 2.5
- Configure `ignore_paths` on configuration to control triggering of jobs
- Perform backup explicitly before opsman upgrade?
- Document Control Plane implementation
- Document PCFRef Azure (rational, users)
- Incorporate learnings from https://github.com/jseely/pivotal-azure-architecture-center/blob/master/reference-architecture/hub-and-spoke/pas.md
    - AZs vs ASs
    - Newer VM types
- Automate nonprod standup (6am) and teardown (6pm)
- cf-mgmt pipelines
- one team per foundation (nonprod, control)
- Create 2 more foundations, sandbox and prod
- Azure service broker
- Azure AD to auth all the things
- Automate rotation of Lets Encrypt certs in bosh deployed Control Plane

Fancy
- Terraform interpolate
- Use [Azure Blobstore resource](https://github.com/pivotal-cf/azure-blobstore-resource)