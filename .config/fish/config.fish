if status is-interactive
    set -gx EDITOR nvim
    zoxide init fish --cmd cd | source

    if not string match -q -- "*tmux*" $TERM
        fastfetch --kitty-direct /home/asim/Documents/term/107472573_p0.png --logo-height 16 --logo-width 27 --logo-padding 2 --logo-padding-top 1
    end

    fish_config theme choose "Rosé Pine"
end
