terraform{
	required_version = ">=0.12"

	required_providers{
		aws ={
			source = "hashicrorp/aws"
			version = ">= 3.24"
		}
	}
}