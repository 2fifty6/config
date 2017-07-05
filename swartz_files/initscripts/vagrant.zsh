alias vagrantedit="vim $0"
alias vagrantrefresh="source $0"
function vid (){
  IDS="`vagrant global-status | grep virtualbox | sed 's/\(.*\)virtualbox.*/\1/'`"
  if [[ ! -z "$1" || `echo $IDS | wc -l` -gt 1 ]]; then
    ID=`echo $IDS | /usr/bin/grep $1 2>/dev/null`
  else
    ID=`echo $IDS | head -n1`
  fi
  echo $ID | awk '{print $1}'
}
function vu (){ vagrant up $(vid $1) }
function vh (){ vagrant halt $(vid $1) }
function vd (){ vagrant destroy $(vid $1) -f }
function vp (){ vagrant provision $(vid $1) }
function vssh (){ vagrant ssh $(vid $1) 2> >(grep -v "Connection.*closed") }
function vsshcmd (){ vagrant ssh $(vid $1) -c $2 2> >(grep -v "Connection.*closed") }
alias vg="vagrant global-status | sed '/^[^\w]$/q'"
alias vup="vu"
alias vhalt="vh"
alias vdestroy="vd"
alias vprovision="vp"
alias vcmd="vc"
alias vupall='for VAG in $(vg|grep running| awk "{print $1}"|tr "\n" " "); do vagrant up $VAG; done'
alias vhaltall='for VAG in $(vg|grep running|awk "{print $1}"|tr "\n" " "); do vagrant halt $VAG; done'
alias vpall='for VAG in $(vg|grep running|awk "{print $1}"| tr "\n" " "); do vagrant provision $VAG; done'
alias vdall='for VAG in $(vg|grep running|awk "{print $1}"| tr "\n" " "); do vagrant destroy $VAG; done'
