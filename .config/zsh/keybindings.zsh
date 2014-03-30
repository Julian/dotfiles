#--- Bindings ----------------------------------------------------------------

# Some defaults for things not in zkbd
typeset -A key
key[Ctrl+Up]='\e[1;5A'
key[Ctrl+Down]='\e[1;5B'
key[Shift+Tab]='\e[Z'

bindkey -v                    # set vim bindings in zsh

autoload -U edit-command-line
zle -N edit-command-line

# If we're in tmux, then ^A is our prefix. Otherwise, bind it to 'move a thing
# into tmux'. This only works on Linux. Also I haven't ever tried it yet.
function ctrla() {
    if [[ -e "$TMUX" ]] && (( $+commands[reptyr] )); then
        kill -TSTP $$
        bg >/dev/null 2>&1
        disown
        tmux new-window "$SHELL -c 'reptyr $$'"
        tmux attach
    else
        zle push-input
    fi
}

bindkey "^B" send-break
bindkey "^E" edit-command-line
bindkey "^O" accept-line-and-down-history
bindkey "^R" history-incremental-search-backward
bindkey "^U" undo

# Make ^Z toggle between ^Z and fg
function ctrlz() {
if [[ $#BUFFER == 0 ]]; then
    fg >/dev/null 2>&1 && zle redisplay
else
    zle push-input
fi
}

zle -N ctrlz
bindkey '^Z' ctrlz

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search up-line-or-beginning-search
zle -N down-line-or-beginning-search down-line-or-beginning-search

if [[ -f $ZDOTDIR/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE} ]]; then
    source $ZDOTDIR/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}  # Load keys
else
    echo "Couldn't load a key map. Loading the default..."
    echo "Run autoload -Uz zkbd; zkbd if you'd like to generate one instead."
    source $ZDOTDIR/.zkbd/default-keymap
fi

[[ -n ${key[Up]}        ]] && bindkey "${key[Up]}"          up-line-or-beginning-search
[[ -n ${key[Down]}      ]] && bindkey "${key[Down]}"        down-line-or-beginning-search
[[ -n ${key[Home]}      ]] && bindkey "${key[Home]}"        vi-beginning-of-line
[[ -n ${key[End]}       ]] && bindkey "${key[End]}"         vi-end-of-line
[[ -n ${key[PageUp]}    ]] && bindkey "${key[PageUp]}"      beginning-of-history
[[ -n ${key[PageDown]}  ]] && bindkey "${key[PageDown]}"    end-of-history

[[ -n ${key[Shift+Tab]} ]] && bindkey "${key[Shift+Tab]}"   reverse-menu-complete


# decrease wait times, unless on SSH (this should really be done in an alias)
if [[ -n $SSH_CONNECTION ]] ; then
    KEYTIMEOUT=15
else
    KEYTIMEOUT=5
fi
