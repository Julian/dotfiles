typeset -U path

if [[ "$OSTYPE" == darwin* ]] ; then
    path=(
        /usr/local/share/pypy
        /usr/local/share/pypy3
        /usr/local/share/npm/bin
        $(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin
        $path
    )
fi

path=(
    /usr/local/bin
    $HOME/.local/bin
    /usr/local/sbin
    ${GEM_HOME}/bin
    ${gopath/%//bin}
    ${perl_local_lib_root/%//bin}
    $path
)

export DEVELOPMENT=$HOME/Development
export EDITOR=vim

[[ -d $DEVELOPMENT ]] && export IS_DEVELOPMENT_WORKSTATION=yup

cdpath=(${DEVELOPMENT} ${XDG_DESKTOP_DIR} ${HOME} $cdpath)
