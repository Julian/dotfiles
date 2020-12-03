typeset -U path
path=(
    /opt/homebrew/bin
    /usr/local/bin
    /usr/local/sbin
    /usr/local/share/npm/bin
    ${GEM_HOME}/bin
    $path
)

local homebrew_prefix=$(brew --prefix)
path=(
    $HOME/.local/bin
    $homebrew_prefix/opt/coreutils/libexec/gnubin
    $homebrew_prefix/opt/findutils/libexec/gnubin
    $homebrew_prefix/opt/gnu-sed/libexec/gnubin
    $homebrew_prefix/opt/python@3.9/bin
    $homebrew_prefix/opt/python@3.8/bin
    $homebrew_prefix/opt/python@3.7/bin
    $homebrew_prefix/opt/util-linux/bin
    $path
)

[[ -d ~/.nix-profile/etc/profile.d/ ]] && source ~/.nix-profile/etc/profile.d/nix.sh

export DEVELOPMENT=$HOME/Development
(( $+commands[nvim] )) && export EDITOR=nvim || export EDITOR=vim
(( $+commands[bat] )) && export MANPAGER="sh -c 'col -bx | bat -l man -p'"

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
