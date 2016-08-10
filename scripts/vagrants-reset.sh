#!/bin/bash
control_c()
{
  exit
}
trap control_c SIGINT

destroy_vagrant(){
  echo -e "\e[1;31mDestroying $1\e[m. (hit Ctrl+C to cancel)"
  sleep 3
  vagrant destroy -f
}

TEMP=`getopt -o m:p:r:d --long match:,playbook:,restore:,destroy,no-provision -n "$0" -- "$@"`
eval set -- "$TEMP"

usage () {
  ISERROR=$1
  echo -e "\[31;1mERROR:\e[;0m SoMeErRoRmEsSaGe!"
  echo -e "\t\e[1;1musage: `basename $0`\e[0m [ OPTION ]"
  exit $ISERROR
}

MATCH=""
PLAYBOOK=""
RESTORE=""
DESTROY=0
NO_PROVISION=0

while true ; do
  case "$1" in
    -m|--match) MATCH=$2 ; shift 2 ;;
    -p|--playbook) PLAYBOOK=$2 ; shift 2 ;;
    -r|--restore) RESTORE=$2 ; shift 2 ;;
    -d|--destroy) DESTROY=1 ; shift ;;
    --no-provision) NO_PROVION=1 ; shift ;;
    --) shift ; break ;;
  esac
done

LIMIT=""

# RESET / RESTORE
REPO_DIR_LOCAL=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
for VAGRANT_DIR in `find $REPO_DIR_LOCAL/vagrants -type f -name Vagrantfile | sort -r | xargs dirname`; do

  # check if VM is a match
  if [[ "$VAGRANT_DIR" =~ "$MATCH" ]]; then
    echo -e "\e[1;4mWorking on vagrant\e[m: \e[92m`basename $VAGRANT_DIR`\e[m"
    cd $VAGRANT_DIR
    vagrant halt

    # what is the VM name?
    VM_NAME=$(grep --color=no -r vb.name Vagrantfile | sed 's/.*"\([^"]*\)".*/\1/')

    # if snapshot to restore was specified
    if [[ ! -z $RESTORE ]]; then
      echo -e "\e[1;1mRestoring snapshot\e[m: \e[92m$RESTORE\e[m"
      VBoxManage snapshot $VM_NAME restore $RESTORE

    # elif
    #   ANY OTHER REASONS TO OVERRIDE DESTROY=1?
    else
      # are we forcing destruction of the VM?
      if [[ $DESTROY -eq 1 ]]; then
        destroy_vagrant $VM_NAME

      else
        # if we have any snapshots, restore the latest
        LATEST_SNAPSHOT=$(VBoxManage snapshot $VM_NAME list 2>/dev/null | grep --color=no Name | tail -n1 | awk '{print $2}')
        if [[ ! -z $LATEST_SNAPSHOT ]]; then
          echo -e "\e[1;1mRestoring latest snapshot\e[m: \e[92m$LATEST_SNAPSHOT\e[m"
          VBoxManage snapshot $VM_NAME restorecurrent

        # elif
        #   ANY OTHER REASONS NOT TO DESTROY?
        else
          # else, just destroy it
          destroy_vagrant $VM_NAME
        fi

      fi
    fi

    # now bring it on back
    vagrant up
    echo

  fi
done

# PROVISION
if [[ $NO_PROVION -ne 1 ]]; then
  if [[ ! -z $MATCH ]]; then
    LIMIT="--limit localhost,$MATCH"
  fi
  ansible-playbook $REPO_DIR_LOCAL/playbooks/vagrant/provision.yml $LIMIT
fi

if [[ ! -z $PLAYBOOK && -e $REPO_DIR_LOCAL/playbooks/vagrant/${PLAYBOOK}.yml ]]; then
  ansible-playbook $REPO_DIR_LOCAL/playbooks/vagrant/${PLAYBOOK}.yml $LIMIT
fi
