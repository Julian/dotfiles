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

zstyle ':completion:*:ls:*' file-patterns '%p:globbed-files' '*(/):directories'

# make sure history-substring-search is after syntax-highlighting
source $ZSHPLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
