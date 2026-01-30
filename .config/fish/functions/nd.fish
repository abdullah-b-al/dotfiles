function nd --wraps='nix develop --command fish' --description 'alias nd=nix develop --command fish'
    nix develop --command fish $argv
end
