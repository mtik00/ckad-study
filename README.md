# CKA/D Study Environment with A Cloud Guru

## ACG Cloud Playground

1.  Start a Playground
2.  Copy the credentials to `.secrets/env.sh`
3.  Source the file
5.  Initialize the TF backend:  
    `cd terraform && ./initialize/configure.sh --create --aws`
6.  Initialize the TF environment:  
    `terraform init`

When you're finished with the playground, tear it down:
1.  `terraform destroy`
2.  `./initialize/configure.sh --delete`
3.  Delete the sandbox from the ACG application

NOTE: It's important to manually delete the Terraform backend S3 bucket and DynamoDB.  Doing this _BEFORE_ deleting the sandbox will ensure you can quickly spin up another sandbox without waiting for the S3 bucket to eventually be removed.  You will lose the ability to use `awscli` shortly after deleting the sandbox.
