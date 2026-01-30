function s
    $EDITOR /etc/nixos/configuration.nix
    sudo nixos-rebuild switch --impure
end
