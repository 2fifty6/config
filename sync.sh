#!/bin/bash

PWD=`pwd`
if [[ ! -d ~/.ssh ]]; then
  mkdir ~/.ssh
fi
ln -sf $PWD/swartz_files/ssh_config ~/.ssh/config
ln -sf $PWD/swartz_files/gitconfig ~/.gitconfig
ln -sf $PWD/swartz_files/vimrc ~/.vimrc
ln -sf $PWD/swartz_files/zshrc ~/.zshrc
ln -sf $PWD/swartz_files/zprompt ~/.zprompt
ln -sf $PWD/swartz_files/oh-my-zshrc ~/.oh-my-zshrc

ln -sfn $PWD/swartz_files/ansible /etc/ansible
ln -sf $PWD/swartz_files/ansible/ansible.cfg ~/.ansible.cfg
