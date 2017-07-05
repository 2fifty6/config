# AWS
alias awsedit="vim $0"
alias awsrefresh="source $0"

[[ ! -e ~/.dotfiles/aws ]] && mkdir -p ~/.dotfiles/aws
#[[ ! -x /usr/local/share/zsh/site-functions/_envselect ]] &&
#  sudo cat > /usr/local/share/zsh/site-functions/_envselect <<EOF
##compdef envselect
#compadd \$(command ls -1 ~/.dotfiles/aws 2>/dev/null --color=none |
#  sed -e 's/ /\\\\ /g' -e 's/.*aws://g')
#EOF

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

# VPC
function vpc-byname (){
  aws ec2 describe-vpcs --filters Name=tag:Name,Values=$1
}
function vpc-jqid (){
  jq -r '.Vpcs[].VpcId'
}
# ELB
function elb-jqname(){
  jq -r '.LoadBalancerDescriptions[].LoadBalancerName'
}
function elb-jqstate(){
  jq -r '.InstanceStates[].State'
}
function elb-jqhealth(){
  jq -r '.LoadBalancerDescriptions[].HealthCheck.Target'
}
function elb-getstatebyname(){
  ELB_NAME=$1
  aws elb describe-instance-health --load-balancer-name $ELB_NAME | elb-jqstate
}

function elb-gethealthbyname(){
  ELB_NAME=$1
  aws elb describe-load-balancers --load-balancer-name $ELB_NAME | elb-jqhealth
}
function lselb(){
  aws elb describe-load-balancers | elb-jqname
}
function rmelb(){
  ELB_NAME=$1
  aws elb delete-load-balancer --load-balancer-name $ELB_NAME
}
## EC2
export RUNNING_INSTANCE_FILTER="Name=instance-state-name,Values=running"

alias describe-ec2='aws ec2 describe-instances --instance-ids '
alias ec2ids="aws ec2 describe-instances --instance-ids"
function ec2-jqid(){
  jq -r '.Reservations[].Instances[].InstanceId'
}
function ec2-jqname(){
  jq -r '.Reservations[].Instances[].Tags[] | select(.Key=="Name") | .Value'
}
function ec2-jqprivateip(){
  jq -r ".Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[0].PrivateIpAddress"
}
function ec2-jqpublicip(){
  jq -r ".Reservations[].Instances[].PublicIpAddress"
}
function ec2-jqvolumes(){
  jq -r '.Reservations[].Instances[].BlockDeviceMappings[] | .DeviceName + "\t" + .Ebs.VolumeId'
}
function ec2-jqvolumeids(){
  jq -r '.Reservations[].Instances[].BlockDeviceMappings[].Ebs.VolumeId'
}

function ec2-byname (){
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" $RUNNING_INSTANCE_FILTER
}
function ec2-namebyid (){
  aws ec2 describe-instances --instance-ids $1 |
    ec2-jqname
}
function ec2-idbyname (){
  ec2-byname $1 |
    ec2-jqid
}
function ec2-ipbyname (){
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" $RUNNING_INSTANCE_FILTER |
    ec2-jqprivateip
}
function ec2-byvpc (){
  aws ec2 describe-instances --filters "Name=vpc-id,Values=$1" $RUNNING_INSTANCE_FILTER
}
function ec2-ipbyvpc (){
  aws ec2 describe-instances --filters "Name=vpc-id,Values=$1" $RUNNING_INSTANCE_FILTER |
    ec2-jqprivateip
}
function ec2-ipbynamevpc (){
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" "Name=vpc-id,Values=$2" $RUNNING_INSTANCE_FILTER |
    ec2-jqprivateip
}
function ec2-publicipbyname (){
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" $RUNNING_INSTANCE_FILTER |
    ec2-jqpublicip
}
function ec2-publicipbynamevpc (){
  aws ec2 describe-instances --filters "Name=tag:Name,Values=$1" "Name=vpc-id,Values=$2" $RUNNING_INSTANCE_FILTER |
    ec2-jqpublicip
}
function ec2-namebyip (){
  aws ec2 describe-instances --filters "Name=private-ip-address,Values=$1" $RUNNING_INSTANCE_FILTER | jq -r '.Reservations[].Instances[].Tags[] | select(.Key=="Name") | .Value'
}

function ec2-snapshotbyid (){
  aws ec2 describe-snapshots --snapshot-ids $*
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
# asg
function rmasg () {
  ASG_NAME=$1
  aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $ASG_NAME --force-delete
}
function lsasg () {
  aws autoscaling describe-auto-scaling-groups|jq -r '.AutoScalingGroups[].AutoScalingGroupName'
}
function rmlc () {
  LC_NAME=$1
  aws autoscaling delete-launch-configuration --launch-configuration-name $LC_NAME
}
function lslc () {
  aws autoscaling describe-launch-configurations  | jq -r '.LaunchConfigurations[].LaunchConfigurationName'
}
# iam
function iam-instance-profile (){
  aws iam get-instance-profile --instance-profile-name $1
}
function iam-jqprofilerole (){
  jq -r '.InstanceProfile.Roles[].RoleName'
}

# ALB
function target-group-health (){
  aws elbv2 describe-target-health --target-group-arn $1 | jq -r '.TargetHealthDescriptions[].TargetHealth.State'
}

# Cloudwatch
function cloudwatch-jqmetric(){
  jq -r '.Metrics[] | .Dimensions[].Value + "-" + .MetricName' | sort
}
