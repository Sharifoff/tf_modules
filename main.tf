terraform{
	required_version = ">=0.12"

	required_providers{
		aws ={
			source = "hashicrorp/aws"
			version = ">= 3.24"
		}
	}
}


variable "aws_region" {
  type = string
  default = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}

data "archive_file" "myzip" {
  type = "zip"
  source_file = "main.py"
  output_path = "main.zip"
}

resource "aws_lambda_function" "python_lambda" {
  filename = "main.zip"
  function_name = "python_test"
  role = aws_iam_role.python_lambda_role
  handler = "lambda_handler"
  runtime = "python3.8"
}

resource "aws_iam_role" "mypython_lambda_role" {


  name = "mypython_role"

  assume_policy = <<EOF
  {
	"Version" : "2012-10-17",
	"Statement" : 
	[
		{
		"Action" : "sts: AssumeRole",
		"Principal": {
			"Service" : "lambda.amazonaws.com"
		},

		
		"Effect": "Allow",
		"Sid" : ""	
		
	]
  }
EOF
}

resource "aws_sqs_queue" "main_queue"{
	name = "my-main-queue"
	delay_seconds = 30
	max_message_size = 262144
}

resource "aws_sqs_queue" "dlq_queue"{
	name = "my-dlq-queue"
	delay_seconds = 30
	max_message_size = 262144
}