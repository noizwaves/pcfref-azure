## Backlog

- Document Let's Encrypt implementation
- Document Control Plane implementation
- Document growing pcfref-azure
- Document PCFRef Azure (rational, users)
- Incorporate learnings from https://github.com/jseely/pivotal-azure-architecture-center/blob/master/reference-architecture/hub-and-spoke/pas.md
    - AZs vs ASs
    - Newer VM types
- Automate nonprod standup (6am) and teardown (6pm)
- cf-mgmt pipelines
- backup and restore pipelines: https://github.com/pivotal-cf/bbr-pcf-pipeline-tasks/blob/master/examples/pas-pipeline.yml
- one team per foundation (nonprod, control)
- Create 2 more foundations, sandbox and prod
- Azure service broker
- Azure AD to auth all the things
- Automate rotation of Lets Encrypt certs in bosh deployed Control Plane