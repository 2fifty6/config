# RUBY
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
alias rbinstall="RUBY_CONFIGURE_OPTS=--with-readline-dir=`brew --prefix readline` rbenv install"
