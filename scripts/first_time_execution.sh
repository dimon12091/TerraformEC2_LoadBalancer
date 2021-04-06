#Initialize - Run terraform init in the project directory with the configuration files. This will download the correct provider plug-ins for the project.
terraform init

#terraform apply to create real resources as well as state file that compares future changes in your configuration files to what actually exists in your deployment environment.
terraform apply -target aws_subnet.my_subnets -auto-approve
terraform apply -auto-approve

#output pass into passwords.txt
terraform output -json instance_info | jq  '.[]' | sed 's/"//'| sed 's/"//'  >> sensitive_data/passwords.txt
