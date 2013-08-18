setopt NO_BEEP              # shh!
setopt EXTENDED_GLOB        # extended patterns support

# disable flow control
stty -ixon

#--- Bindings ----------------------------------------------------------------

bindkey -v                    # set vim bindings in zsh

autoload -U edit-command-line
zle -N edit-command-line

bindkey "^B" send-break
bindkey "^E" edit-command-line
bindkey "^O" accept-line-and-down-history
bindkey "^R" history-incremental-search-backward
bindkey "^U" undo

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search up-line-or-beginning-search
zle -N down-line-or-beginning-search down-line-or-beginning-search

if [[ -f $ZDOTDIR/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE} ]]; then
    source $ZDOTDIR/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}  # Load keys
else
    printf 'Couldn''t load a key map.\nRunning zkbd.\n\n'
    autoload -Uz zkbd
    zkbd
fi

[[ -n ${key[Up]}   ]] && bindkey "${key[Up]}"   up-line-or-beginning-search
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-beginning-search

source $ZSHPLUGINS/zsh-fuzzy-match/fuzzy-match.zsh

#--- Completion --------------------------------------------------------------

# Completions
fpath=($ZSHPLUGINS/zsh-completions/src $fpath)
autoload -U compinit
compinit

# Use cache for slow functions
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $ZDOTDIR/cache

# Ignore completion for non-existant commands
zstyle ':completion:*:functions' ignored-patterns '_*'

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

#--- Modules -----------------------------------------------------------------

autoload -U zcalc

# Suffix aliases
autoload -U zsh-mime-setup
zsh-mime-setup

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

if [[ -n $SSH_CONNECTION ]] ; then
    KEYTIMEOUT=15
else
    KEYTIMEOUT=5
fi

# Changing Directories

DIRSTACKSIZE=8
setopt AUTO_PUSHD

# History

HISTSIZE=100000
HISTFILE=$ZDOTDIR/history
SAVEHIST=$HISTSIZE

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

#--- Aliases -----------------------------------------------------------------

alias di=diff
alias v='vim +CommandT'

if (( $+commands[brew] )); then
    alias brew='GREP_OPTIONS= brew'
    alias up="brew update && brew upgrade"
fi

if (( $+commands[weechat-curses] )); then
    alias weechat="weechat-curses -d $XDG_CONFIG_HOME/weechat"
fi

# Suffix Aliases
alias -s tex=vim

# noglobs
alias git='noglob git'

if ls --color &> /dev/null; then
    alias ls='ls --color=auto --human-readable --group-directories-first'
else
    alias ls='ls -Gh'
fi

if (( $+commands[ag] )); then
    AG_OPTIONS='--smart-case --ignore htmlcov --ignore *.min.js'
    alias ag="noglob ag $AG_OPTIONS"
fi

if (( $+commands[dircolors] )); then
    eval $( dircolors -b $XDG_CONFIG_HOME/dircolors )
fi

if (( $+commands[fasd])); then
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
export PYTHONWARNINGS='default'
# A name, not a path, so that the appropriate venved bin can be used
export PYTHON_TEST_RUNNER='trial'

# virtualenvwraper (needs to be sourced *after* the PATH is set correctly)
if (( $+commands[virtualenvwrapper_lazy.sh] )); then
    export WORKON_HOME=$XDG_DATA_HOME/virtualenvs
    export PROJECT_HOME=$DEVELOPMENT
    export VIRTUALENV_USE_SETUPTOOLS=true
    export PIP_VIRTUALENV_BASE=$WORKON_HOME
    source virtualenvwrapper_lazy.sh
fi

export GREP_OPTIONS='-IR --exclude-dir=.[a-zA-Z0-9]* --exclude=.* --color=auto'

# Use Keychain for ssh-agent handling
if (( $+commands[keychain] )) ; then
    eval $(keychain --eval --agents ssh -Q --quiet id_ecdsa)
fi
