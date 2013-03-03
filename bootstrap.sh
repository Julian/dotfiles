#! /bin/sh

set -e

DOTFILES_URL='https://github.com/Julian/dotfiles.git'
DOTFILES_DEST=~/.dotfiles
DEVELOPMENT=~/Development


main()
{
    clone_dotfiles
    continue_with_ansible
}

clone_dotfiles()
{
    echo 'Setting up the dotfiles repo.'

    if [ ! -d $DOTFILES_DEST ]; then
        setup

        printf "Cloning $DOTFILES_URL into $DOTFILES_DEST... "

        ensure_installed git
        (
            git clone --quiet $DOTFILES_URL $DOTFILES_DEST
            cd $DOTFILES_DEST
            git submodule --quiet init
            git submodule --quiet update
        )

        printf 'done\n'
    else
        echo "Existing dotfiles found in $DOTFILES_DEST."
    fi
}

setup()
{
    if [ "$OSTYPE" = darwin* ]; then
        ensure_has_homebrew
    fi
}

ensure_has_homebrew()
{
    printf 'Checking for homebrew... '
     bin_exists brew && printf 'found\n' || {
        printf 'installing\n'
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
    printf "Installing $@..."
    sudo apt-get install --yes --force-yes $@
    printf 'done\n'
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
