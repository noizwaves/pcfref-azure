---
title: Growing the PCF Installation Iteratively
---

# Growing the PCF Installation Iteratively

## Introduction

The PCFRef Azure installation did not start out highly automated and modularly decomposed.
Instead, it started out highly manual, and automation was introduced where appropriate.
This article describes how PCFRef Azure grew by outlining key technical milestones along the way.

This approach worked well for this installation.
It could also work well for other installations or onboarding type activities.

## The High Level Steps

The installation grew in these high level steps:

1. Manual install following the "Installing PCF on Azure Using Terraform" documentation using Ops Manager web UI
1. Use `om` CLI to manage (capture, update, apply) configurations and apply changes
1. Deployment of Control Plane
1. Manually triggered configuring of BOSH Director via a pipeline
1. Manually triggered configuring of PAS via a pipeline
1. Manually triggered fetching of products via a pipeline
1. Add additional products following patterns
1. Enhance pipelines with "passed" job dependencies and triggers

## Detailed History

The installation grew in this way:

1. Manual installation of `nonprod` using `terraform` CLI and Ops Manager web UI
    - Manual Terraform w/ Ops Manager following [the docs](https://docs.pivotal.io/pivotalcf/om/azure/prepare-env-terraform.html) ([commit](https://github.com/noizwaves/pcfref-azure/commit/71
    - Manual configuration of Ops Manager & BOSH Director following [the docs](https://docs.pivotal.io/pivotalcf/om/azure/config-terraform.html)
    - Manual configuration of PAS following [the docs](https://docs.pivotal.io/pivotalcf/customizing/configure-pas.html)
    - only 1 CLI tool used, all other interation is web based
    - local Terraform state
    - no product configuration saved locally, only exists in the foundation
1. Introduction of `om` CLI to obtain configuration `.yml` files
    - Ops Manager and BOSH Director configuration exported and added to source control ([commit](https://github.com/noizwaves/pcfref-azure/commit/71996baa748bb24453b2a1657cf2e8919bad863c))
    - PAS configuration exported and added to source control [the docs](https://docs.pivotal.io/pivotalcf/customizing/configure-pas.html) ([commit](https://github.com/noizwaves/pcfref-azure/commit/9577c3505d98960df52827abf2a067f4fbe3a848))
    - obtain configuration, make edits locally, configure product, apply changes all using `om`
1. Deployment of a Control Plane to enable automation
    - Started with [this commit](https://github.com/noizwaves/pcfref-azure/commit/cb09b18803b1749bcab2fda5643628386e7017d5)
    - Minio deployed as a blobstore in [this commit](https://github.com/noizwaves/pcfref-azure/commit/b00221a2d34744e5c83a9b9aec11f7b1cfd243ca)
1. Separation of "secrets" from "variables" in the configuration files for Ops Manager and BOSH Director
    - In [this commit](https://github.com/noizwaves/pcfref-azure/commit/50f443333ad8a63f53bb574ea5bfa908b73276a3)
1. Automated configuration of Ops Manager and BOSH Director using a pipeline
    - In [this commit](https://github.com/noizwaves/pcfref-azure/commit/97567f7bbf30058555760fdfae59a3d5c0ada273)
    - Credentials manually moved to Control Plane Credhub instance
    - Job must be manually triggered
1. Automated configuration of PAS using the same pipeline
    - In [this commit](https://github.com/noizwaves/pcfref-azure/commit/884365f47695dc565d4677adcb0cc5b71feb1857)
    - Fetching, uploading and staging of PAS has not been automated
    - Job must be manually triggered
1. Automated fetching of PAS
    - Product download configuration added in [this commit](https://github.com/noizwaves/pcfref-azure/commit/2e14170158531b63920d1a7b5e70d958877763fe)
    - Pipeline automation added in [this commit](https://github.com/noizwaves/pcfref-azure/commit/33bf280677478b387a13e18bf0e28950d839ac73)
    - Jobs must be manually triggered
1. Perform a manual Ops Manager "Export Installation"
    - In web UI
    - Then using `om export-installation`
1. Automate export installation in a pipeline
    - In [this commit](https://github.com/noizwaves/pcfref-azure/commit/14412dc5b13a216916f0500bd0644a629efc24b2)
1. Move Terraform state from local disk to remote backend
    - In [this commit](https://github.com/noizwaves/pcfref-azure/commit/419adc93677e61ca9b161ecba01799033f0d0e27)
1. Automate IaaS paving using same pipeline
    - In [this commit](https://github.com/noizwaves/pcfref-azure/commit/b4928bb6b63c6b03987b1c6c8eed92fe3aeb468a)
1. Add first tile (MySQL) to `nonprod`
    - Tile fetched and staged using automation in [this commit](https://github.com/noizwaves/pcfref-azure/commit/73828096cd86101ebfa3bdad167d7231f52d89c5)
    - Tile manually configured using Ops Manager web UI
    - Tile manually deployed
    - Configuration exported and added to source control in [this commit](https://github.com/noizwaves/pcfref-azure/commit/9894199a39fb287ad219f2f5e6d71f16746dfb38)
    - Tile configuration applied and deployed using pipeline in [this commit](https://github.com/noizwaves/pcfref-azure/commit/37be72a509c82048dfabb02fc9a1feb27689aeca)
1. Add other (RabbitMQ, Redis) tiles to `nonprod`
1. Enhance pipeline with job dependencies
    - In (this commit)[https://github.com/noizwaves/pcfref-azure/commit/699f66fb6f6acbae4af3ce752ef787531e1795c3]
1. Refactor pipeline to use anchors and aliases
    - In (this commit)[https://github.com/noizwaves/pcfref-azure/commit/932b04ae467f17f9c60d537dc75c2914a1642d1b], and
    - Also in (this commit)[https://github.com/noizwaves/pcfref-azure/commit/d292e9ab1ea1d48a10df6b3b9b48f582bfa7a1f1]