function ns --wraps='nix-shell --command fish' --description 'alias ns=nix-shell --command fish'
    nix-shell --command fish $argv
end
