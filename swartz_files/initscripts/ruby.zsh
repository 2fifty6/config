# RUBY
alias rubyedit="vim $0"
alias rubyrefresh="source $0"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
alias rbinstall="RUBY_CONFIGURE_OPTS=--with-readline-dir=`brew --prefix readline` rbenv install"

alias rubocopper="rubocop -SDa"
