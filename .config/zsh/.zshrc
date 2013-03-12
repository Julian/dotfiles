setopt NO_BEEP              # shh!
setopt EXTENDED_GLOB        # extended patterns support

# disable flow control
stty -ixon

#--- Completion --------------------------------------------------------------

# Completions
fpath=($ZSHPLUGINS/zsh-completions/src $fpath)
autoload -U compinit
compinit

# Use cache for slow functions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZDOTDIR/cache

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

# make sure history-substring-search is after syntax-highlighting
source $ZSHPLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSHPLUGINS/zsh-history-substring-search/zsh-history-substring-search.zsh

# Auto-quote urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

#--- Prompt ------------------------------------------------------------------

setopt PROMPT_SUBST

autoload -U colors && colors
autoload -Uz vcs_info

vcs_basic_info='is a %F{yellow}%s%f repository on %F{green}%b%f'
vcs_action_info='%F{yellow}|%f%F{red}%a%f'

zstyle ':vcs_info:*' enable git bzr hg
zstyle ':vcs_info:*' actionformats "$vcs_basic_info$vcs_action_info "
zstyle ':vcs_info:*' formats "$vcs_basic_info "
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

prompt_jobs() {
    PROMPT_JOBS=''

    running_job_count=`jobs -r | wc -l`
    stopped_job_count=`jobs -s | wc -l`

    if (( running_job_count > 0 )) ; then
        PROMPT_JOBS=" %{$fg[green]%}●%{$reset_color%}"
    fi
    if (( stopped_job_count > 0 )) ; then
        PROMPT_JOBS="$PROMPT_JOBS %{$fg[yellow]%}●%{$reset_color%}"
    fi
}

precmd () {
    prompt_jobs
    vcs_info
}

prompt_char='⊙'

if [[ -z $USE_MINI_PROMPT ]]; then
PS1='
%15<...<%~ ${vcs_info_msg_0_}
%(!.%{$fg[red]%}$prompt_char%{$reset_color%}.%{$fg[cyan]%}$prompt_char%{$reset_color%})  '
else
    PS1='%15<...<%~ $prompt_char '
fi

RPS1='%B%n%b@%m$PROMPT_JOBS'


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
HISTFILE=$ZDOTDIR/history
SAVEHIST=1000

setopt EXTENDED_HISTORY       # store date and execution times
setopt HIST_IGNORE_DUPS       # ignore duplicates if last cmd is same
setopt HIST_IGNORE_SPACE      # ignore lines beginning with spaces
setopt HIST_EXPIRE_DUPS_FIRST # delete dupes from history first
setopt HIST_REDUCE_BLANKS     # remove trailing whitespace
setopt HIST_VERIFY            # confirm before rubbing
setopt INC_APPEND_HISTORY     # append lines to history incrementally
setopt SHARE_HISTORY

# Jobs

setopt AUTO_RESUME            # resume existing jobs if command matches

#--- Bindings ----------------------------------------------------------------

bindkey "^B" send-break
bindkey "^O" accept-line-and-down-history
bindkey "^R" history-incremental-search-backward

#--- Aliases -----------------------------------------------------------------

alias brew='GREP_OPTIONS= brew'

# Suffix Aliases
alias -s tex=vim

# noglobs
alias git='noglob git'

alias playalbums='mplayer */* -shuffle'

if [[ "$OSTYPE" == darwin* && -n $commands[brew] ]]; then
    alias up="brew update && brew upgrade"
fi


if ls --color &> /dev/null; then
    # assumes OSX has gnu coreutils installed from homebrew
    alias ls='ls --color=auto --human-readable --group-directories-first'
else
    alias ls='ls -Gh'
fi


eval $( dircolors -b $XDG_CONFIG_HOME/dircolors )

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

# Disable the shell reserved word time if /usr/bin/time is present
if [[ -x /usr/bin/time ]]; then
    disable -r time
fi


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

#--- Misc --------------------------------------------------------------------

export PYTHONSTARTUP=$XDG_CONFIG_HOME/python/rc.py
# A name, not a path, so that the appropriate venved bin can be used
export PYTHON_TEST_RUNNER="trial"

# virtualenvwraper (needs to be sourced *after* the PATH is set correctly)
if (( $+commands[virtualenvwrapper_lazy.sh] )); then
    export WORKON_HOME=$HOME/.virtualenvs
    export PROJECT_HOME=$HOME/Development
    export VIRTUALENV_USE_DISTRIBUTE=true
    export PIP_VIRTUALENV_BASE=$WORKON_HOME
    source virtualenvwrapper_lazy.sh
fi

export GREP_OPTIONS='-IR --exclude-dir=.[a-zA-Z0-9]* --exclude=.* --color=auto'
export NOTMUCH_CONFIG=$XDG_CONFIG_HOME/notmuch/config

# Use Keychain for ssh-agent handling
if (( $+commands[keychain] )) ; then
    eval $(keychain --eval --agents ssh -Q --quiet id_ecdsa)
fi
