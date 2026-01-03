# ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"

DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

spaceship() {
    ZSH_THEME="spaceship"
    # git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
    # ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    SPACESHIP_PROMPT_ASYNC=true
    SPACESHIP_PROMPT_ADD_NEWLINE=true
    SPACESHIP_PROMPT_ORDER=(
        user
        dir
        git
        line_sep
        char
    )
};spaceship;unset spaceship

plugins+=(git)
plugins+=(zsh-autosuggestions)
    # git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
    ZSH_AUTOSUGGEST_USE_ASYNC=1
plugins+=(zsh-syntax-highlighting)
    # git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source $ZSH/oh-my-zsh.sh

[[ -d ~/.bash ]] &&\
for i in ~/.bash/*; do
  source "$i";
done
