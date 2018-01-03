#!/bin/bash -x

pushd `dirname $0` >/dev/null
CURRDIR=`pwd`

ln -sf $CURRDIR/swartz_files/vimrc ~/.vimrc
ln -sf $CURRDIR/swartz_files/gitconfig ~/.gitconfig
ln -sf $CURRDIR/swartz_files/zshrc ~/.zshrc
ln -sf $CURRDIR/swartz_files/zprompt ~/.zprompt
ln -sf $CURRDIR/swartz_files/oh-my-zshrc ~/.oh-my-zshrc

mkdir -p ~/.dotfiles
[[ ! -L ~/.dotfiles/initscripts ]] && ln -sf $CURRDIR/swartz_files/initscripts ~/.dotfiles/initscripts

[[ ! -L ~/scripts ]] && ln -sf $CURRDIR/scripts ~/scripts

[[ ! -e ~/.vim/bundle/Vundle.vim ]] && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

zsh_dir=/usr/local/share/zsh/site-functions
#for completion in `ls $CURRDIR/swartz_files/zsh/site-functions`; do
#  [[ ! -L $zsh_dir/$completion ]] &&
#    ln -sf $CURRDIR/swartz_files/zsh/site-functions/$completion $zsh_dir/$completion
#done
