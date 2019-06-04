---
title: PCFRef Azure
---

# PCFRef Azure

## Goals

This aims to represent a realistic set of deployed PCF foundations and the associated artifacts that would be created during a Platform Dojo by PCFS.
If an Azure hosted foundation was deployed today, it would look something like this.

The intented audience for this is:
1.  PCFS team members who are unfamilar with Azure:
    - that need to prepare for an Azure engagement
    - to learn how (and why) to navigate the intricacies of deploying to Azure
1.  PCFS team members who are familar with Azure:
    - to consolidate learnings about deploying PCF to Azure
    - to demonstrate how all of the various tools can be glued together (and the rational behind these decisions)
1.  PCFS team members:
    - to reference for certain IaaS-independant patterns and solutions
1.  Pivotal employees:
    - to see what a typical deployment of PCF looks like

### Anti-goals

- accelerate in a rapid deployment of PCF
- automate all the things

## Overview

This deployment represents a PCF deployment that:
- runs the latest PAS
- is internet connected
- has 1 foundation (`nonprod`)
- is managed by a Control Plane (`control`) using Platform Automation
- is paved with Terraform

## Articles

- [Automatically rotate Let's Encrypt certificates](./lets-encrypt-certificates.md)