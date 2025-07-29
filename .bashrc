# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Preferences
[[ -n $DISPLAY                &&\
   -n "$(command -v xset)" ]] &&\
  xset b off

shopt -s globstar
shopt -s dirspell
shopt -s autocd
shopt -s checkwinsize
shopt -s complete_fullquote
shopt -s hostcomplete

set -o vi
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

alias dfs='git --git-dir=$(find $HOME -maxdepth 2 -name dot-files 2>/dev/null)/.git --work-tree=$HOME'

# PATH
 # pnpm
export PNPM_HOME="/home/ei/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
 # yarn
[[ -n "$(command -v yarn)"                                    &&\
  $(uname -n) != localhost                                    &&\
  $BASH       != *termux*                                     &&\
  $PATH       != *yarn*                                       &&\
   -d         $(yarn global bin)                           ]] &&\
  export PATH="$PATH:$(yarn global bin)"
 # ruby
[[ -n "$(command -v ruby)"                                    &&\
   $PATH      != *ruby*                                       &&\
   -d                $(ruby -e 'puts Gem.user_dir')/bin    ]] &&\
  export PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
 # python
[[ -n "$(command -v python)"                                  &&\
   $PATH      != *$HOME/.local/bin*                           &&\
   -d             ~/.local/bin                             ]] &&\
  export PATH="$PATH:$HOME/.local/bin"
 # android-studio
[[ -n "$(command -v android-studio)"                          &&\
   $PATH      != *Android*                                    &&\
   -d                ~/Android/Sdk/tools/bin               ]] &&\
  export PATH="$PATH:~/Android/Sdk/tools/bin"                 &&\
  export ANDROID_HOME=~/Android/Sdk                           &&\
 # rofi
export PATH="$PATH:~/.config/rofi/bin"
 # local bin
[[ -d              ~/.local/bin                           ]] &&\
export PATH="$PATH:~/.local/bin"

# Alias
[[ -n "$(command -v xset)"             ]] &&\
  OF () { [[ -n $DISPLAY               ]] &&\
    xset -display :1 dpms force off
  }
[[ -n "$(command -v xrdb)"             ]] &&\
  Xx () { [[ -n $DISPLAY                  &&\
             -f ~/.Xresources          ]] &&\
    xrdb ~/.Xresources
  }
[[ -n "$(command -v xprop)"            ]] &&\
  Xp () { [[ -n $DISPLAY               ]] &&\
    xprop | grep -E 'WM_(CLASS|NAME)'
  }

[[ -n "$(command -v sudo)" ]] && alias sudo='sudo '

alias MP='echo $PATH                        \
          | sed "s/:/\n/g"                  \
      '

alias IP='echo $(whoami)@$(ip addr          \
                        | grep -Eo 192.*    \
                        | cut -f 1 -d /     \
               )                            \
      '

alias ..='../'
alias ...='../../'
alias ....='../../../'
alias .....='../../../../'

- () { "$OLDPWD"; }

