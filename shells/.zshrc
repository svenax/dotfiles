autoload -U compinit && compinit
autoload -U zmv

# Plugins ======================================================================

export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh
zplugs=()

zplug 'zsh-users/zsh-syntax-highlighting'
zplug 'jeffreytse/zsh-vi-mode'
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
export EDITOR=code
export ZVM_VI_EDITOR=vim
export ZVM_VI_SURROUND_BINDKEY=s-prefix

export GOPATH=$HOME/go
export JAVA_HOME=$(/usr/libexec/java_home)

export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"

export _ZO_DATA_DIR=$XDG_DATA_HOME

# Aliases ======================================================================

alias '..'='cd ..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'

alias rg='rg -p'
alias rgpy='rg -tpy'
alias ls='ls -GFh'
alias ll='ls -l'
alias la='ls -a'
alias mkdir='mkdir -pv'

alias lg='lazygit'
alias docker='podman'

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

# Prompt etc. ==================================================================

eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
eval "$($(brew --prefix)/bin/starship init zsh)"

zvm_after_init() {
  # We must postpone this until after zvm has set itself up
  bindkey '^T' fzf-file-widget
  bindkey '^V' fzf-cd-widget
  # bindkey '^R' fzf-history-widget
}

# Work =========================================================================

ssh-add ~/.ssh/id_rsa_kvdbil > /dev/null 2>&1

export KVDBIL_REPO_BASE_DIR="$HOME/Develop/kvd"
export KUBE_DIR="$KVDBIL_REPO_BASE_DIR/kvd-kube"
export KVD_TOOLS="$KVDBIL_REPO_BASE_DIR/tools"

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

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

alias k9ss='k9s --context staging'
alias k9sp='k9s --context production'

dbproxys='cloud-sql-proxy --auto-iam-authn --private-ip gcp-development01:europe-north1:evergreen-staging -p 5432'
dbproxyp='cloud-sql-proxy --auto-iam-authn --private-ip gcp-production01:europe-north1:evergreen-production -p5433'
alias dbproxy='parallel --line-buffer --color ::: "$dbproxys" "$dbproxyp"'

sm-latest () {
  cd $KVDBIL_REPO_BASE_DIR/service-modules
  git fetch --tags -q
  git tag --list | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n 1
  cd -
}

# Added by Windsurf
export PATH="/Users/svenax/.codeium/windsurf/bin:$PATH"
