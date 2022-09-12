# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
autoload -U compinit && compinit
autoload -U zmv

# Plugins ======================================================================

export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh
zplugs=()

zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'jeffreytse/zsh-vi-mode'
zplug 'agkozak/zsh-z'
zplug check || zplug install
zplug load

# Configuration ================================================================

# Passwords and stuff. Not included in the repo!
[ -f ~/dotfiles/secret/private ] && source ~/dotfiles/secret/private

setopt AUTO_LIST
setopt AUTO_MENU
setopt CD_SILENT
setopt EXTENDED_HISTORY
setopt HIST_EXPAND
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt LIST_PACKED
setopt NO_BEEP
setopt PROMPT_SUBST
setopt SHARE_HISTORY

stty stop undef
zle_highlight=('paste:none')

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select=0
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories path-directories'
zstyle ":completion:*:descriptions" format "%B--- %d%b"
zstyle ':completion:*' group-name ''

HIST_STAMPS="yyyy-mm-dd"
HISTSIZE=10000
SAVEHIST=50000

alias hh=hstr
export HISTFILE=~/.zsh_history
export HH_CONFIG=hicolor

export DISPLAY=:0
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_COLLATE=se_SV.UTF-8
export LC_CTYPE=se_SV.UTF-8
export CLICOLOR=1
export LSCOLORS="gxfxcxdxbxegedabagacad"
export PAGER=bat
export BAT_THEME="Solarized (light)"

export COMPOSE_FILES
export GROOVY_HOME=/opt/homebrew/opt/groovy/libexec
export JAVA_HOME=$(/usr/libexec/java_home)
export XML_CATALOG_FILES=/usr/local/etc/xml/catalog

export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_BUNDLE_FILE=~/Brewfile

export ALTERNATE_EDITOR=''
export EDITOR='code -nw'
export ZVM_VI_EDITOR=vim
export ZVM_VI_SURROUND_BINDKEY=s-prefix

export ZSHZ_DATA=~/.cache/zshz/data

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# Aliases ======================================================================

alias '..'='cd ..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

alias rg='rg -p'
alias ls='ls -GF'
alias ll='ls -l'
alias la='ls -a'
alias gl='glances --theme-white'
alias mkdir='mkdir -pv'

alias brewup='brew update && echo -e "==> \033[1mOutdated brews\033[0m" && brew outdated'
alias brewug='brew upgrade && brew upgrade --cask'

alias -g G='|rg'
alias -g L='|less -R'
alias -g NULL='> /dev/null 2>&1'

# Functions ===================================================================

function touchp() {
  mkdir -p $(dirname "${1}") && touch "${1}"
}

function rp() {
  rg "$@" | less -FRX
}

# Copy my public key to a server via SSH
function ssh-copykey() {
  if [[ -z "$1" ]]; then
    echo "You need to enter a hostname in order to send your public key."
  else
    echo "* Copying SSH public key to server..."
    ssh ${1} "mkdir -p ~/.ssh && cat - >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub
    echo "* All done."
  fi
}

# cd to the brew directory of the given package
function cdbrew() {
  cd $(brew --prefix $1)
}

# Kill processes listening to the given port
function killport() {
  lsof -t -i TCP:$1 -s TCP:LISTEN | xargs kill -9
}

# Prompt etc. ==================================================================

eval "$($(brew --prefix)/bin/starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
bindkey '^T' fzf-file-widget
bindkey '^V' fzf-cd-widget
bindkey '^R' fzf-history-widget

[ -f ~/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh

 export NVM_DIR="$HOME/.nvm"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

# Work =========================================================================

ssh-add ~/.ssh/id_rsa_kvdbil

export KVDBIL_REPO_BASE_DIR="$HOME/Develop/kvd"
export KUBE_DIR="$KVDBIL_REPO_BASE_DIR/kvd-kube"
export KVD_TOOLS="$KVDBIL_REPO_BASE_DIR/tools"

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="$HOME/.pyenv"

alias -g ovpn='sudo openfortivpn -c ~/.config/openfortivpn/config'

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

[ -f ~/google-cloud-sdk/path.zsh.inc ] && source ~/google-cloud-sdk/path.zsh.inc
[ -f ~/google-cloud-sdk/completion.zsh.inc ] && source ~/google-cloud-sdk/completion.zsh.inc

path+=($KUBE_DIR $PYENV_ROOT/bin ~/Library/Application\ Support/multipass/bin)

# Add completion for kontrol
source <(kubectl completion zsh)
# source <(kontrol completion)

# Convenient alias for kubectl
alias kc='kubectl'
compdef __start_kubectl kc

# Use stern instead of kubetail, it is nicer
kt () {
  stern $@ -t
}

kc-bidding-fee () {
   kc exec --context=production -it deployment/auction -- flask update-bidding-fee --fee $1 --process_object_id $2
   kc exec --context=production -it deployment/process-object -- flask update-bidding-fee --fee $1 --process_object_id $2
}

kc-start-bid () {
   kc exec --context=production -it deployment/auction -- flask update-start-bid --start_bid $1 --process_object_id $2
}

# Alias for flask command with set environment variables
flask-local () {
  if [[ $(basename "$PWD") == *"-service" ]] then
    export SERVICE_NAME=$(basename "$PWD" | sed -e "s/-service//" | sed "s/-/_/g")
    export DATABASE_URI="postgresql://postgres@servicedatabase01.dev.local/${SERVICE_NAME}_migrations"
    export EVENT_PRODUCER_DB_URI=''
    export BROKER_URI=''
    export FLASK_APP=$SERVICE_NAME
    export SQLALCHEMY_DATABASE_URI=$DATABASE_URI
    export FLASK_APP=$SERVICE_NAME echo $FLASK_APP
    if [ "$2" = create ]; then
      CREATE_DB_COMMAND="create database ${SERVICE_NAME}_migrations"
      docker exec -ti service-database psql -U postgres -c $CREATE_DB_COMMAND
    fi
  fi

  if ! { [ "$1" = db ] && [ "$2" = create ] } then
    command flask "$@";
  fi
}

prepare () {
  pyenv uninstall -f $(cat .python-version) && pyenv virtualenv 3.9.11 $(cat .python-version)
  pip install -U pip pip-tools
  rm requirements.txt
  pip-compile
  pip install -r requirements.txt
}

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
