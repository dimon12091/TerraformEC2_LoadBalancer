#first apply aws_s3_bucket and later terraform init -auto-approve backed s3

# # terraform {
# #   backend "s3" {
# #     # Replace this with your bucket name!
# #     bucket         = "terraform-backend-state-global-test"
# #     key            = "global/s3/terraform.tfstate"
# #     region         = "us-east-2"    # Replace this with your DynamoDB table name!
# #     dynamodb_table = "terraform-backend-state-global-test"
# #     encrypt        = true
# #   }
# # }

# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "terraform-backend-state-global-test" 
#   # state files
#   versioning {
#     enabled = true
#   }  # Enable server-side encryption by default
#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#       }
#     }
#   }
# }

# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "terraform-backend-state-global-test"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"  
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

# output "s3_bucket_arn" {
#   value       = aws_s3_bucket.terraform_state.arn
#   description = "The ARN of the S3 bucket"
# }
# output "dynamodb_table_name" {
#   value       = aws_dynamodb_table.terraform_locks.name
#   description = "The name of the DynamoDB table"
# }