alias ansibleedit="vim $0"
alias ansiblerefresh="source $0"

function whatsmyip () { ansible -i /dev/null localhost -mipify_facts 2>/dev/null | grep public_ip | awk '{print $2}' | sed 's/"//g' }
#[[ ! -e ~/.ansible.hosts ]] && touch ~/.ansible.hosts
#export ANSIBLE_INVENTORY=~/.ansible.hosts
#alias ahost='cat ~/.ansible.hosts'
#alias ahostedit='vim ~/.ansible.hosts'
#function ahostselect (){
#  if [[ -z $1 ]]; then
#    ls -l ~/.ansible.hosts
#  else
#    ln -sf $HOME/.ansible.hosts.$1 $HOME/.ansible.hosts
#  fi
#}
# For Reference:
# MAC Ansible Installed: /usr/local/Cellar/ansible/1.9.4/libexec/lib/python2.7/site-packages/ansible
