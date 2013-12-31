#! /bin/sh

set -e

DOTFILES_URL='https://github.com/Julian/dotfiles.git'
DOTFILES_DEST=$HOME/.dotfiles


if [ -z "$DOTFILES_DEBUG" ]; then
    verbosity='--quiet'
fi


main()
{
    clone_dotfiles
    continue_with_dot
}

clone_dotfiles()
{
    echo 'Setting up the dotfiles repo.'

    if [ ! -d $DOTFILES_DEST ]; then
        setup

        echo "Cloning $DOTFILES_URL into $DOTFILES_DEST..."

        ensure_installed git
        (
            git clone $verbosity $DOTFILES_URL $DOTFILES_DEST
            cd $DOTFILES_DEST
            git submodule $verbosity init
            git submodule $verbosity update
        )
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
        ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
    }
}

bin_exists()
{
    command -v $1 >/dev/null 2>&1 
}

check_installed()
{
    if bin_exists brew; then
        brew list | grep "\b$1\b" >/dev/null
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
    sudo apt-get install $verbosity --yes --force-yes $@
    printf 'done\n'
}

continue_with_dot()
{
    exec $DOTFILES_DEST/dot install
}
