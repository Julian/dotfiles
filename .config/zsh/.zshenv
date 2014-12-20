export ZSHPLUGINS=$ZDOTDIR/plugins

export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

export BROWSER=chromium

export GNUPGHOME=$XDG_CONFIG_HOME/gnupg

export LESSHISTFILE="-"     # ugh, stupid less. Disable ridiculous history file

export MYSQL_HISTFILE=${XDG_CACHE_HOME}/mysql_history
export PSQL_HISTORY=${XDG_CACHE_HOME}/psql_history

typeset -aU gopath
typeset -T GOPATH gopath
gopath=($XDG_DATA_HOME/go)
export GOPATH

typeset -aU nodepath
typeset -T NODEPATH nodepath
nodepath=(/usr/local/lib/node)
export NODEPATH

typeset -aU perl_local_lib_root
typeset -T PERL_LOCAL_LIB_ROOT perl_local_lib_root
perl_local_lib_root=(${XDG_DATA_HOME}/perl5)
typeset -aU perl5lib
typeset -T PERL5LIB perl5lib
perl5lib=($perl_local_lib_root/lib/perl5)
export PERL5LIB PERL_LOCAL_LIB_ROOT

typeset -aU pythonpath
typeset -T PYTHONPATH pythonpath
export PYTHONPATH

typeset -aU hgrcpath
typeset -T HGRCPATH hgrcpath
hgrcpath=($XDG_CONFIG_HOME/hg/config.ini $XDG_CONFIG_HOME/hg/)
export HGRCPATH

if [[ "$OSTYPE" == darwin* ]]
then
    export BROWSER=open
    nodepath=(/usr/local/lib/node_modules $nodepath)
elif [[ -a /etc/arch-release ]]
then
    # "Arch -- Let's Make Python Difficult, Together."
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
    export VIRTUALENVWRAPPER_VIRTUALENV=/usr/bin/virtualenv2
fi
