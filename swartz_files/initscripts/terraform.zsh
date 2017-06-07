# TERRAFORM
alias terraformedit="vim $0"
alias tfedit=terraformedit
alias terraformrefresh="source $0"
alias tfrefresh=terraformrefresh
alias ta="terraform remote pull && terraform apply && terraform remote push"
alias td="terraform remote pull && terraform destroy -force && terraform remote push"
alias tp="terraform plan"
alias to="terraform output"
alias tg="terraform get -update"
alias tfrm='rm **/.terraform/terraform.tfstate'
alias tfrmrf='rm -rf **/.terraform'
function tf-getresources(){
  grep -r '^resource' . | awk '{print $2 $3}' | sed -e 's/"/ /g' -e 's/^ //g' -e 's/  / /g'| sort | uniq
}
function tf-getvars(){
  tffiles=$(ls **.tf | tr '\n' ' ')
  [[ ! -z $1 ]] && tffiles=$1
  grep -r '\bvar\.[a-z_]*' $(echo $tffiles)| sed -e 's/[^}]*\(\${var\.[^}]*}\)/\1 /g' -e 's/}.*{/} ${/g' -e 's/}[^{]*$/}/g' -e 's/ \${count.index}//g' -e 's/^[^\$]*.*var.\([a-z_]*\).*/\1/g' | sort | uniq
}
