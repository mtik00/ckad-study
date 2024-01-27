# CKA/D Study Environment with A Cloud Guru

## ACG Cloud Playground

1.  Start a Playground
2.  Copy the credentials to `.secrets/env.sh`
3.  Source the file
4.  Configure aws:  
    `aws configure --profile cloudguru`
5.  Initialize the TF backend:  
    `cd terraform && ./initialize/configure.sh --create`
6.  Initialize the TF environment:  
    `terraform init`

When you're finished with the playground, tear it down:
1.  `./initialize/configure.sh --delete`
2.  `terraform destory`
3.  Delete the sandbox from the ACG application
