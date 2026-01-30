function open_or_cd
    if test (count $argv) = 0
        return
    end

    set arg $argv[1]

    if test -d "$arg"
        cd "$arg"
        history append "cd $arg"
    else
        open.sh "$arg"
        history append "open.sh $arg"
    end
end
