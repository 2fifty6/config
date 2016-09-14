alias ansibleedit="vim $0"
alias ansiblerefresh="source $0"

alias ahost='cat ~/.ansible.hosts'
alias ahostedit='vim ~/.ansible.hosts'
function ahostselect (){
  if [[ -z $1 ]]; then
    ls -l /Users/dswartz/.ansible.hosts
  else
    ln -sf /Users/dswartz/.ansible.hosts.$1 /Users/dswartz/.ansible.hosts
  fi
}
# For Reference:
# MAC Ansible Installed: /usr/local/Cellar/ansible/1.9.4/libexec/lib/python2.7/site-packages/ansible
