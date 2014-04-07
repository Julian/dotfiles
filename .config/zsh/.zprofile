typeset -U path

if [[ "$OSTYPE" == darwin* ]] ; then
    path=(
        /usr/local/share/pypy
        ${gopath/%//bin}
        /usr/local/share/npm/bin
        $(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin
        $path
    )

    export RBENV_ROOT=/usr/local/var/rbenv
fi

path=(/usr/local/bin $HOME/.local/bin /usr/local/sbin $path)

if (( $+commands[keychain] )) ; then
    eval "$(rbenv init -)"
fi

export DEVELOPMENT=$HOME/Development
export EDITOR=vim
