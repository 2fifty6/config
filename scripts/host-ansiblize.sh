#!/bin/bash
ANSIBLE_HOST="$1"
ANSIBLE_SSH_USER="$2"
ANSIBLE_SSH_PASS=""
ANSIBLE_SUDO_PASS=""

usage () {
  echo -e "\e[31;1mERROR:\e[;0m no hostname specified!"
  echo -e "\t\e[1;1musage: `basename $0`\e[0m HOST [ sshuser ]"
  exit 1
}

# get ssh host; must be passed in
[[ -z "$ANSIBLE_HOST" ]] && usage

# get ssh user
while [[ -z "$ANSIBLE_SSH_USER" ]]; do
  echo -n "ssh username:  "
  read ANSIBLE_SSH_USER
done

if [[ "$ANSIBLE_SSH_USER" == "vagrant" ]]; then
  ANSIBLE_SSH_PASS="vagrant"
  ANSIBLE_SUDO_PASS="vagrant"
fi

# get ssh password
while [[ -z "$ANSIBLE_SSH_PASS" ]]; do
  echo -n "ssh password:  "
  read -s ANSIBLE_SSH_PASS
  echo
done

# get sudo password
while [[ -z "$ANSIBLE_SUDO_PASS" ]]; do
  echo -n "sudo password: "
  read -s ANSIBLE_SUDO_PASS
  echo
done

# generate temporary inventory file
TEMP_INVENTORY="`mktemp /tmp/ansinvXXXXXXXX`"

# make sure temporary inventory file lifetime is the execution of this script
function cleanup {
  rm -rf "$TEMP_INVENTORY"
}
trap cleanup EXIT

# generate temporary inventory file contents
cat > $TEMP_INVENTORY<<END
ansiblehost ansible_ssh_host=$ANSIBLE_HOST ansible_connection=ssh ansible_ssh_user=$ANSIBLE_SSH_USER ansible_ssh_pass=$ANSIBLE_SSH_PASS ansible_sudo_pass=$ANSIBLE_SUDO_PASS

[ansibles]
ansiblehost
END

# get directory of repo (current script)
LOCAL_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REMOTE_DIR=$( echo $LOCAL_DIR | sed "s/\/home\/$(whoami)/\/home\/$ANSIBLE_SSH_USER/" )

ansible-playbook -i $TEMP_INVENTORY $REMOTE_DIR/playbooks/ansiblize.yml --extra-vars="local_dir=$LOCAL_DIR remote_dir=$REMOTE_DIR"
[[ $? -eq 0 ]] && echo "Successfully ansiblized $ANSIBLE_SSH_USER@$ANSIBLE_HOST" || echo "Failed to ansiblize $ANSIBLE_SSH_USER@$ANSIBLE_HOST"
