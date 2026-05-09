function nd --wraps='nix develop --command fish' --description 'alias nd=nix develop --command fish'
    nix develop  $argv --command fish
end
