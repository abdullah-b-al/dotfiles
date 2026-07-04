function zig_watch --wraps='zig build --watch --error-style minimal_clear -freference-trace=128' --description 'alias zig_watch=zig build --watch --error-style minimal_clear -freference-trace=128'
    zig build --watch --error-style minimal_clear -freference-trace=128 $argv
end
