function fish_greeting
    printf "Dotfiles updated: "(git --git-dir ~/.dotfiles/.git --work-tree ~/.dotfiles log -1 --format=%cr)"\n\n" &
    fortune -a &
end
