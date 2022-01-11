export SAXON=/usr/local/bin/saxon
export GOPATH=$HOME/.local/share/go

typeset -U path
path=(
    ~/bin
    $GOPATH/bin
    ~/.composer/vendor/bin
    ~/.local/bin
    /Library/TeX/texbin
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

# eval "$(hub alias -s)"
# eval "$(pipenv --completion)"
