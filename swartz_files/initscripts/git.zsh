# GIT
alias gti=git
alias gt=git
alias got=git
alias gitedit="vim $0"
alias gitrefresh="source $0"
alias gb="git branch"
alias gbr="git branch -r"
alias gi="git"
alias gita="git"
alias gitp="git"
alias st="git status"
alias stt="git status -s"
alias pull="git pull --all"
alias fetch="git fetch --all"

function gcommit(){
  git commit -m"$1"
}
function gpushamend(){
  git commit --amend --no-edit && git show && sleep 1 && git push --force
}
function modall(){
  FILES="$(git status -s| sed 's/^R .*-> //'|sed 's/^[ ]*[A-Z]*[ ]*//'|sort|uniq|grep -v '??')"
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

function pullall(){
  currbranch=$(git branch | grep '*' --color=no | awk '{print $2}')
  for branch in `git branch | sed 's/\*//'`; do echo "updating $branch..."; git co $branch; git pull; echo; done
  git co $currbranch
}
alias pa=pullall
function giturl(){
  git config -l | grep url | sed 's/.*:\/\///'
}
function gitprev (){
  currbranch=$(git branch | grep '*' --color=no | awk '{print $2}')
  git diff origin/$currbranch..$currbranch
}
alias gprev=gitprev
function gitmergeprev (){
    currbranch=$(git branch | grep '*' --color=no | awk '{print $2}')
    mbranch=`echo $currbranch | sed -e 's/test/dev/' -e 's/prod/test/'`
    git diff $currbranch..$mbranch
}
alias gmprev=gitmergeprev
#[[ ! -e /usr/local/share/zsh/site-functions/_2fifty6 ]] &&
#  cat > /usr/local/share/zsh/site-functions/_2fifty6 <<EOF
##compdef 2fifty6
#compadd \$(command echo 'checkout commit push rm')
#EOF

function 2fifty6(){
  SUBCMD=$1
  BRANCH=$2
  CURRBRANCH=$(git branch --no-color|grep \* --color=no | awk '{print $2}')
  # default branch is current
  [[ -z $BRANCH ]] && BRANCH=$CURRBRANCH
  case $SUBCMD in
    "push")
      # git push remote local:remote
      git push 2fifty6 $BRANCH:$BRANCH
      ;;
    "rm")
      # if deleting current branch, check out develop first
      if [[ $BRANCH == $CURRBRANCH ]]; then
        git checkout develop
      fi
      [[ ! -z $(git branch | grep "\b${BRANCH}\b") ]] && git branch -D $BRANCH
      [[ ! -z $(git branch -r | "grep 2fifty6/${BRANCH}") ]] && git push 2fifty6 :$BRANCH
      ;;
    "co"|"checkout"|"branch")
      git co -b $BRANCH --track rean/develop
      ;;
    "commit")
      git commit -m"$CURRBRANCH $2"
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
