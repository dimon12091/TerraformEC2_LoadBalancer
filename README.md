# Network Load Balancer and EC2 service

## Getting started

Install on Linux [jg package manager](https://stedolan.github.io/jq/) (if you haven't already).

## Requirements

To use this project you have to have:
- AWS Account and AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- Terraform (https://learn.hashicorp.com/tutorials/terraform/install-cli)

## About

You must download key pair(rename to key_pair1.pem) and insert in folder `scripts`

In folder `connection` have connection powershell scripts to the instance.

In folder `scripts` have scripts to deploy the site and start a project.

Your passwords are displayed in the `sensitive_data` folder


## Run project

Run script `first_time_execution.sh`