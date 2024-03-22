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
export PAGER=less

export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_BUNDLE_FILE=~/Brewfile

export ALTERNATE_EDITOR=
export EDITOR=(code -nw)
export ZVM_VI_EDITOR=vim
export ZVM_VI_SURROUND_BINDKEY=s-prefix

export GOPATH=$HOME/go
export JAVA_HOME=$(/usr/libexec/java_home)

export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

export _ZO_DATA_DIR=$XDG_DATA_HOME

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Aliases ======================================================================

alias '..'='cd ..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

alias rg='rg -p'
alias ls='ls -GF'
alias ll='ls -l'
alias la='ls -a'
alias mkdir='mkdir -pv'

alias lg='lazygit'

alias brewup='brew update && brew outdated'
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$($(brew --prefix)/bin/starship init zsh)"
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
[ -f ~/.iterm2_shell_integration.zsh ] && source ~/.iterm2_shell_integration.zsh
fi

# [ -f "$HOME/.rye/env" ] && source "$HOME/.rye/env"

zvm_after_init() {
  # We must postpone this until after zvm has set itself up
  bindkey '^T' fzf-file-widget
  bindkey '^V' fzf-cd-widget
  bindkey '^R' fzf-history-widget
}

# Work =========================================================================

ssh-add ~/.ssh/id_rsa_kvdbil > /dev/null 2>&1

export KVDBIL_REPO_BASE_DIR="$HOME/Develop/kvd"
export KUBE_DIR="$KVDBIL_REPO_BASE_DIR/kvd-kube"
export KVD_TOOLS="$KVDBIL_REPO_BASE_DIR/tools"

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="$HOME/.pyenv"

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

[ -f ~/google-cloud-sdk/path.zsh.inc ] && source ~/google-cloud-sdk/path.zsh.inc
[ -f ~/google-cloud-sdk/completion.zsh.inc ] && source ~/google-cloud-sdk/completion.zsh.inc

eval "$(kubectl completion zsh)"
alias kc='kubectl'

alias kca='kubectl apply -f'
alias kcn='kubectl -n kube-system'
alias kcp='kubectl get pods -L tag'
alias kcl='kubectl logs -f'
alias kcu='kubectl config use-context'
alias kcc='kubectl config current-context'

compdef __start_kubectl kc

# eval "$(kontrol completion)"

kc-rollout () {
  kc rollout restart deployment/$2 --context=$1
  kc rollout status deployment/$2 --context=$1
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
    export SPARKPOST_API_KEY=''
    export FLASK_APP=$SERVICE_NAME
    export SQLALCHEMY_DATABASE_URI=$DATABASE_URI
    export FLASK_APP=$SERVICE_NAME echo $FLASK_APP
    if [ "$2" = create ]; then
      CREATE_DB_COMMAND="create database ${SERVICE_NAME}_migrations"
      podman exec -ti service-database psql -U postgres -c $CREATE_DB_COMMAND
    fi
  fi

  if ! { [ "$1" = db ] && [ "$2" = create ] } then
    command flask "$@";
  fi
}

prepare () {
  pyenv uninstall -f $(cat .python-version) && pyenv virtualenv 3.9.13 $(cat .python-version)
  pyenv activate $(cat .python-version)
  pip install -U pip pip-tools
  rm requirements.txt
  pip-compile --resolver=backtracking
  pip install -r requirements.txt
}

# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
# source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
