#--- Aliases -----------------------------------------------------------------

alias d='g d --no-index'
alias m='mv -iv'
alias n=nvim
alias p='noglob parallel --tag --timeout 5 --progress --nonall --sshlogin - $@'

# ss<x> aliases:
# p: ssh more suitable for mass parallelizing
# t: tmux attach
# x: X11 forwarding with WindowID, useful for e.g. forwarding vim clipboards
function ssp() {
    parallel --nonall --sshlogin $@
}
function sst() {
    ssh -t $@ '$SHELL -l -c "tmux attach || tmux"'
}
alias ssx='ssh -X -o "SendEnv WINDOWID"'

# SSH SOCKS Proxy
function tunnel() {
    local tunnel_host=${tunnel_host:-pi.grayvines.com}
    local tunnel_port=${tunnel_port:-8080}
    networksetup -setsocksfirewallproxystate Wi-Fi on
    printf 'Tunneling to %s:%s...\n' $tunnel_port $tunnel_host
    ssh -D $tunnel_port -C -N $tunnel_host
    networksetup -setsocksfirewallproxystate Wi-Fi off
}


if (( $+commands[brew] )); then
    alias brew='GREP_OPTIONS= brew'
    alias up="brew update && brew upgrade"
elif (( $+commands[nix-env] )); then
    alias up="nix-channel --update nixpkgs && nix-env -u '*'"
elif (( $+commands[pacman] )); then
    alias up="sudo pacman -Syu"
fi

if (( $+commands[selecta] )); then
    alias v=$EDITOR' $(find . -type f | selecta)'

    function insert-selecta-path-in-command-line() {
        # Copied from https://github.com/garybernhardt/selecta/blob/master/EXAMPLES.md
        local selected_path
        echo
        selected_path=$(find . -type f | selecta) || return
        eval 'LBUFFER="$LBUFFER$selected_path "'
        zle reset-prompt
    }
    zle -N insert-selecta-path-in-command-line

    bindkey "^S" insert-selecta-path-in-command-line
fi

if (( $+commands[weechat-curses] )); then
    alias weechat="weechat-curses -d $XDG_CONFIG_HOME/weechat"
fi

# Suffix Aliases
alias -s tex=vim

# Try to get myself to stop typing fg; stop putting it in the history
alias fg=' fg'

# noglobs
alias find='noglob find'
alias parallel='noglob parallel'
alias pip='noglob pip'

# git convenience
alias g='noglob git'
alias git='noglob git'
alias dev='git checkout develop'
alias master='git checkout master'

alias sed="sed -E"

if ls --color &> /dev/null; then
    alias ls='ls --color=auto --human-readable --group-directories-first'
else
    export CLICOLOR=true
    alias ls='ls -h'
fi

if (( $+commands[rg] )); then
    alias prg='parallel"" -X rg'

    # Find the pattern in tests / not in tests
    alias rgg="rg --ignore '*test*'"
    alias rgp="rg --ignore '*test*' --python"
    alias rgt="rg -G '\btests?\b'"
    alias rgpt="rg -G '\btests?\b.*\.py'"
fi

if (( $+commands[dircolors] )); then
    eval $( dircolors -b $XDG_CONFIG_HOME/dircolors )
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

# Print a Python str
function pp() {
    python -c "print '${@:gs/'/\\'}'"
}

# Bootstrap some development tools into an environment.
PYTHON_DEV_PACKAGES=(bpython'[urwid]' ptpython pudb twisted)
function pydev() {
    set -u
    "$(findenv directory $PWD python)" -m pip install -U $PYTHON_DEV_PACKAGES $@
}

# Open a REPL for a virtualenv
function r() {
    if [[ $# == 0 ]]; then
        local repl=$(findenv directory "$PWD" ptpython)
    else
        local repl=$(findenv name $@ ptpython)
    fi
    PYTHONPATH=. $repl
}

# Run tests on current directory in a corresponding venv, otherwise globally
function t() {
    local venv_runner=$(findenv directory $PWD $PYTHON_TEST_RUNNER)
    # This is shell gobbledigook for "does every arg start with -"
    if [[ ${@[(i)^-*]} -gt $# ]]; then
        argv+=("${venv_runner:h:h:t}")
    fi
    PYTHONPATH=. $venv_runner ${@:1}
}
