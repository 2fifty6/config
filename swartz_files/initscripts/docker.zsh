alias dockeredit="vim $0"
alias dedit=dockeredit
alias dockerrefresh="source $0"
alias drefresh=dockerrefresh

[[ -z "$DOCKER_PORT" ]] && DOCKER_PORT=2222

function docker-centos {
  OS="centos"
  [[ -z $1 ]] && NAME=$OS || NAME=$1
  docker run -h $OS --name $NAME -p$DOCKER_PORT:22 -it -d -v /home/dswartz/git/ansible:/tmp/ansible dswartz/2fifty6:$OS
  DOCKER_PORT=$((DOCKER_PORT+1))
}
alias dcentos=docker-centos

function docker-fedora {
  OS="fedora"
  [[ -z $1 ]] && NAME=$OS || NAME=$1
  docker run -h $OS --name $NAME -p$DOCKER_PORT:22 -it -d -v /home/dswartz/git/ansible:/tmp/ansible dswartz/2fifty6:$OS
  DOCKER_PORT=$((DOCKER_PORT+1))
}
alias dfedora=docker-fedora

function docker-debian {
  OS="debian"
  [[ -z $1 ]] && NAME=$OS || NAME=$1
  docker run -h $OS --name $NAME -p$DOCKER_PORT:22 -it -d -v /home/dswartz/git/ansible:/tmp/ansible dswartz/2fifty6:$OS
  DOCKER_PORT=$((DOCKER_PORT+1))
}
alias ddebian=docker-debian

function docker-ubuntu {
  OS="ubuntu"
  [[ -z $1 ]] && NAME=$OS || NAME=$1
  docker run -h $OS --name $NAME -p$DOCKER_PORT:22 -it -d -v /home/dswartz/git/ansible:/tmp/ansible dswartz/2fifty6:$OS
  DOCKER_PORT=$((DOCKER_PORT+1))
}
alias dubuntu=docker-ubuntu

function dnames { docker ps --format '{{.Names}}' }
function dports { docker ps --format '{{.Ports}}' }
function dids { docker ps --format '{{.ID}}' }

function dall {
  for did in $(dids); do
    docker inspect $did
  done
}
function dkillall {
  for did in $(dids); do
    docker kill $did && docker rm $did
  done
}
