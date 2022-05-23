# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/bash_profile.pre.bash"
. $HOME/.bashrc

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
if [ -f /Source/PHP/phake/phake_completion.sh ]; then
  . /Source/PHP/phake/phake_completion.sh
fi
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

. "$HOME/.cargo/env"

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/bash_profile.post.bash"
