setopt NO_BEEP              # shh!
setopt EXTENDED_GLOB        # extended patterns support

# disable flow control
stty -ixon

source $ZSHPLUGINS/zsh-fuzzy-match/fuzzy-match.zsh

#--- Modules -----------------------------------------------------------------

autoload -U zcalc

# Suffix aliases
autoload -U zsh-mime-setup
zsh-mime-setup

# Auto-quote urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic


if [[ -n $SSH_CONNECTION ]] ; then
    KEYTIMEOUT=15
else
    KEYTIMEOUT=5
fi


for filename in $ZDOTDIR/{keybindings,completion,prompt,options}.zsh; do
    source $filename
done
unset filename

#--- Aliases -----------------------------------------------------------------

alias di=diff

# ss<x> aliases:
# t: tmux attach
# x: X11 forwarding with WindowID, useful for e.g. forwarding vim clipboards
function sst() { ssh -t $@ 'tmux attach || tmux' }
alias ssx='ssh -X -o "SendEnv WINDOWID"'

if (( $+commands[brew] )); then
    alias brew='GREP_OPTIONS= brew'
    alias up="brew update --rebase && brew upgrade"
fi

if (( $+commands[selecta] )); then
    alias v='vim $(find . -type f | selecta)'
fi

if (( $+commands[weechat-curses] )); then
    alias weechat="weechat-curses -d $XDG_CONFIG_HOME/weechat"
fi

# Suffix Aliases
alias -s tex=vim

# noglobs
alias find='noglob find'
alias git='noglob git'

alias sed="sed -E"

if ls --color &> /dev/null; then
    alias ls='ls --color=auto --human-readable --group-directories-first'
else
    alias ls='ls -Gh'
fi

if (( $+commands[ag] )); then
    AG_OPTIONS='--smart-case'
    alias ag="noglob ag $AG_OPTIONS"

    # Find the pattern in tests / not in tests
    alias agg="ag --ignore '*test*'"
    alias agp="ag --ignore '*test*' -G '\.py'"
    alias agt="ag -G '\btests?\b'"
    alias agtp="ag -G '\btests?\b.*\.py'"
fi

if (( $+commands[dircolors] )); then
    eval $( dircolors -b $XDG_CONFIG_HOME/dircolors )
fi

if (( $+commands[fasd])); then
    export _FASD_DATA=$XDG_DATA_HOME/fasd/fasd
    export _FASD_VIMINFO=$XDG_CACHE_HOME/vim/info
    eval "$(fasd --init auto)"
fi

function cdd() { cd *$1*/ } # stolen from @garybernhardt stolen from @topfunky
function cdc() { cd **/*$1*/ }


# This was written entirely by Michael Magnusson (Mikachu)
# Type '...' to get '../..' with successive .'s adding /..
function _rationalise-dot() {
  local MATCH MBEGIN MEND
  if [[ $LBUFFER =~ '(^|/| |	|'$'\n''|\||;|&)\.\.$' ]]; then
    LBUFFER+=/
    zle self-insert
    zle self-insert
  else
    zle self-insert
  fi
}

zle -N _rationalise-dot
bindkey . _rationalise-dot

# without this, typing a . aborts incremental history search
bindkey -M isearch . self-insert

disable r

# Disable the shell reserved word time if a binary is present
if (( $+commands[time] )); then
    disable -r time
fi


# tmux helpers
function :sp () { tmux split-window }
function :Sp () { tmux split-window }
function :vsp () { tmux split-window -h }
function :Vsp () { tmux split-window -h }

#--- Misc --------------------------------------------------------------------

typeset -aU mailpath
mailpath=($HOME/Mail $mailpath)

export DEVELOPMENT=$HOME/Development

export ACKRC=$XDG_CONFIG_HOME/ackrc
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
export PYTHONWARNINGS=default
# Specified relatively, so that we can find it in a venv if necessary.
export PYTHON_TEST_RUNNER=trial

if [[ "$(grep --version)" =~ "BSD" ]]; then
else
    GREP_OPTIONS='-IR --exclude-dir=.[a-zA-Z0-9]* --exclude=.* --color=auto'
fi

# Use Keychain for ssh-agent handling
if (( $+commands[keychain] )) ; then
    eval $(keychain --eval --agents ssh -Q --quiet id_ecdsa)
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

# Run tests on current directory in a corresponding venv, otherwise globally
function t() {
    emulate -L zsh
    unsetopt NO_MATCH

    local project=${"$(basename $(pwd))":l}
    local venv_runner=~[$PYTHON_TEST_RUNNER]
    if [[ -f "$venv_runner" ]]; then
        $venv_runner $@ $project
    else
        $PYTHON_TEST_RUNNER $@ $project
    fi
}

#--- Named Directories -------------------------------------------------------

function zsh_directory_name() {
    # Search for a venv binary in the venv corresponding to the cwd
    local project=${"$(basename $(pwd))":l}
    local venv=$WORKON_HOME/$project/bin
    if [[ -d "$venv" ]]; then
        typeset -ga reply
        reply=($venv/$2)
    else
        return 1
    fi
}

#--- Local -------------------------------------------------------------------

[[ -f $ZDOTDIR/.zshrc.local ]] && source $ZDOTDIR/.zshrc.local
