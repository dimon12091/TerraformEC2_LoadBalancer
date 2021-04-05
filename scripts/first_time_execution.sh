terraform init
terraform apply -target aws_subnet.my_subnets -auto-approve
terraform apply -auto-approve
terraform output -json instance_info | jq  '.[]' | sed 's/"//'| sed 's/"//'  >> sensitive_data/passwords.txt
