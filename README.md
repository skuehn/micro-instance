# Micro Instance

Create an AWS EC2 t2.micro instance in the specified region. The micro
instance supports https traffic ingress and egress, and ssh access.

Example session:
```sh
terraform apply -auto-approve -var 'aws_region=us-east-1'
<use the instance>
terraform destroy -force -var 'aws_region=us-east-1'
```

You will be billed for a t2.micro instance and associated data transfer
until you destroy the micro instance.

Note that this implementation is not secure enough to be used as a
terraform module or part of a long-running deployment. Generated ssh
keys are written to the terraform state, which means anyone with
access to the terraform state will have superuser access to the micro
instance.

## Installation and Launch

### Prerequisites
1. Install [terraform](https://www.terraform.io/downloads.html) version >= 0.12
2. (Optional) Install the [aws cli](https://aws.amazon.com/cli/)

### Prepare terraform
1. Run `terraform init`
1. (Optional) Run `terraform plan`. Verify there are no errors and review the plan
of resources that will be created.

### Create the instance
1. Find your aws credentials, set the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` env vars. Alternatively,
enter these credentials interactively when running terraform commands.
1. Run `terraform apply`. Specify an aws region by setting the `-var aws_region=<region>` variable.
To find a list of available regions, run `aws ec2 describe-regions`. us-east-1 is used by default.

### Use the instance
Connect to the instance via ssh. See connect.sh for an example ssh command and
examples of how to find the ssh key and hostname.

### Remove the instance
Set the aws_region variable to the same region used in terraform apply.
Run `terraform destroy -force -var 'aws_region=<region>'`

## Known Issues
1. Ssh key material is copied to the terraform output. If this is an
issue consider creating your own key pair and reconfiguring the
`aws_instance` resource to take a provided (via terraform variable)
public key as a runtime variable.
1. TODO's: narrow the policy scope
