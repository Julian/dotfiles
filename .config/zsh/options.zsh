#--- Options -----------------------------------------------------------------

setopt NO_BEEP              # shh!
setopt EXTENDED_GLOB        # extended patterns support

# disable flow control
unsetopt FLOW_CONTROL
stty -ixon

# Sane Quoting: '' escapes a single quote inside single quotes
setopt RC_QUOTES

# Changing Directories

DIRSTACKSIZE=8
setopt AUTO_PUSHD

# History

HISTSIZE=1000000
HISTFILE=$ZDOTDIR/history
SAVEHIST=$HISTSIZE

setopt EXTENDED_HISTORY       # store date and execution times
setopt HIST_FIND_NO_DUPS      # don't show me things I scroll past
setopt HIST_IGNORE_DUPS       # ignore duplicates if last cmd is same
setopt HIST_IGNORE_SPACE      # ignore lines beginning with spaces
setopt HIST_EXPIRE_DUPS_FIRST # delete dupes from history first
setopt HIST_REDUCE_BLANKS     # remove trailing whitespace
setopt HIST_VERIFY            # confirm before running
setopt INC_APPEND_HISTORY     # append lines to history incrementally
setopt SHARE_HISTORY

# Jobs

setopt AUTO_RESUME            # resume existing jobs if command matches
