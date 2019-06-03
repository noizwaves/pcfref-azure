# Automatically rotate Let's Encrypt certificates

## Goals

- Demonstrate automated renewal and rotation of SSL certificates to address the issues caused by expired certificates
- Demonstrate the use of Terraform to easily create (and renew) valid SSL certificates for a Control Plane and PCF Foundations

## Overview

The PCF installation `pcfref-azure` uses Let's Encrypt certificates on all
- Ops Manager instances
- PAS deployments
- Control Plane components including Concourse

The `acme` Terraform provider is used interact with Let's Encrypt from Terraform.
The certificates are generated initially when running Terraform, and then re-generated later when running Terraform close to certificate expiration (this timing is controlled by the `min_days_remaining` variable on the `acme_certificate.certificate` resource).
The certificate, chain, and private key are all returned as Terraform outputs.

Terraform is run in the `pave-iaas` job via the custom task `configuration/tasks/terraform-apply.yml`.
This task exposes the Let's Encrypt certificates as the output `generated-certs`, which can be used by subsequent tasks as inputs.

The generated certificates and keys are stored in the Control Plane Credhub instance so that they can easily be interpolated into configuration files with Platform Automation.
The values are stored as a secret named `credhub-set-certificate`.
The certificates and key are written to Credhub on every build using the custom task `tasks/credhub-set-certificate.yml`.
A custom task is used (instead of a Concourse resource) as the Concourse Credhub resource cannot be "put" to.
Currently the `credhub-set-certificate` task is not idemponent and will update the `credhub-set-certificate` secret's `updated_on` field, thus triggering a new version of the Concourse resource, and then triggering unneccisary PAS Apply Changes. 

Ops Manager certificates are configured using the custom task `tasks/update-ssl-certificate.yml` during the `install-opsman` job. 
The task obtains the certificates and key values from the Concourse-Credhub variable interpolation in the task's parameters.

PAS certificates are configured during the `configure-product` task.
The Credhub interpolation task populates the values into the `cf-vars.yml` file, which is used as a vars file during configuration.

Control Plane components certificates are configured during the manual BOSH deployment.
The operations file `control/operations/use-lets-encrypt-certificates.yml` is used to replace specific certificates in the deployment manifest.
The certificates and key values are passed in as vars to `bosh deploy`.
Automation of this (BOSH deploy) step will be made redundant when a proper Control Plane tile is released, which will be as-easy as PAS to automate.

## Automation

All required tasks (except for configuring Control Plane components) are captured programmatically as Concourse tasks.

A daily resource can be used to automatically trigger the running of Terraform to regenerate new certificates if required.

A Credhub resource can be used to automatically trigger the `configure-pas` and `install-opsman` jobs when the values in Credhub change. The certificates will be rotated when Apply Changes is next run.
