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
