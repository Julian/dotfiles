typeset -U path

if [[ "$OSTYPE" == darwin* ]] ; then
    path=(
        /usr/local/share/pypy
        /usr/local/share/pypy3
        ${gopath/%//bin}
        /usr/local/share/npm/bin
        $(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin
        $path
    )
fi

path=(/usr/local/bin $HOME/.local/bin /usr/local/sbin $path)

export DEVELOPMENT=$HOME/Development
export EDITOR=vim

cdpath=($cdpath ${DEVELOPMENT} ${HOME}/Desktop)
