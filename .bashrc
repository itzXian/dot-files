# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Preferences

shopt -s globstar
shopt -s dirspell
shopt -s cdspell
shopt -s autocd
shopt -s checkwinsize
shopt -s complete_fullquote
shopt -s hostcomplete

export TERM=xterm-256color

# Set up fzf key bindings and fuzzy completion
[[ -n "$(command -v fzf)" ]] &&\
  eval "$(fzf --bash)"

export LESS_TERMCAP_mb=$'\e[1;37m'
export LESS_TERMCAP_md=$'\e[36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[7;49;93m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;34m'

fancy_bash_prompt () {
if [ "$#" -gt 0 ]; then
  unset PS0 PROMPT_COMMAND PS1
  if [ "$(whoami)" = root ]; then
    PS1="\[\e[1;41m\] \W \[\e[m\]"
  else
    PS1="\[\e[1;44m\] \W \[\e[m\]"
  fi
else
  PS0=$(clear)
  PROMPT_COMMAND='\
echo -en \
"\e[40m"\
\ \
$?\
\ \
"\e[30;42m"\
\ \
$(history | tail -1 | cut -d " " -f 5-)\
\ \
"\e[30;43m"\
\ \
$(date +%H:%M)\
\ \
'
  if [ "$(whoami)" = root ]; then
    PS1="\[\e[30;41m\] \W \[\e[m\]\n"
  else
    PS1="\[\e[30;46m\] \W \[\e[m\]\n"
  fi
fi
}
fancy_bash_prompt off

# https://github.com/akinomyoga/ble.sh
if [ -e /usr/share/blesh/ble.sh ]; then
  [[ $- == *i* ]] && source /usr/share/blesh/ble.sh
elif [ -e "$(find $HOME -maxdepth 4 -type f -name ble.sh)" ] ; then
  [[ $BASH = *termux* ]] && LC_CTYPE=C.UTF-8
  source "$(find $HOME -maxdepth 4 -type f -name ble.sh)"
fi

# command-not-found on Arch Linux
[ -e /usr/share/doc/pkgfile/command-not-found.bash ] &&\
   . /usr/share/doc/pkgfile/command-not-found.bash
# bash-completion
[ -e /usr/share/bash-completion/bash_completion ] &&\
   . /usr/share/bash-completion/bash_completion


[[ -d ~/.bash ]] &&\
for i in ~/.bash/*; do
  source "$i";
done
