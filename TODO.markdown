TO DO
=====

* zsh
    * oh-my-zsh
        * move to plugins
            * zsh-syntax-highlighting
            * zsh-completions
    * tab completion ignore unless only match
        * *.pyc
        * __pycache__

* arch
    * remap ctrl lock
    * fix unicode
    * write out w3m settings

* irssi
    * ignore +v
    * ignore nick changes
        * unless recently talked
        * if name in nick
            * foo -> foo|afk

* virtualenv
    * install by default
        * pudb
        * pdb++
        * nose? trial?
        * coverage?
        * bpython?
    * if dir has a bin directory add to path

* misc
    * write pre-commit hook / script to delete .pyc/o (prevent lingering test)
    * move stuff to .config
    * write a thing for vim / bpaste

* Write an install script
    * util/LS_COLORS
    * tmux.conf.os symlinked to tmux.conf.local
