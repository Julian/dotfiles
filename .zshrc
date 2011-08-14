#--- Aliases -----------------------------------------------------------------

# Suffix Aliases
alias -s tex=vim

# Global Aliases
alias -g CA="2>&1 | cat -A"
alias -g C='| wc -l'
alias -g DN=/dev/null

alias playalbums='mplayer */* -shuffle'
alias nosecov='coverage run --branch --source=. `which nosetests`'
alias nosecov3='coverage-3.2 run --branch --source=. `which nosetests-3.2`'
alias ad='ssh julian@arch-desktop -t tmux a'

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
export SHARE_HISTORY

# setopt AUTO_CD            # allows typing dir instead of cd dir
setopt HISTIGNOREDUPS       # ignore duplicates if last cmd is same
setopt INC_APPEND_HISTORY   # append lines to history incrementally
setopt NO_BEEP              # shh!
setopt EXTENDED_GLOB        # extended patterns support

export EDITOR="vim"

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

export GREP_OPTIONS='--color=auto'

export NODE_PATH="/usr/local/lib/node/"

export PYTHONSTARTUP=~/.pythonrc

# colorize ls
if [[ "$OSTYPE" == "darwin10.0" ]]
then
    alias chrome="open /Applications/Google\ Chrome.app"

    # assumes OSX has gnu coreutils installed, otherwise use ls -G
    alias ls='/usr/local/bin/ls --color=auto --human-readable --group-directories-first'

    alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
    alias vi='vim'

    export PATH=/usr/local/share/python:/usr/local/share/python3:/usr/local/share/npm/bin:/Developer/usr/bin:$PATH:/usr/local/sbin
    # export C_INCLUDE_PATH=/Developer/SDKs/MacOSX10.5.sdk/usr/include
    # export LIBRARY_PATH=/Developer/SDKs/MacOSX10.5.sdk/usr/lib

    export EDITOR='/Applications/MacVim.app/Contents/MacOS/Vim'
else
    alias ls='ls --color --human-readable --group-directories-first'
fi

# LS_COLORS
eval $( dircolors -b $HOME/Dropbox/Programming/zsh/LS_COLORS/LS_COLORS )

# end colorize ls

export PATH=/usr/local/bin:$PATH

bindkey -v                  # set vim bindings in zsh

PS1="%15<...<%~%# "
RPS1="%B%n%b@%m"
