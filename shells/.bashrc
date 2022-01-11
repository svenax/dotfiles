# Configurations =============================================================

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export DISPLAY=:0
export CLICOLOR=1
export COLORTERM=yes
export TERM=xterm-256color

export HISTTIMEFORMAT="%F %T> "
export HISTCONTROL=ignorboth:erasedups
export HISTIGNORE="ls:ll:la:history*"
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend
shopt -s cmdhist

export EDITOR=code -nw
export PAGER=less

# Applications
export JAVA_HOME=$(/usr/libexec/java_home)
export XML_CATALOG_FILES=/usr/local/etc/xml/catalog

# Passwords and stuff. Not included in the repo!
source ~/dotfiles/private

# Paths ======================================================================

# First use an array for path components.
# Makes it easier to build a long PATH this way.
# Remember that the order here is important
paths=(
    '~/bin'
    '/usr/texbin'
    '/usr/local/bin'
    '/usr/local/sbin'
    '/usr/bin'
    '/usr/sbin'
    '/bin'
    '/sbin'
    '/opt/X11/bin'
)
PATH=$(printf ":%s" "${paths[@]}")
PATH=${PATH:1} # Remove leading colon
export PATH
unset paths    # Not needed anymore

cdpaths=(
    '.'
    '~/dotfiles'
    '/Sources/Work'
    '/Sources/Svenax/PHP'
    '/Sources/Svenax/C'
)

CDPATH=$(printf ":%s" "${cdpaths[@]}")
CDPATH=${CDPATH:1} # Remove leading colon
export CDPATH
unset cdpaths    # Not needed anymore

# Aliases ====================================================================

alias ag='ag --pager "less -R"'
alias ls='ls -F'
alias ll='ls -lh'
alias la='ls -ah'
alias lf='find . -name'

alias ssudo="echo $PASSWORD_SECRET|sudo -p '' -kS"

alias brewup='brew update && echo -e "==> \033[1mOutdated brews\033[0m" && brew outdated'

alias assistant="$(brew --prefix qt5)/Assistant.app/Contents/MacOS/Assistant"
alias qthelp="$(brew --prefix qt5)/Assistant.app/Contents/MacOS/Assistant -collectionFile"

# Functions ==================================================================

function capture() {
    sudo dtrace -p "$1" -qn '
        syscall::write*:entry
        /pid == $target && arg0 == 1/ {
            printf("%s", copyinstr(arg1, arg2));
        }
    '
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

# External scripts ===========================================================

eval "$(starship init bash)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
