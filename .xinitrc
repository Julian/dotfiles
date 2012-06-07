#! /bin/sh

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.Xresources.colorscheme ]] && xrdb -merge ~/.Xresources.colorscheme

xsetroot -cursor_name left_ptr &

#
# caps lock is ctrl, alt is ctrl, windows is alt 
setxkbmap -option ctrl:nocaps -option altwin:ctrl_alt_win


if [[ $1 == "gnome" ]]
then
    exec gnome-session
else
    exec qtile
fi
