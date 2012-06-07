export ZSH=$HOME/.zsh       # zsh configuration directory

setopt NO_BEEP              # shh!
setopt EXTENDED_GLOB        # extended patterns support

export GREP_OPTIONS='-IR --exclude-dir=.[a-zA-Z0-9]* --exclude=.* --color=auto'

# virtualenvwrapper (needs to be sourced *after* the PATH is set correctly)
# TODO: Use a virtualenv.ini
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Development
export VIRTUALENV_USE_DISTRIBUTE=true
export PIP_VIRTUALENV_BASE=$WORKON_HOME
# export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true
source virtualenvwrapper.sh

export PYTHON_TEST_RUNNER=`which trial`


# Use Keychain for ssh-agent handling
if (( $+commands[keychain] )) ; then
    eval $(keychain --eval --agents ssh -Q --quiet id_ecdsa)
fi

# disable flow control
stty -ixon

#--- Completion --------------------------------------------------------------

# Completions
fpath=(~/.zsh/zsh-completions $fpath)
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

#--- Prompt ------------------------------------------------------------------

PS1="%15<...<%~%# "
RPS1="%B%n%b@%m"

setopt PROMPT_SUBST

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

# assumes OSX has gnu coreutils installed from homebrew
alias ls='ls --color=auto --human-readable --group-directories-first'

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

#--- Functions ---------------------------------------------------------------

mkpkg() {
    mkdir -p $1/tests
    touch $1/__init__.py
    touch $1/tests/__init__.py
}

disable r

bindkey '^b' send-break
bindkey '^o' accept-line-and-down-history
