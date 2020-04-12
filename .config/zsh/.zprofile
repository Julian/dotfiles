typeset -U path
path=(
    $HOME/.local/bin
    /usr/local/opt/coreutils/libexec/gnubin
    /usr/local/opt/findutils/libexec/gnubin
    /usr/local/opt/gnu-sed/libexec/gnubin
    /usr/local/opt/python@3.8/bin
    /usr/local/bin
    /usr/local/sbin
    /usr/local/share/npm/bin
    ${GEM_HOME}/bin
    $path
)

[[ -d ~/.nix-profile/etc/profile.d/ ]] && source ~/.nix-profile/etc/profile.d/nix.sh

export DEVELOPMENT=$HOME/Development
(( $+commands[nvim] )) && export EDITOR=nvim || export EDITOR=vim

[[ -d $DEVELOPMENT ]] && export IS_DEVELOPMENT_WORKSTATION=yup

cdpath=(
    ${DEVELOPMENT}
    ${XDG_DESKTOP_DIR}
    ${HOME}
    ${HOME}/.local/share/repositories
    $cdpath
)

perl_home=$XDG_DATA_HOME/perl5
if perl -I$perl_home/lib/perl5 -mlocal::lib -e1 2>/dev/null; then
    eval "$(perl -I$perl_home/lib/perl5 -Mlocal::lib=$perl_home 2>/dev/null)"
else
    alias set-up-cpanm="curl -L https://cpanmin.us | vipe | perl - -l '$perl_home' local::lib App::cpanminus"
fi
