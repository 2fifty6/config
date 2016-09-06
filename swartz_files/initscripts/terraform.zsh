# TERRAFORM
alias ta="terraform remote pull && terraform apply && terraform remote push"
alias td="terraform remote pull && terraform destroy -force && terraform remote push"
alias tp="terraform plan"
alias to="terraform output"
alias tg="terraform get -update"
alias tfrm='rm **/.terraform/terraform.tfstate'
