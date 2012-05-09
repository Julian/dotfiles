typeset -U path

export EDITOR="vim"

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

export LESSHISTFILE="-"     # ugh, stupid less. Disable ridiculous history file

export NODE_PATH="/usr/local/lib/node/"

if [[ "$OSTYPE" == darwin* ]]
then
    export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules
    path=(/usr/local/share/python/ /usr/local/share/pypy/ /usr/local/share/python3/ $(/usr/local/bin/brew --prefix ruby)/bin/ $(/usr/local/bin/brew --prefix coreutils)/libexec/gnubin/ /Developer/usr/bin/ $path)
elif [[ -a /etc/arch-release ]]
then
    # "Arch -- Let's Make Python Difficult, Together."
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
    export VIRTUALENVWRAPPER_VIRTUALENV=/usr/bin/virtualenv2
fi

path=(/usr/local/bin/ $HOME/.local/bin/ /usr/local/sbin/ $path)

export PYTHONSTARTUP=~/.pythonrc
