# GIT
alias gitedit="vim $0"
alias gitrefresh="source $0"
alias st="git status"
alias stt="git status -s"
alias pull="git pull --all"
alias fetch="git fetch --all"

function modall(){
  FILES="$(git status -s| sed 's/^R .*-> //'|sed 's/^[ ]*[A-Z]*[ ]*//'|sort|uniq)"
	if [[ ! -z "$@" ]]; then
		FILES="$(echo $FILES | grep --color=no "$@")"
	fi
	if [[ ! -z "$FILES" ]]; then
		FILES="$(echo $FILES | tr "\n" " ")"
    vim $(echo $FILES)
	fi
}
function mod (){
  FILES="$(git status | grep --color=no modified | sed 's/\(.*\)modified:\([\ ]*\)\(.*\)/\3/')"
  FILES=$(echo $FILES | sort | uniq)
	if [[ ! -z "$@" ]]; then
		FILES="$(echo $FILES | grep --color=no "$@")"
	fi
	if [[ ! -z "$FILES" ]]; then
		FILES="$(echo $FILES | tr "\n" " ")"
    vim $(echo $FILES)
	fi
}

function 2fifty6(){
  SUBCMD=$1
  BRANCH=$2
  case $SUBCMD in
    "push")
#      bash -c "read -rsp \"push $BRANCH to 2fifty6?\" -n1 key"
#      echo
      # git push remote local:remote
      git push 2fifty6 $BRANCH:$BRANCH
      ;;
    "rm")
#      echo $BRANCH
#      bash -c "read -rsp \"delete $BRANCH from 2fifty6?\" -n1 key"
#      CURRBRANCH=`git branch | grep \* | awk "{print $2}"`
#      echo $BRANCH
#      echo $CURRBRANCH
#      if [[ $CURRBRANCH == $BRANCH ]]; then
#        bash -c "read -rsp \"currently on $BRANCH check out develop first?\" -n1 key"
#        echo
#        git checkout develop
#      fi
#      echo
      git branch -D $BRANCH && git push 2fifty6 :$BRANCH
      ;;
    "co"|"checkout"|"branch")
#      bash -c "read -rsp \"check out new branch $BRANCH?\" -n1 key"
#      echo
      git co -b $BRANCH --track rean/develop
      ;;
    *)
      echo "wtf?"
      ;;
esac
}

#function stashrebase(){
#  git stash
#  git rebase -i HEAD~2
#  git stash pop
#}
#alias str="stashrebase"
