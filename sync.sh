#!/bin/bash

pushd `dirname $0` >/dev/null
CURRDIR=`pwd`

ln -sf $CURRDIR/swartz_files/vimrc ~/.vimrc
ln -sf $CURRDIR/swartz_files/zshrc ~/.zshrc
ln -sf $CURRDIR/swartz_files/zprompt ~/.zprompt
ln -sf $CURRDIR/swartz_files/oh-my-zshrc ~/.oh-my-zshrc

[[ ! -L ~/.dotfiles/initscripts ]] && ln -sf $CURRDIR/swartz_files/initscripts ~/.dotfiles/initscripts
