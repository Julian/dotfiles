#! /bin/bash

set -e

DEVELOPMENT=~/Development


main()
{
    clone_dotfiles
    continue_with_ansible
}

clone_dotfiles()
{
    if [ ! -d ~/.dotfiles ]; then
        setup

        ensure_installed git
        git clone --quiet --recursive https://github.com/Julian/dotfiles.git ~/.dotfiles
    fi
}

setup()
{
    if [ "$OSTYPE" = darwin* ]; then
        install_homebrew
    fi
}

install_homebrew()
{
    bin_exists brew || {
        ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
    }
}

bin_exists()
{
    command -v $1 >/dev/null 2>&1 
}

check_installed()
{
    if bin_exists brew; then
        brew list | grep "\<$1\>" >/dev/null
    elif bin_exists dpkg-query; then
        [ "`dpkg-query -W -f='${Status}\n' $1`" = 'install ok installed' ]
    fi
}

ensure_installed()
{
    for package; do
        check_installed $package || install $package
    done
}

install()
{
    sudo apt-get install --yes --force-yes $@
}

continue_with_ansible()
{
    if [ ! -d "$DEVELOPMENT/ansible" ]; then
        git clone --quiet https://github.com/ansible/ansible.git $DEVELOPMENT/ansible
    fi

    ensure_python_installed paramiko yaml jinja2

    source ~/Development/ansible/hacking/env-setup >/dev/null
    exec ~/.dotfiles/dot link
}

ensure_python_installed()
{
    for package; do
        check_installed "python-$package" || install "python-$package"
    done
}

main