/ () {
  if [ $# -eq 0 ]; then
    cd /
  else
    local dir
    local arg=$@
    if   [ "$(echo $arg | cut -c 1)" = /  ]; then
      dir=/
      arg=$(echo $arg | sed 's/^\///g')
    elif [ "$(echo $arg | cut -c 1)" = \~ ]; then
      dir=~/
      arg=$(echo $arg | sed 's/^~//g')
    fi

    if   [ -n "$(echo $arg | grep ' ')" ]; then
      for i in $(echo $arg); do
        dir+=$i*/
      done
    elif [ -n "$(echo $arg | grep /)" ]; then
      for i in $(echo $arg | sed 's/\// /g'); do
        dir+=$i*/
      done
    else
      for i in $(echo $arg | grep -o .); do
        dir+=$i*/
      done
    fi

    for i in $dir; do
      local cmd+=("$i")
    done
    if [ ${#cmd[@]} -eq 1 ]; then
      "$cmd"
    else
      select opt in "${cmd[@]}"; do
        [ -n "$opt" ] && "$opt" && break
      done
    fi

  fi
}

alias .b='. ~/.bashrc'
alias C=clear
alias c=clear
alias R=reset
alias r=reset
alias Q=exit
alias q=exit
alias :q=exit
alias Ls='ls --color=always'
alias ls='ls --color=never'
alias L='ls --color=alway -A'
alias Grep='grep --color=always'
alias grep='grep --color=never'
alias Diff='diff --color=always'
alias diff='diff --color=never'
alias Rf='rm -rf'
alias Rn='rename'

Retry () {
  local times=0
  ${@:2:$#}
  while [ $? -eq 1 ]; do
    if [ $times -le $1 ]; then
      ((times ++))
      ${@:2:$#}
    fi
  done
}

Rename () {
  rename -vn "$@"

  [ $? -ne 0 ] && return
  echo -en '\n\e[1;34m::\e[m \e[1mApply changes? [Y/n]\e[m '

  read opt
  case $opt in
    Y | y | '' )
      rename "$@";;
    N | n )
      : ;;
  esac
}

Find () {
  if   [ $# -eq 2 ]; then
    find "$1" -name "$2"
  elif [ $# -gt 2 ]; then
    local cmd="find $1 -name $2"
    for i in ${@:2:$#}; do
      cmd+=" -o -name $i"
    done
    $cmd
  else
    find ./ -name "*$1*"
  fi
}

Read () {
  local esc=$(echo -e '\e')
  if   [ $# -eq 2 ]; then
    for i in $(Find ${@:2:$#}); do
      grep -Pqs "$1" "$i"
      if [ $? -eq 0 ]; then
        grep --color=always -C 3 -P "$1" "$i"
        echo -e "${esc}[32m$i${esc}[0m"
      fi
    done
  else
    find ./ -name "*$1*"
  fi
}

 # android-tools ADB(Android Debug Bridge)
if [ -n "$(command -v adb)" ]; then
   alias Al='adb shell cmd package list packages'
   alias Alu='adb shell cmd package list packages -u'
   alias As='adb shell cmd package list packages | cut -f 2 -d : | grep'
   alias Asu='adb shell cmd package list packages -u | cut -f 2 -d : | grep'
   alias Ad='adb shell cmd package disable-user'
   alias Ae='adb shell cmd package enable'
   alias Ap='adb shell pm suspend'
   alias Aup='adb shell pm unsuspend'
   alias Au='adb shell cmd package uninstall --user 0'
   alias Ai='adb shell cmd package install-existing'
   alias Ar='adb shell reboot'
   alias Arr='adb shell reboot recovery'
   alias Arb='adb shell reboot bootloader'
fi
 # aria2
if [ -n "$(command -v aria2c)" ]; then
   alias Dld='aria2c -d ~/Download'
   alias Dlf='aria2c -o'
fi
 # FFmpeg
if [ -n "$(command -v ffmpeg)" ]; then
  alias ffm='ffmpeg -hide_banner'

  FFm () {
    [ -e "$1" ] || return
    local cmd
    if   [ $# -eq 4 ]; then
         [ -n "$2" ]   &&\
      cmd+=(-ss "$2")
         [ -n "$3" ]   &&\
      cmd+=(-to "$3")
      cmd+=(-i  "$1")
    elif [ $# -eq 2 ]; then
      cmd+=(-i "$1")
      [[ $2 = *.mp3 ]] &&\
      cmd+=(-b:a 312K)
      [[ $2 = *.mp4 ]] &&\
      cmd+=(-crf 23)
    elif [ $# -eq 3 ]; then
         [ -n "$2" ]   &&\
      cmd+=(-ss "$2" -i "$1")
      [[ $3 = *.png ]] &&\
      cmd+=(-vframes 1)
    fi
         [ $# -gt 1 ]  &&\
      cmd+=("${@: -1}")
    ffmpeg -hide_banner "${cmd[@]}"
  }
fi
 # pacman
if [ -n "$(command -v pacman)" ]; then
   alias pacman='pacman --color=auto'
   alias sP='sudo pacman --color=auto'
   alias Ps='sudo pacman -S'
   alias Sc='sudo pacman -Sc'
   alias Sg='pacman -Sg'
   alias Sgq='pacman -Sgq'
   alias Si='pacman -Si'
   alias Sl='pacman -Sl'
   alias Slq='pacman -Slq'
   alias Ss='pacman -Ss'
   alias Ssq='pacman -Ssq'
   alias Sy='sudo pacman -Sy'
   alias Syu='sudo pacman -Syu'
   alias Pf='pacman -F'
   alias Fq='pacman -Fq'
   alias Fl='pacman -Fl'
   alias Fx='pacman -Fx'
   alias Pq='pacman -Q'
   alias Qq='pacman -Qq'
   alias Qc='pacman -Qc'
   alias Qg='pacman -Qg'
   alias Qgq='pacman -Qgq'
   alias Qs='pacman -Qs'
   alias Qsq='pacman -Qsq'
   alias Qi='pacman -Qi'
   alias Ql='pacman -Ql'
   alias Qlq='pacman -Qlq'
   alias Qo='pacman -Qo'
   alias Qoq='pacman -Qoq'
   alias Qtdq='pacman -Qtdq'
   alias Qte='pacman -Qte'
   alias Qteq='pacman -Qteq'
   alias Pr='sudo pacman -R'
   alias Rc='sudo pacman -Rc'
   alias Rnus='sudo pacman -Rnus'
   alias cP='pacman -Q | wc -l'
  oQ () {
    list_binaries () {
      echo -e "\e[1m"
      echo $1
      echo -e "\e[1;32m"
      pacman -Qlq $1                       \
      | grep /usr/bin/.                    \
      | awk '{gsub("/", " "); print $NF}'  \
      | column
      echo -e "\e[0m"
    }

    for i in $@; do
      if [ -n "$(command -v $i)" ]; then
        list_binaries $(pacman -Qoq $i)
      else
        list_binaries $i
      fi
    done

  unset list_binaries
  }
  if [ -n "$(command -v pactree)" ]; then
     Pd  () {
       if [ -n "$2" ]; then
          local _depth="$2"
       else
          local _depth=1
       fi
       pactree -d "$_depth" "$1"
     }
     Pdr () {
       if [ -n "$2" ]; then
          local _depth="$2"
       else
          local _depth=1
       fi
       pactree -r -d "$_depth" "$1"
     }
  fi
fi
 # git
if [ -n "$(command -v git)" ]; then
   alias Ga='git add'
   alias Gm='git commit -m'
   alias Gp='git push'
   alias Gpl='git pull'
   alias Gcl='git clone'
   alias Gc='git checkout'
   alias Gb='git branch'
   alias Gs='git status'
   alias Gr='git reset'
   alias Gls='git ls-files'
   alias Grm='git rm'

  Gl () {
    local iro+='%C(yellow)'
    local iro+='%h'

    local iro+='	'

    local iro+='%Creset'
    local iro+='%C(bold)'
    local iro+='%s'

    local iro+=' '

    local iro+='%Creset'
    local iro+='%Cgreen'
    local iro+='%cr'

    local iro+=' '

    local iro+='%Creset'
    local iro+='%C(yellow)'
    local iro+='%D'

    local iro+=' '

    local iro+='%an'

    git log                   \
      --graph                 \
      --pretty=format:"$iro"  \
      --abbrev-commit         \
      $@
  }

  Gd  () {
    if [ -n "$(command -v diff-so-fancy)" ]; then
      git diff $@ | diff-so-fancy
    else
      git diff $@
    fi
  }

  GA  () {
    if [ $# -ge 1 ]; then
      git add $@
    else
      git add .
    fi
    git commit -m "Manually Save at $(date)"
  }

  GAM () { git add ${@:1:$#-1} && git commit -m "${@: -1}"; }
  GMA () { git add ${@:2:$#} && git commit -m "$1"; }
  GR  () { git reset --soft HEAD^; }
  GRM () { git reset --soft HEAD^ && git commit -m "$1"; }
fi
 # pip
if [ -n "$(command -v pip)" ]; then
   alias Pi='pip install --user'
   alias Pu='pip uninstall'
   alias Pc='pip freeze | wc -l'

  Pug () {
    local upgrade='pip install --user --upgrade'
    if [ -n "$(command -v pipdeptree)" ]; then
      $upgrade $(pipdeptree | grep -Eo '^[A-Za-z0-9-]+')
    else
      $upgrade $(pip freeze | grep -Eo '^[A-Za-z0-9-]+')
      pip check > /dev/null
      if [ $? -eq 1 ]; then
        $upgrade $(pip check | awk '{print $1}')
      fi
    fi
  }

  # pip completion --bash
  _pip_completion() {
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}"      \
                   COMP_CWORD=$COMP_CWORD             \
                   PIP_AUTO_COMPLETE=1 $1 2>/dev/null \
                )
    )
  }
  complete -o default -F _pip_completion pip

fi
 # vim
if [ -n "$(command -v vim)" ]; then
  Vsf () {
    local file=$@
    if [ $(readlink "$file") ]; then
     vim $(readlink "$file")
    else
     vim            "$file"
    fi
  }

   alias V=vim
   alias Vd='vimdiff'
   alias Vs='vim -S'
   alias Vb='Vsf ~/.bashrc'
   alias Vv='Vsf ~/.vimrc'
   alias Vt='Vsf ~/.tmux.conf'
   alias Vx='Vsf ~/.Xresources'
  Vw () { vim $(which $@); }
fi
 # tmux
if [ -n "$(command -v tmux)" ]; then
   alias Tn='tmux new -s'
   alias Tnw='tmux new -w'
   alias Tks='tmux kill-session -t'
   alias Tka='tmux kill-session -a'
   alias Tk='tmux kill-server'
   alias Tkw='tmux kill-window -t'
   alias Ta='tmux a'
fi

[[ -n "$(command -v youtube-dl)"              &&\
   -d ~/YouTube                          ]] &&\
   Yd () {
     youtube-dl                               \
       --write-auto-sub                       \
       --sub-lang 'cn,en'                     \
       -o '~/YouTube/%(title)s.%(ext)s'       \
       $@
   }

[[ -n "$(command -v mplayer)"              ]] &&\
  Play () {
    mplayer                                   \
            -fs                               \
            -vf screenshot                    \
            -nolirc                           \
            -quiet                            \
            "$@"                              \
    | grep --color=always                     \
           -P '(?<=Playing).*'
  }

# command-not-found on Arch Linux
[ -e /usr/share/doc/pkgfile/command-not-found.bash ] &&\
   . /usr/share/doc/pkgfile/command-not-found.bash
# bash-completion
[ -e /usr/share/bash-completion/bash_completion ] &&\
   . /usr/share/bash-completion/bash_completion

# flutter bash-completion
if type complete &>/dev/null; then
  __flutter_completion() {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           flutter completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F __flutter_completion flutter
elif type compdef &>/dev/null; then
  __flutter_completion() {
    si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 flutter completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef __flutter_completion flutter
elif type compctl &>/dev/null; then
  __flutter_completion() {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       flutter completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K __flutter_completion flutter
fi

# for TERMUX
if [[ $BASH = *termux* ]]; then
  ChFont2 () {
    if [ -e "$1" ]; then
      cp "$1"             ~/.termux/
      cp "$1"             ~/.termux/font.ttf
    else
      cp ~/.termux/*${1}* ~/.termux/font.ttf
    fi
    termux-reload-settings
  }

  ChColo2 () {
    if [ -e "$1" ]; then
      cp "$1"             ~/.termux/
      cp "$1"             ~/.termux/colors.properties
    else
      cp ~/.termux/*${1}* ~/.termux/colors.properties
    fi
    termux-reload-settings
  }

  [ -n "$(command -v startarch)" ] &&\
     alias Arc='startarch ul xian'

  [ -e $PREFIX/share/bash-completion/bash_completion ] &&\
     . $PREFIX/share/bash-completion/bash_completion
fi

# APT(Advanced Package Tool)
!  [ -n "$(command -v apt)" ] && return
if [ -n "$(command -v apt)" ]; then
   alias Ps='apt install'
   alias Sc='apt autoclean'
   alias Sl='apt -qq list'
   alias Sy='apt update'
   alias Syu='apt update && apt upgrade'
   alias Pq='apt -qq list --installed 2>/dev/null'
   alias Pr='apt remove'
   alias Rnus='apt autoremove'
   alias cP='apt -qq list --installed 2>/dev/null | wc -l'
   alias Qlq='dpkg -L'
   alias Pd='apt-cache depends'
   alias Pdr='apt-cache rdepends'

  Sg  () {
    apt -qq list                                \
    2>/dev/null                                 \
    | grep /$@                                  \
    | awk '{gsub("/", " "); print $2" "$1}'
  }

  Sgq () {
    apt -qq list                                \
    2>/dev/null                                 \
    | grep /$@                                  \
    | cut -f 1 -d /
  }

  Si  () {
    local esc=$(echo -e '\e')
    for i in $@; do
        apt -qq show $i                         \
        2>/dev/null                             \
        | sed "s/^\(.\)/${esc}[32m\1/g"         \
        | sed "s/: /${esc}[0m: /g"
    done
  }

  Slq () {
    apt -qq list $@                             \
    2>/dev/null                                 \
    | cut -f 1 -d /
  }

  Ss  () {
    if [ $# -eq 0 ]; then
      apt -qq search .                          \
      2>/dev/null
    else
      apt -qq search $@                         \
      2>/dev/null
    fi
  }

  Ssq () {
    apt -qq search $@                           \
    2>/dev/null                                 \
    | grep -v ^\                                \
    | cut -f 1 -d /
  }

  Qq  () {
    apt -qq list $@                             \
     --installed                                \
    2>/dev/null                                 \
    | cut -f 1 -d /
  }

  Qg  () {
    apt -qq list                                \
     --installed                                \
    2>/dev/null                                 \
    | grep /$@                                  \
    | awk '{gsub("/", " "); print $2" "$1}'
  }

  Qgq () {
    apt -qq list                                \
     --installed                                \
    2>/dev/null                                 \
    | grep /$@                                  \
    | cut -f 1 -d /
  }

  Qi  () {
    local esc=$(echo -e '\e')
    for i in $@; do
      apt -qq list $i                           \
       --installed                              \
      2>/dev/null                               \
      | grep installed                          \
       >/dev/null
      [ $? -eq 1 ] && return
      echo -e                                   \
        $(apt -qq show $i                       \
        2>/dev/null                             \
        | sed "s/^\(.\)/${esc}[32m\1/g"         \
        | sed "s/: /${esc}[0m: /g"              \
        | sed 's/$/\\n/g'                       \
        )                                       \
        ${esc}[32mRequired-By${esc}[0m:         \
        $(apt-cache rdepends $i                 \
         --installed                            \
        | grep '^  '                            \
        )                                       \
      | sed 's/^ //g'
    done
  }

  Ql  () {
    local esc=$(echo -e '\e')
    for i in $@; do
      dpkg -L $i                                \
      | sed "s/^/${esc}[32m$i${esc}[0m /g"
    done
  }

  Qs  () {
      apt -qq search $@                         \
      2>/dev/null                               \
      | grep -A 2 installed                     \
      | sed 's/\[installed.*\]//g'              \
      | sed '/--/d'                             \
      | sed 's/^\([.a-z0-9-]\+\)/[32m\1[0m/g'
  }

  Qsq () {
    apt -qq list                                \
     --installed                                \
    2>/dev/null                                 \
    | grep $@                                   \
    | cut -f 1 -d /
  }

  Qo  () {
    local esc=$(echo -e '\e')
    dpkg -S $(which $@)                         \
    | sed "s/^\(.*\):/${esc}[32m\1${esc}[0m/g"
  }

  Qoq () {
    dpkg -S $(which $@)                         \
    | cut -f 1 -d :
  }

  oQ  () {
    list_binaries () {
      echo -e "\e[1m"
      echo $1
      echo -e "\e[1;32m"
      dpkg -L $1                                \
      | grep /usr/bin/.                         \
      | sort                                    \
      | awk '{gsub("/", " "); print $NF}'       \
      | column
      echo -e "\e[0m"
    }

    for i in $@; do
      if [ -n "$(command -v $i)" ]; then
        list_binaries $(dpkg -S $(which $i)     \
                      | cut -f 1 -d :           \
        )
      else
        list_binaries $i
      fi
    done

    unset list_binaries
  }

fi



