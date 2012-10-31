export ZSH=$HOME/.zsh       # zsh configuration directory

setopt NO_BEEP              # shh!
setopt EXTENDED_GLOB        # extended patterns support

export GREP_OPTIONS='-IR --exclude-dir=.[a-zA-Z0-9]* --exclude=.* --color=auto'

export XDG_CONFIG_HOME=$HOME/.config

# virtualenvwrapper (needs to be sourced *after* the PATH is set correctly)
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Development
export VIRTUALENV_USE_DISTRIBUTE=true
export PIP_VIRTUALENV_BASE=$WORKON_HOME
source virtualenvwrapper_lazy.sh

export NOTMUCH_CONFIG=$XDG_CONFIG_HOME/notmuch/config

export PYTHON_TEST_RUNNER=`which trial`


# Use Keychain for ssh-agent handling
if (( $+commands[keychain] )) ; then
    eval $(keychain --eval --agents ssh -Q --quiet id_ecdsa)
fi

# disable flow control
stty -ixon

#--- Completion --------------------------------------------------------------

# Completions
fpath=(~/.zsh/zsh-completions/src $fpath)
autoload -U compinit
compinit

# Use cache for slow functions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

#  Fuzzy completion matching
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Allow more errors for longer commands
zstyle -e ':completion:*:approximate:*' \
        max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# If using a directory as arg, remove the trailing slash (useful for ln)
zstyle ':completion:*' squeeze-slashes true

# cd will never select the parent directory (e.g.: cd ../<TAB>):
zstyle ':completion:*:cd:*' ignore-parents parent pwd

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Auto-quote urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

#--- Prompt ------------------------------------------------------------------

setopt PROMPT_SUBST

autoload -U colors && colors
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git bzr hg
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5} on %F{2}%b%F{3}|%F{1}%a%F{5}%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5} on %F{2}%b%F{5}%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

precmd () {
    vcs_info
}

PS1='%15<...<%~ ${vcs_info_msg_0_}
%(!.%{$fg[red]%}⊙%{$reset_color%}.%{$fg[cyan]%}⊙%{$reset_color%})  '
RPS1='%B%n%b@%m'


#--- Bindings ----------------------------------------------------------------

bindkey "^B" send-break
bindkey "^O" accept-line-and-down-history
bindkey "^R" history-incremental-search-backward

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search up-line-or-beginning-search
zle -N down-line-or-beginning-search down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

#--- Options -----------------------------------------------------------------

bindkey -v                    # set vim bindings in zsh

if [[ -n $SSH_CONNECTION ]] ; then
    KEYTIMEOUT=15
else
    KEYTIMEOUT=5
fi

# Changing Directories

DIRSTACKSIZE=8
setopt AUTO_PUSHD

# History

HISTSIZE=1000
HISTFILE=~/.zsh_history
SAVEHIST=1000

setopt EXTENDED_HISTORY       # store date and execution times
setopt HIST_IGNORE_DUPS       # ignore duplicates if last cmd is same
setopt HIST_IGNORE_SPACE      # ignore lines beginning with spaces
setopt HIST_EXPIRE_DUPS_FIRST # delete dupes from history first
setopt HIST_REDUCE_BLANKS     # remove trailing whitespace
setopt HIST_VERIFY            # confirm before rubbing
setopt INC_APPEND_HISTORY     # append lines to history incrementally
setopt SHARE_HISTORY

#--- Aliases -----------------------------------------------------------------

alias brew='GREP_OPTIONS= brew'

# Suffix Aliases
alias -s tex=vim

# noglobs
alias git='noglob git'

alias playalbums='mplayer */* -shuffle'
alias arssi="ssh julian@arch-desktop -t 'tmux attach-session -t irssi || tmux new-session -s irssi'"


if ls --color &> /dev/null; then
    # assumes OSX has gnu coreutils installed from homebrew
    alias ls='ls --color=auto --human-readable --group-directories-first'
else
    alias ls='ls -Gh'
fi


eval $( dircolors -b $HOME/.dircolors )

# This was written entirely by Michael Magnusson (Mikachu)
# Basically type '...' to get '../..' with successive .'s adding /..
function rationalise-dot() {
if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
else
    LBUFFER+=.
fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

disable r

# Disable the shell reserved word time if /usr/bin/time is present
if [[ -x /usr/bin/time ]]; then
    disable -r time
fi


# Make ^Z toggle between ^Z and fg
function ctrlz() {
if [[ $#BUFFER == 0 ]]; then
    fg
    zle redisplay
else
    zle push-input
fi
}

zle -N ctrlz
bindkey '^Z' ctrlz
