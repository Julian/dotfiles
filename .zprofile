typeset -U path

if [[ "$OSTYPE" == darwin* ]]
then
    path=(/usr/local/share/python /usr/local/share/pypy /usr/local/share/python3 /usr/local/share/npm/bin $HOME/.rvm/bin $(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin $path)
fi

path=(/usr/local/bin $HOME/.local/bin /usr/local/sbin $path)

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export EDITOR="vim"
