#--- Aliases -----------------------------------------------------------------

alias b=bat
alias d='g d --no-index'
alias m='mv -iv'
alias n=$EDITOR
alias p='noglob parallel --tag --timeout 5 --progress --nonall --sshlogin - $@'

# Stick a file into a directory named after it.
function box() {
    mkdir "${1:r}" && mv -nv "$1" "${1:r}"
}

# Remove an empty directory, but consider it empty even if it contains some
# common junk.
function bye() {
    rm -f $1/.DS_Store
    rmdir $@ || printf "\nContents:\n%s\n" "$(ls -A $1)"
}

function filter() { rg -v "^$@$" }

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
compdef _hosts ssp sst ssx

function randomize-mac() {
    openssl rand -hex 6 | /usr/bin/sed 's/\(..\)/\1:/g; s/.$//' | xargs sudo ifconfig en0 ether
}

# SSH SOCKS Proxy
function tunnel() {
    local tunnel_host=${tunnel_host:-pi.grayvines.com}
    local tunnel_port=${tunnel_port:-9050}
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
elif (( $+commands[pkg] )); then
    alias up="pkg upgrade"
fi

if (( $+commands[fzy] )); then
    alias v=$EDITOR' $(rg --follow --hidden --no-heading --files | fzy)'

    function insert-fzy-path-in-command-line() {
        # Copied from https://github.com/garybernhardt/selecta/blob/master/EXAMPLES.md
        local selected_path
        echo
        selected_path=$(find . -type f | fzy) || return
        eval 'LBUFFER="$LBUFFER$selected_path "'
        zle reset-prompt
    }
    zle -N insert-fzy-path-in-command-line

    bindkey "^S" insert-fzy-path-in-command-line
fi

if (( $+commands[nvim] )); then
    alias view='nvim -R'
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

alias sed="sed -E"

if ls --color &> /dev/null; then
    alias ls='ls --color=auto --human-readable --group-directories-first'
else
    export CLICOLOR=true
    alias ls='ls -h'
fi

if (( $+commands[exa] )); then
    alias exa='exa --git --group-directories-first --sort Name'
    alias l=exa
else
    alias l=ls
fi

if (( $+commands[rg] )); then
    alias prg='parallel"" -X rg'

    # Find the pattern in tests / not in tests
    alias rgg="rg -g '!*test*'"
    alias rgp="rg -g '!*test*' --type py"
    alias rgt="rg -g '*test*'"
    alias rgpt="rg -g '*test*' --type py"
else
    alias rg=grep
fi

if (( $+commands[dircolors] )); then
    eval $( dircolors -b $XDG_CONFIG_HOME/dircolors )
fi

function cdd() { cd *$1*/ } # stolen from @garybernhardt stolen from @topfunky
function cdc() { cd **/*$1*/ }

function conf() { 
    local target=($XDG_CONFIG_HOME/$1)
    if [[ -d "$target" ]]; then
        exa ${~target}
    else
        $EDITOR ${~target}
    fi
}
compdef "_files -W $XDG_CONFIG_HOME" conf
alias conf='noglob conf'

alias ymd='date +"%Y-%m-%d"'

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
function peek () { tmux split-window -p 33 $EDITOR $@ || exit; }

# Print a Python str
function pp() {
    python -c "print '${@:gs/'/\\'}'"
}

# Open a REPL for a virtualenv
function r() {
    if [[ $# == 0 ]]; then
        local repl=$(venvs find directory "$PWD" ptpython)
    else
        local repl=$(venvs find name $@ ptpython)
    fi
    pythonpath=(. ./src/ $pythonpath) $repl
}

# Run tests on current directory in a corresponding venv, otherwise globally
function t() {
    local venv_runner=$(venvs find directory $PWD $PYTHON_TEST_RUNNER)
    # This is shell gobbledigook for "does every arg start with -"
    if [[ ${@[(i)^-*]} -gt $# ]]; then
        argv+=("${venv_runner:h:h:t}")
    fi
    pythonpath=(. ./src/ $pythonpath) $venv_runner ${@:1}
}
