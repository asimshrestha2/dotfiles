if status is-interactive
    set -gx EDITOR nvim
    zoxide init fish --cmd cd | source

    if not string match -q -- "*tmux*" $TERM
        fastfetch -l /home/asim/Documents/term/ado.png --logo-height 16 --logo-padding 2 --logo-padding-top 1
    end

    # fish_config theme choose "Rosé Pine"
end
