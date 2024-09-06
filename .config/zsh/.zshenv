[[ -n "$ENABLE_ZPROF" ]] && zmodload zsh/zprof

export ZSHPLUGINS=$ZDOTDIR/plugins

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

if [[ "$OSTYPE" == darwin* ]]
then
    export BROWSER=open

    export XDG_CACHE_HOME=$HOME/Library/Caches
    export XDG_DATA_HOME=$HOME/Library/Application\ Support

    # Stuff which contains binaries and thereby can't cope with shebangs with spaces
    export VIRTUALENVS=$HOME/.local/share/virtualenvs
    # This envvar doesn't really exist, but we use it in the config file.
    export LUAROCKS_DATA_DIR=$HOME/.local/share/luarocks

    typeset -aU dyld_library_path
    typeset -T DYLD_LIBRARY_PATH dyld_library_path
    export DYLD_LIBRARY_PATH
else
    export BROWSER=chromium

    export XDG_CACHE_HOME=$HOME/.cache
    export XDG_DATA_HOME=$HOME/.local/share

    export VIRTUALENVS=$XDG_DATA_HOME/virtualenvs
    export LUAROCKS_DATA_DIR=$XDG_DATA_HOME/luarocks

    alias open=xdg-open
fi

export XDG_STATE_HOME=$HOME/.local/state

export XDG_TEMPLATES_DIR=$XDG_CONFIG_HOME/templates

if [[ "$OSTYPE" == linux-android ]]
then
    export XDG_DESKTOP_DIR=$HOME/storage/shared/Desktop
    export XDG_DOCUMENTS_DIR=$HOME/storage/shared/Documents
    export XDG_DOWNLOAD_DIR=$HOME/storage/shared/Download
    export XDG_MUSIC_DIR=$HOME/storage/shared/Music
    export XDG_PICTURES_DIR=$HOME/storage/shared/Pictures
    export XDG_PUBLICSHARE_DIR=$HOME/storage/shared/Public
    export XDG_VIDEOS_DIR=$HOME/storage/shared/Movies
else
    export XDG_DESKTOP_DIR=$HOME/Desktop
    export XDG_DOCUMENTS_DIR=$HOME/Documents
    export XDG_DOWNLOAD_DIR=$XDG_DESKTOP_DIR
    export XDG_MUSIC_DIR=$HOME/Music
    export XDG_PICTURES_DIR=$HOME/Pictures
    export XDG_PUBLICSHARE_DIR=$HOME/Public
    export XDG_VIDEOS_DIR=$HOME/Movies
fi

export GNUPGHOME=$XDG_CONFIG_HOME/gnupg

export AWS_SHARED_CREDENTIALS_FILE=$XDG_CONFIG_HOME/aws/credentials.ini

export DOCKER_CONFIG=$XDG_CONFIG_HOME/docker/

export IPYTHONDIR=$XDG_DATA_HOME/ipython/
export JUPYTER_CONFIG_DIR=$XDG_CONFIG_HOME/jupyter/
export KAGGLE_CONFIG_DIR=$XDG_CONFIG_HOME/kaggle/
export MPLCONFIGDIR=$XDG_CONFIG_HOME/matplotlib/
export MYPY_CACHE_DIR=$XDG_CACHE_HOME/mypy/

export LESSHISTFILE=$XDG_CACHE_HOME/less_history

export MYSQL_HISTFILE=$XDG_CACHE_HOME/mysql_history
export PSQL_HISTORY=$XDG_CACHE_HOME/psql_history
export SQLITE_HISTORY=$XDG_CACHE_HOME/sqlite_history

export CARGO_HOME=$XDG_DATA_HOME/cargo
export RUSTUP_HOME=$XDG_DATA_HOME/rustup

export ELAN_HOME=$XDG_DATA_HOME/elan/
export MATHLIB_CACHE_DIR=$XDG_CACHE_HOME/mathlib/

export GEM_HOME=$HOME/.local/share/gem
export GEM_SPEC_CACHE=$XDG_CACHE_HOME/gem/spec

export LUAROCKS_CONFIG=$XDG_CONFIG_HOME/luarocks.lua

export NODE_REPL_HISTORY=$XDG_CACHE_HOME/node_repl_history
export PNPM_HOME=$XDG_DATA_HOME/pnpm

export LEIN_HOME=$XDG_DATA_HOME/lein
export M2_HOME=$XDG_DATA_HOME/m2

export PARALLEL_HOME=$XDG_CONFIG_HOME/parallel

export PTPYTHON_CONFIG_HOME=$XDG_CONFIG_HOME/ptpython

# See man par. Then cry.
export PARINIT="rTbgqR B=.,?'_A_a_@ Q=_s>|"

export RIPGREP_CONFIG_PATH=${XDG_CONFIG_HOME}/ripgrep

export STARDICT_DATA_DIR=$XDG_DATA_HOME/stardict

typeset -aU c_include_path
typeset -T C_INCLUDE_PATH c_include_path
export C_INCLUDE_PATH

typeset -aU cplus_include_path
typeset -T CPLUS_INCLUDE_PATH cplus_include_path
export CPLUS_INCLUDE_PATH

typeset -aU library_path
typeset -T LIBRARY_PATH library_path
export LIBRARY_PATH

typeset -aU ld_library_path
typeset -T LD_LIBRARY_PATH ld_library_path
export LD_LIBRARY_PATH

typeset -aU pkg_config_path
typeset -T PKG_CONFIG_PATH pkg_config_path
export PKG_CONFIG_PATH

typeset -aU nodepath
typeset -T NODEPATH nodepath
nodepath=(/usr/local/lib/node_modules /usr/local/lib/node)
export NODEPATH

typeset -aU pythonpath
typeset -T PYTHONPATH pythonpath
export PYTHONPATH

typeset -aU pywarnings
typeset -T PYTHONWARNINGS pywarnings ','
export PYTHONWARNINGS

typeset -aU hgrcpath
typeset -T HGRCPATH hgrcpath
hgrcpath=($XDG_CONFIG_HOME/hg/config.ini $XDG_CONFIG_HOME/hg/)
export HGRCPATH

# Some tools *ahem docker -H ssh://* do not have a way to specify full paths to
# binaries, so help them find things they need over SSH. Otherwise rely on the
# normal path setting in .zprofile.
[[ -n $SSH_CONNECTION ]]  && path=($path /usr/local/bin)
