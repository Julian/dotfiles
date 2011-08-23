#--- Options -----------------------------------------------------------------

# Changing Directories

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# History

setopt HIST_IGNORE_DUPS       # ignore duplicates if last cmd is same
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY   # append lines to history incrementally
setopt SHARE_HISTORY

#--- Aliases -----------------------------------------------------------------

# Suffix Aliases
alias -s tex=vim

# Global Aliases
# alias -g CA="2>&1 | cat -A"
# alias -g C='| wc -l'
# alias -g DN=/dev/null

alias playalbums='mplayer */* -shuffle'
alias nosecov='coverage run --branch --source=. `which nosetests`'
alias nosecov3='coverage-3.2 run --branch --source=. `which nosetests-3.2`'
alias ad='ssh julian@arch-desktop -t tmux a'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

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

#--- Completion --------------------------------------------------------------

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

export HISTSIZE=200
export HISTFILE=~/.zsh_history
export SAVEHIST=200

# setopt AUTO_CD            # allows typing dir instead of cd dir
setopt NO_BEEP              # shh!
setopt EXTENDED_GLOB        # extended patterns support

export EDITOR="vim"

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

export GREP_OPTIONS='-IR --exclude-dir=.[a-zA-Z0-9]* --exclude=.* --color=auto'

export NODE_PATH="/usr/local/lib/node/"

export PYTHONSTARTUP=~/.pythonrc

if [[ "$OSTYPE" == "darwin10.0" ]]
then
    export PATH=/usr/local/share/python:/usr/local/share/python3:/usr/local/share/npm/bin:/Developer/usr/bin:$PATH:/usr/local/sbin
    # export C_INCLUDE_PATH=/Developer/SDKs/MacOSX10.5.sdk/usr/include
    # export LIBRARY_PATH=/Developer/SDKs/MacOSX10.5.sdk/usr/lib
fi

export PATH=/usr/local/bin:$PATH

bindkey -v                  # set vim bindings in zsh

PS1="%15<...<%~%# "
RPS1="%B%n%b@%m"
