# Network Load Balancer and EC2 service


## Requirements

To use this project you have to have:
- AWS Account and AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- Terraform (https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Key.pem 

### Insert key_pair1.pem in bootstrap folder.

## Run project

- Run script `deploy_infrastructure.ps1` 

### Run scripts into a privileged shell
- Run script `exec_remote_deploy.ps1` for deploy IIS website in VM's
- Run script `exec_remote_delete.ps1` for delete IIS website in VM's
