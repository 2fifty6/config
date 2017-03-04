#!/bin/bash

pushd `dirname $0` >/dev/null
CURRDIR=`pwd`

ln -sf $CURRDIR/swartz_files/vimrc ~/.vimrc
ln -sf $CURRDIR/swartz_files/gitconfig ~/.gitconfig
ln -sf $CURRDIR/swartz_files/zshrc ~/.zshrc
ln -sf $CURRDIR/swartz_files/zprompt ~/.zprompt
ln -sf $CURRDIR/swartz_files/oh-my-zshrc ~/.oh-my-zshrc

mkdir -p ~/.dotfiles
[[ ! -L ~/.dotfiles/initscripts ]] && ln -sf $CURRDIR/swartz_files/initscripts ~/.dotfiles/initscripts

[[ ! -e ~/.vim/bundle/Vundle.vim ]] && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
