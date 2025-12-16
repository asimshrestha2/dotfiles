function update --wraps='yay && flatpak udpate' --description 'alias update yay && flatpak update'
    yay && flatpak update $argv
end
