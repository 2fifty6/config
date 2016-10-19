# AWS
alias awsedit="vim $0"
alias awsrefresh="source $0"

[[ ! -e ~/.dotfiles/aws ]] && mkdir -p ~/.dotfiles/aws
[[ ! -e /usr/local/share/zsh/site-functions/_envselect ]] &&
  cat > /usr/local/share/zsh/site-functions/_envselect <<EOF
#compdef envselect
compadd \$(command ls -1 ~/.dotfiles/aws 2>/dev/null --color=none |
  sed -e 's/ /\\\\ /g' -e 's/.*aws://g')
EOF

function envselect(){
  if [[ -z $1 ]]; then
    ls -l ~/.autoenv.zsh
  else
    AUTOENV_PATH=~/.dotfiles/aws/$1/.autoenv.zsh
    if [[ -e $AUTOENV_PATH ]]; then
      ln -sf $AUTOENV_PATH ~/.autoenv.zsh
      source ~/.autoenv.zsh
    else
      echo "No match for $AUTOENV_PATH"
    fi
  fi
}

alias enva='env | grep --color=no AWS'
function awsdefault (){
  export AWS_DEFAULT_PROFILE=$1
}

## EC2
alias describe-ec2='aws ec2 describe-instances --instance-ids '
alias ec2ids="aws ec2 describe-instances --instance-ids"
function ec2-jqprivateip(){
  jq ".Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[0].PrivateIpAddress"
}
function ec2-jqpublicip(){
  jq ".Reservations[].Instances[].PublicIpAddress"
}

function ec2-byname (){
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" "Name=instance-state-name,Values=running"
}
function ec2-ipbyname (){
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" "Name=instance-state-name,Values=running" |
    ec2-jqprivateip |
    sed 's/"//g'
}
function ec2-ipbyvpc (){
  aws ec2 describe-instances --filters "Name=vpc-id,Values=$1" "Name=instance-state-name,Values=running" |
    ec2-jqprivateip |
    sed 's/"//g'
}
function ec2-ipbynamevpc (){
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" "Name=vpc-id,Values=$2" "Name=instance-state-name,Values=running" |
    ec2-jqprivateip |
    sed 's/"//g'
}
function ec2-publicipbyname (){
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" "Name=instance-state-name,Values=running" |
    ec2-jqpublicip |
    sed 's/"//g'
}
function ec2-publicipbynamevpc (){
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" "Name=vpc-id,Values=$2" "Name=instance-state-name,Values=running" |
    ec2-jqpublicip |
    sed 's/"//g'
}

function ec2-namebyip (){
  aws ec2 describe-instances --filters "Name=private-ip-address,Values=$1" "Name=instance-state-name,Values=running" | jq '.Reservations[].Instances[].Tags[] | select(.Key=="Name") | .Value'|sed 's/"//g'
}
# keypairs
function mkkeypair (){
  KEY_NAME=$1
  [[ ! -z $2 ]] && REGION=$2 || REGION=us-east-1
  aws ec2 create-key-pair --key-name $KEY_NAME --region $REGION |
  ruby -e "require 'json'; puts JSON.parse(STDIN.read)['KeyMaterial']" > ~/.ssh/$KEY_NAME &&
    chmod 600 ~/.ssh/$KEY_NAME.pem
}
function rmkeypair (){
  KEY_NAME=$1
  [[ ! -z $2 ]] && REGION=$2 || REGION=us-east-1
  aws ec2 delete-key-pair --key-name $KEY_NAME --region $REGION &&
    rm ~/.ssh/$KEY_NAME.pem
}
