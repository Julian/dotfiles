for filename in $ZDOTDIR/{options,completion,keybindings,commands,prompt}.zsh; do
    source $filename
done
unset filename

#--- Modules -----------------------------------------------------------------

autoload -U zcalc

#--- Misc --------------------------------------------------------------------

export CTAGS="--exclude=@$XDG_CONFIG_HOME/git/ignore"
export BUNDLE_CONFIG=$XDG_CONFIG_HOME/bundler/config
export GIT_TEMPLATE_DIR=$XDG_CONFIG_HOME/git/template
export HTTPIE_CONFIG_DIR=$XDG_CONFIG_HOME/httpie
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npmrc
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
export INPUTRC=$XDG_CONFIG_HOME/inputrc
export NOTMUCH_CONFIG=$XDG_CONFIG_HOME/notmuch/config
export PERL_CPANM_HOME=$XDG_CACHE_HOME/cpanm
export PIP_CONFIG_FILE=$XDG_CONFIG_HOME/pip/config
export TASKRC=$XDG_CONFIG_HOME/taskrc

export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/rc.py
export PYTHONDONTWRITEBYTECODE=true
export PYTHONWARNINGS="default,\
ignore:Not importing directory:ImportWarning,\
ignore:can't resolve package from __spec__ or __package__:ImportWarning,\
ignore:DEPRECATION::pip._internal.cli.base_command\
"
# Specified relatively, so that we can find it in a venv if necessary.
export PYTHON_TEST_RUNNER=trial

export GPG_TTY=$(tty)

if [[ "$(grep --version)" =~ "BSD" ]]; then
else
    GREP_OPTIONS='-IR --exclude-dir=.[a-zA-Z0-9]* --exclude=.* --color=auto'
fi

#--- Named Directories -------------------------------------------------------

typeset -A _memoized_venv_paths

function zsh_directory_name() {
    # Evade zsh-syntax-highlighting, which seems to call us twice when
    # typing the closing ], and another 2 times when hitting enter, and
    # worse, 2 times for each character typed on the line :(
    [[ "$functrace" = _zsh_highlight* ]] && return 1

    local binary=$_memoized_venv_paths[$@]

    case "$1" in
        n)  # Run a venv binary in a corresponding venv
            if [[ -z "$binary" ]]; then
                if [[ $2 =~ '([^:]+):([^:]+)' ]]; then  # foo:bar is venv foo, bin bar
                    local binary=$(venvs find --existing-only name "$match[1]" "$match[2]")
                else
                    local binary=$(venvs find --existing-only directory $PWD "$2")
                fi

                _memoized_venv_paths[$@]=$binary
            fi

            typeset -ga reply
            reply=($binary)
            return
            ;;

        c)  # Completion
            # FIXME: Probably refactor, but here we allow foo:<nothing>, and
            #        also this doesn't pre-filter whatever is there already
            if [[ $2 =~ '([^:]+):([^:]*)' ]]; then
                local venv=$(venvs find --existing-only name "$match[1]")
            else
                local venv=$(venvs find --existing-only directory $PWD)
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

[ -d $ZDOTDIR/zshrc.d/ ] && for file in $ZDOTDIR/zshrc.d/*.zsh(N); do
    source $file
done
