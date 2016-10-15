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
    $HOME/.local/bin
    /usr/local/bin
    /usr/local/sbin
    ${GEM_HOME}/bin
    ${gopath/%//bin}
    $path
)

export DEVELOPMENT=$HOME/Development
(( $+commands[nvim] )) && export EDITOR=nvim || export EDITOR=vim

[[ -d $DEVELOPMENT ]] && export IS_DEVELOPMENT_WORKSTATION=yup

cdpath=(${DEVELOPMENT} ${XDG_DESKTOP_DIR} ${HOME} $cdpath)

perl_home=$XDG_DATA_HOME/perl5
if perl -I$perl_home/lib/perl5 -mlocal::lib -e1 2>/dev/null; then
    eval "$(perl -I$perl_home/lib/perl5 -Mlocal::lib=$perl_home 2>/dev/null)"
else
    alias set-up-cpanm="curl -L https://cpanmin.us | vipe | perl - -l '$perl_home' local::lib App::cpanminus"
fi
