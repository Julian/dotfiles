#! /bin/zsh

export BROWSER=chromium
export DE=qtile


[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.Xresources.colorscheme ]] && xrdb -merge ~/.Xresources.colorscheme

[[ -x /usr/bin/qiv ]] && /usr/bin/qiv -n -z ~/.wallpaper
[[ -x /usr/bin/xscreensaver ]] && /usr/bin/xscreensaver -no-splash &

xsetroot -cursor_name left_ptr &
setxkbmap -option ctrl:nocaps -option altwin:swap_lalt_lwin


if [[ $1 == "gnome" ]]
then
    DE=gnome-session
fi


exec ck-launch-session $DE
