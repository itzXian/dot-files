# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.zshrc

# Debug startup time of zsh, put this command at the top
zmodload zsh/zprof

DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
ZSH_DISABLE_COMPFIX="true"

zsh_theme () {
    # git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    ZSH_THEME="powerlevel10k/powerlevel10k"
    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
}; zsh_theme; unset zsh_theme;

export ZSH="$HOME/.oh-my-zsh"
plugins+=(git)
plugins+=(zsh-autosuggestions)
    # git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
    ZSH_AUTOSUGGEST_USE_ASYNC=1
plugins+=(zsh-syntax-highlighting)
    # git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh

# Set up fzf key bindings and fuzzy completion
if [ -n "$(command -v fzf)" ]; then
    source <(fzf --zsh)
fi

if [ -d ~/.bash ]; then
    for i in ~/.bash/*; do
        source "$i";
    done
fi

# Debug startup time of zsh, put this command at the bottom,
#zprof
# or manually print startup time of zsh
#time zsh -i -c zprof
