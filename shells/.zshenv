typeset -U path
path=(
    ~/bin
    $GOPATH/bin
    ~/.cargo/bin
    ~/.composer/vendor/bin
    ~/.local/bin
    /opt/homebrew/bin
    /usr/local/bin
    /usr/local/sbin
    /usr/bin
    /usr/sbin
    /bin
    /sbin
)

typeset -U fpath
fpath=(
    /opt/homebrew/share/zsh/zsh-completions
    /opt/homebrew/share/zsh/site-functions
    $fpath
)

export CONTAINERS_MACHINE_PROVIDER=applehv
export GOPATH=$HOME/go
export JAVA_HOME=$(/usr/libexec/java_home)

export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
