export ZSHPLUGINS=$ZDOTDIR/plugins

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

export BROWSER=chromium

export LESSHISTFILE="-"     # ugh, stupid less. Disable ridiculous history file

if [[ "$OSTYPE" == darwin* ]]
then
    export BROWSER=open

    export XDG_CACHE_HOME=$HOME/Library/Caches
    export XDG_DATA_HOME=$HOME/Library/Application\ Support
    export VIRTUALENVS=$HOME/.local/share/virtualenvs
else
    export XDG_CACHE_HOME=$HOME/.cache
    export XDG_DATA_HOME=$HOME/.local/share
    export VIRTUALENVS=$XDG_DATA_HOME/virtualenvs
fi

export XDG_DESKTOP_DIR=$HOME/Desktop
export XDG_DOCUMENTS_DIR=$HOME/Documents
export XDG_DOWNLOAD_DIR=$XDG_DESKTOP_DIR
export XDG_MUSIC_DIR=$HOME/Music
export XDG_PICTURES_DIR=$HOME/Pictures
export XDG_PUBLICSHARE_DIR=$HOME/Public
export XDG_TEMPLATES_DIR=$XDG_CONFIG_HOME/templates
export XDG_VIDEOS_DIR=$HOME/Movies

export GNUPGHOME=$XDG_CONFIG_HOME/gnupg

export MYSQL_HISTFILE=${XDG_CACHE_HOME}/mysql_history
export PSQL_HISTORY=${XDG_CACHE_HOME}/psql_history

export GEM_HOME=$XDG_DATA_HOME/gem
export GEM_SPEC_CACHE=$XDG_CACHE_HOME/gem/spec

export STARDICT_DATA_DIR=$XDG_DATA_HOME/stardict

typeset -aU c_include_path
typeset -T C_INCLUDE_PATH c_include_path
export C_INCLUDE_PATH

typeset -aU gopath
typeset -T GOPATH gopath
gopath=($XDG_DATA_HOME/go)
export GOPATH

typeset -aU ld_library_path
typeset -T LD_LIBRARY_PATH ld_library_path
export LD_LIBRARY_PATH

typeset -aU nodepath
typeset -T NODEPATH nodepath
nodepath=(/usr/local/lib/node_modules /usr/local/lib/node)
export NODEPATH

typeset -aU pythonpath
typeset -T PYTHONPATH pythonpath
export PYTHONPATH

typeset -aU hgrcpath
typeset -T HGRCPATH hgrcpath
hgrcpath=($XDG_CONFIG_HOME/hg/config.ini $XDG_CONFIG_HOME/hg/)
export HGRCPATH
