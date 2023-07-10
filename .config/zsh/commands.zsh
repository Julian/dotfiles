fpath=($ZDOTDIR/functions $fpath)
autoload \
    box \
    bye \
    conf \
    filter \
    randomize-mac \
    ssp \
    st \
    sst \
    tunnel \
    unquarantine \
    unquote \
    volume

#--- Aliases -----------------------------------------------------------------

alias b=bat
alias d='g d --no-index'
alias m='mv -iv'
alias n=$EDITOR
alias p='noglob parallel --tag --timeout 5 --progress --nonall --sshlogin - $@'

alias todo="$EDITOR +':VimwikiIndex'"

# X11 forwarding with WindowID, useful for e.g. forwarding vim clipboards
alias ssx='ssh -X -o "SendEnv WINDOWID"'
compdef _hosts ssp sst ssx

if (( $+commands[brew] )); then
    alias brew='GREP_OPTIONS= brew'
    alias up="brew update && brew upgrade"
elif (( $+commands[nixos-rebuild] )); then
    alias up="sudo nixos-rebuild switch --upgrade-all"
elif (( $+commands[pacman] )); then
    alias up="sudo pacman -Syu"
elif (( $+commands[pkg] )); then
    alias up="pkg upgrade"
elif (( $+commands[apt] )); then
    alias up="sudo apt update && sudo apt upgrade"
fi

if (( $+commands[fzy] )); then
    alias v=$EDITOR' $(fd --type file | fzy)'

    function insert-fzy-path-in-command-line() {
        # Copied from https://github.com/garybernhardt/selecta/blob/master/EXAMPLES.md
        local kind
        [[ "$LBUFFER" =~ "cd " ]] && kind='directory' || kind='file'
        echo
        local selected_path=$(fd --type "$kind" | fzy) || return
        LBUFFER+="${(q-)selected_path}"
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
    if (( $+commands[ggrep] )); then
        alias rg=ggrep
    else
        alias rg=grep
    fi
fi

if (( ! $+commands[bat] )); then
    alias bat=cat
else
    READNULLCMD=bat
fi

if (( $+commands[dircolors] )); then
    eval $( dircolors -b $XDG_CONFIG_HOME/dircolors )
fi

if (( $+commands[glow] )); then
    alias md='glow -w $COLUMNS'
fi

# Edit all files matching the given grep.
function vm() {
    noglob $EDITOR $(rg --files-with-matches $@)
}

function cdd() { cd *$1*/ } # stolen from @garybernhardt stolen from @topfunky
function cdc() { cd **/*$1*/ }

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

# If only pyed and friends were still alive...
function pe() {
    python -c "
from pathlib import Path
import sys
for line in sys.stdin:
    line = line[:-1]
    $@"
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
    local venv_runner=$(venvs find directory $PWD python)
    # This is shell gobbledigook for "does every arg start with -"
    if [[ ${@[(i)^-*]} -gt $# ]]; then
        argv+=("${venv_runner:h:h:t}")
    fi
    pythonpath=(. ./src/ $pythonpath) $venv_runner -m $PYTHON_TEST_RUNNER ${@:1}
}

MUSIC=~/Music
PLAYLISTS=$MUSIC/Playlists
DOCKET=$PLAYLISTS/Docket
autoload \
    artist \
    album \
    docket \
    play \
    shuffle
compdef '_files -W $MUSIC' artist
compdef '_files -W $MUSIC' album
compdef '_files -W $MUSIC' shuffle
