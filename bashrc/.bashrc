#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export EDITOR=micro
eval "$(starship init bash)"


fo() {
  local file
  file=$(find "${1:-.}" -type f | fzf --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}')
  [ -n "$file" ] && ${EDITOR:-micro} "$file"
}
