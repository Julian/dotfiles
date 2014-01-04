typeset -U path

if [[ "$OSTYPE" == darwin* ]]
then
    path=(
        /usr/local/share/pypy
        ${gopath/%//bin}
        /usr/local/share/npm/bin
        $HOME/.rvm/bin
        $(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin
        $path
    )
fi

path=(/usr/local/bin $HOME/.local/bin /usr/local/sbin $path)

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export DEVELOPMENT=$HOME/Development
export EDITOR=vim
