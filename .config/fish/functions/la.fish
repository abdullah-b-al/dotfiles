function la --wraps=ls --wraps='ls -al --group-directories-first' --description 'alias la=ls -al --group-directories-first'
    ls -al --group-directories-first $argv
end
