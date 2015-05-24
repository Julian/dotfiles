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

if (( $+commands[berks] )); then
    export BERKSHELF_PATH=$XDG_DATA_HOME/berkshelf
fi

if (( $+commands[cpan] )); then
    export CPAN_OPTS="-I -j $XDG_CONFIG_HOME/cpan/Config.pm"
    export PERL_MB_OPT="--install_base '${PERL5LIB}'"
    export PERL_MM_OPT="INSTALL_BASE='${PERL5LIB}'"
fi

#--- Named Directories -------------------------------------------------------

function zsh_directory_name() {
    case "$1" in
        n)  # Run a venv binary in a corresponding venv
            if [[ $2 =~ '([^:]+):([^:]+)' ]]; then  # foo:bar is venv foo, bin bar
                local binary=$(findenv --existing-only --name "$match[1]" "$match[2]")
            else
                local binary=$(findenv --existing-only --directory . "$2")
            fi

            typeset -ga reply
            reply=($binary)
            return
            ;;

        c)  # Completion
            # FIXME: Probably refactor, but here we allow foo:<nothing>, and
            #        also this doesn't pre-filter whatever is there already
            if [[ $2 =~ '([^:]+):([^:]*)' ]]; then
                local venv=$(findenv --existing-only --name "$match[1]")
            else
                local venv=$(findenv --existing-only --directory .)
            fi

            # FIXME: if you have ~[pip]<TAB>, zsh seems to do the wrong
            #        thing with this (it doesn't expand to the directory)
            local expl
            _wanted dynamic-venv-bins expl 'dynamic venv binaries' _files -g '*(*)' -W "$venv/bin" -S\]
            return
            ;;

        *)
            return 1
    esac
}

#--- Local -------------------------------------------------------------------

[[ -f $ZDOTDIR/.zshrc.local ]] && source $ZDOTDIR/.zshrc.local
