alias kitchenedit="vim $0"
alias kitchenrefresh="source $0"
[[ ! -e ~/.oh-my-zsh/custom/plugins/kitchen ]] && git clone https://github.com/pelletiermaxime/test-kitchen-zsh-plugin.git ~/.oh-my-zsh/custom/plugins/kitchen
function rekitchen (){
  kitchen destroy $* && kitchen converge $*
}
alias klist="kitchen list 2>/dev/null"
alias klogin="kitchen login 2>/dev/null"
alias kl=klist
alias kc="kitchen converge 2>/dev/null"
alias kk="kitchen converge 2>/dev/null"
alias kd="kitchen destroy 2>/dev/null"
export EDITOR=`which vim`
