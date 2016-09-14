alias zshedit="vim $0"
alias zshrefresh="source $0"

# keyboard behavior# {{{
bindkey ';5D' backward-word
bindkey ';5C' forward-word
bindkey    "^[[3~"          delete-char
bindkey    "^[3;5~"         delete-char
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
# }}}

# ZSH
setopt correct
HISTFILE=$HOME/.zhistory			# enable history saving on shell exit
setopt APPEND_HISTORY				# append rather than overwrite history file.
HISTSIZE=99999999						# lines of history to maintain memory
SAVEHIST=99999999					# lines of history to maintain in history file.
setopt HIST_EXPIRE_DUPS_FIRST		# allow dups, but expire old ones when I hit HISTSIZE
setopt EXTENDED_HISTORY				# save timestamp and runtime information
setopt interactivecomments			# allow comments on command line
setopt noequals						# don't evaluate = as command substitution
alias cp='nocorrect cp '
alias mv='nocorrect mv '
alias mkdir='nocorrect mkdir '
alias ssh='nocorrect ssh '
alias vi='vim'
alias l='ls -lhA'
alias ll='ls -l'
alias ls='ls -G'
alias watch='watch --color'
alias zedit="vim ~/.zshrc"
alias zrefresh="source ~/.zshrc"
alias ohmyzedit="vim ~/.oh-my-zshrc"

