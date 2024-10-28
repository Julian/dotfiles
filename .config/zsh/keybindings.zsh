#--- Bindings ----------------------------------------------------------------

# Some defaults for things not in zkbd
typeset -A key
key[Ctrl+Up]='\e[1;5A'
key[Ctrl+Down]='\e[1;5B'
key[Shift+Tab]='\e[Z'

bindkey -v                    # set vim bindings in zsh

autoload -U edit-command-line
zle -N edit-command-line

# Find a shell command in the history via fzy.
# Eventually if I like this, I may replace `^R` with it.
function history-fzy() {
  # The awk vomit is an ancient trick for `uniq` without sorting.
  # We also use --query, so all lines are present (and so you can backspace to
  # add more), though maybe we should instead pre-grep to only filter over
  # lines which match the prefix.
  BUFFER=$(history -r -n 1 | fzy --query "$LBUFFER")
  CURSOR=$#BUFFER

  zle reset-prompt
}
zle -N history-fzy

bindkey "^B" send-break
bindkey "^E" edit-command-line
bindkey "^H" backward-delete-char
bindkey "^K" push-input
bindkey "^O" accept-line-and-down-history
bindkey "^R" history-incremental-search-backward
# bindkey "^S" insert-*-path-in-command-line  -- bound in commands.zsh
bindkey "^T" history-fzy
bindkey -M viins "^U" backward-kill-line
bindkey "^W" backward-kill-word

bindkey "^?" backward-delete-char

bindkey "^[l" quote-line
bindkey "^[t" transpose-words
bindkey "^[." insert-last-word

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

function swap-quote-kind() {
  local c

  for (( c = $#LBUFFER; c > 0; c-- )); do
    if [[ $LBUFFER[c] == \' ]]; then
      LBUFFER[c]=\"
      break
    elif [[ $LBUFFER[c] == \" ]]; then
      LBUFFER[c]=\'
      break
    fi
  done
}

zle -N swap-quote-kind
bindkey '^Q' swap-quote-kind

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search up-line-or-beginning-search
zle -N down-line-or-beginning-search down-line-or-beginning-search

keymap="$ZDOTDIR/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}"
if [[ ! -f "$keymap" ]]; then
    keymap="$ZDOTDIR/.zkbd/default-keymap"
fi
source "$keymap"

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
