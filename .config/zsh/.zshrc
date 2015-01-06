for filename in $ZDOTDIR/{keybindings,commands,completion,prompt,options}.zsh; do
    source $filename
done
unset filename

#--- Modules -----------------------------------------------------------------

autoload -U zcalc

# Suffix aliases
autoload -U zsh-mime-setup
zsh-mime-setup

# Auto-quote urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

#--- Misc --------------------------------------------------------------------

source $ZSHPLUGINS/zsh-fuzzy-match/fuzzy-match.zsh

typeset -aU mailpath
mailpath=($HOME/Mail $mailpath)

export ACKRC=$XDG_CONFIG_HOME/ackrc
export BUNDLE_CONFIG=$XDG_CONFIG_HOME/bundler/config
export GIT_TEMPLATE_DIR=$XDG_CONFIG_HOME/git/template
export HTTPIE_CONFIG_DIR=$XDG_CONFIG_HOME/httpie
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npmrc
export INPUTRC=$XDG_CONFIG_HOME/inputrc
export NOTMUCH_CONFIG=$XDG_CONFIG_HOME/notmuch/config
export PIP_CONFIG_FILE=$XDG_CONFIG_HOME/pip/config
export TASKRC=$XDG_CONFIG_HOME/taskrc
export XINITRC=$XDG_CONFIG_HOME/xinitrc

export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/rc.py
export PYTHONDONTWRITEBYTECODE=true
export PYTHONWARNINGS='default,ignore:Not importing directory:ImportWarning'
# Specified relatively, so that we can find it in a venv if necessary.
export PYTHON_TEST_RUNNER=trial

if [[ "$(grep --version)" =~ "BSD" ]]; then
else
    GREP_OPTIONS='-IR --exclude-dir=.[a-zA-Z0-9]* --exclude=.* --color=auto'
fi

# Use Keychain for gpg-agent handling
if (( $+commands[keychain] )) && (( $+commands[gpg-agent] )); then
    eval $(keychain --eval --agents gpg --quick --quiet --inherit any id_rsa)
fi

if (( $+commands[berks] )); then
    export BERKSHELF_PATH=$XDG_DATA_HOME/berkshelf
fi

if (( $+commands[cpan] )); then
    export CPAN_OPTS="-I -j $XDG_CONFIG_HOME/cpan/Config.pm"
    export PERL_MB_OPT="--install_base '${PERL5LIB}'"
    export PERL_MM_OPT="INSTALL_BASE=${PERL5LIB}"
fi

# virtualenvwraper (needs to be sourced *after* the PATH is set correctly)
if (( $+commands[virtualenvwrapper_lazy.sh] )); then
    export WORKON_HOME=$XDG_DATA_HOME/virtualenvs
    export PROJECT_HOME=$DEVELOPMENT
    export VIRTUALENV_USE_SETUPTOOLS=true
    export PIP_VIRTUALENV_BASE=$WORKON_HOME
    source virtualenvwrapper_lazy.sh

    alias p='workon ${$(pwd):t}'
fi

#--- Named Directories -------------------------------------------------------

function zsh_directory_name() {
    if [[ $1 == n || $1 == c ]]; then
        # Search for a venv binary in the venv corresponding to the cwd
        local project=${$(pwd):t:l}
        local venv=$WORKON_HOME/$project/bin

        if [[ -d "$venv" ]]; then
            if [[ $1 == n ]]; then  # name -> directory
                typeset -ga reply
                reply=($venv/$2)
                return
            else                    # completion
                local expl
                local binaries
                _wanted dynamic-venv-bins expl 'dynamic venv binaries' _files -W "$venv" -S\]
                return
            fi
        fi
    else
        return 1
    fi
}

#--- Local -------------------------------------------------------------------

[[ -f $ZDOTDIR/.zshrc.local ]] && source $ZDOTDIR/.zshrc.local
