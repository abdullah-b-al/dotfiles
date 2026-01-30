const alloc = std.heap.smp_allocator;

const Option = enum {
    list_options,

    tools_menu,
    tools_calculator,
    tools_system_monitor,
    tools_bluetooth,
    tools_network,
    tools_audio_mixer,
};

pub fn main() !void {
    var iter = try std.process.argsWithAllocator(alloc);
    _ = iter.skip();

    const string = iter.next() orelse "";
    const option = std.meta.stringToEnum(Option, string) orelse {
        notify(format("UnknownOption: [{s}]", .{string}));
        return error.UnknownOption;
    };
    switch (option) {
        .tools_menu => try tools.menu(),
        .tools_bluetooth => try tools.bluetui(),
        .tools_network => try tools.nmtui(),
        .tools_audio_mixer => try tools.pulsemixer(),
        .tools_calculator => try tools.qalc(),
        .tools_system_monitor => try tools.btop(),
        .list_options => try list_options(),
    }
}

fn list_options() !void {
    var string: std.ArrayList(u8) = .empty;
    inline for (std.meta.fields(Option)) |f| {
        const value: Option = @enumFromInt(f.value);
        switch (value) {
            .tools_menu, .list_options => {},
            else => {
                try string.appendSlice(alloc, f.name);
                try string.append(alloc, '\n');
            },
        }
    }

    var stdout = std.fs.File.stdout();
    try stdout.writeAll(string.items);
}

const tools = struct {
    fn attach_tool_window(comptime arg: struct { tool: []const u8, bin: []const u8 }) !void {
        const session = "tools";

        if (!tmux.session_exists(session)) {
            try tmux.session_new_with_window(session, arg.tool, arg.bin);
        } else if (!tmux.window_exists(session, arg.tool)) {
            try tmux.window_new(session, arg.tool, arg.bin);
        } else {
            try tmux.window_focus(session, arg.tool);
        }

        if (try wm.window_exists_by_app_id(terminal.scratch_name)) {
            try wm.focus_by_app_id(terminal.scratch_name);
        } else {
            try terminal.scratch(&.{ "tmux", "attach", "-t", session ++ ":" ++ arg.tool });
        }
    }

    fn attach_tool_window_simple(comptime tool: []const u8) !void {
        try attach_tool_window(.{ .tool = tool, .bin = tool });
    }

    fn menu() !void {
        try tools.attach_tool_window(.{
            .tool = "menu",
            .bin = "sh -c 'myenv.sh list_options | fzf --style=minimal | xargs -I {} myenv.sh {}'",
        });
    }

    fn bluetui() !void {
        try attach_tool_window_simple("bluetui");
    }

    fn nmtui() !void {
        try attach_tool_window_simple("nmtui");
    }

    fn pulsemixer() !void {
        try attach_tool_window_simple("pulsemixer");
    }

    fn qalc() !void {
        try attach_tool_window_simple("qalc");
    }

    fn btop() !void {
        try attach_tool_window_simple("btop");
    }
};

const tmux = struct {
    fn session_exists(name: []const u8) bool {
        const res = run(&.{ "tmux", "has-session", "-t", name }) catch @panic("");
        return res.term.Exited == 0;
    }

    fn session_new_with_window(session: []const u8, window: []const u8, bin: []const u8) !void {
        _ = try run(&.{ "tmux", "new-session", "-d", "-s", session, "-n", window, bin });
    }

    fn window_exists(session: []const u8, window: []const u8) bool {
        const res = run(&.{ "tmux", "has-session", "-t", format("{s}:{s}", .{ session, window }) }) catch @panic("");
        return res.term.Exited == 0;
    }

    fn window_new(session: []const u8, window: []const u8, bin: []const u8) !void {
        _ = try run(&.{ "tmux", "new-window", "-t", session, "-n", window, bin });
    }

    fn window_focus(session: []const u8, window: []const u8) !void {
        _ = try run(&.{ "tmux", "select-window", "-t", format("{s}:{s}", .{ session, window }) });
    }
};

const terminal = struct {
    const scratch_name = "scratch_terminal";

    fn scratch(comptime args: []const []const u8) !void {
        const res = try run(.{ "alacritty", "msg", "create-window", "--class", scratch_name, "-e" } ++ args);

        // if 'alacritty msg' fails that means no daemon or existing window is running
        if (res.term.Exited != 0) {
            _ = try run(.{ "alacritty", "--class", scratch_name, "-e" } ++ args);
        }
    }
};

/// Window Manager
const wm = struct {
    fn focus_by_app_id(name: []const u8) !void {
        _ = try run(&.{
            "swaymsg",
            format("[app_id={s}] focus", .{name}),
        });
    }

    fn window_exists_by_app_id(name: []const u8) !bool {
        const res = try run(&.{
            "sh",
            "-c",
            "swaymsg --raw -t get_tree | jq -r '.. | .app_id? // empty'",
        });

        return has_line(res.stdout, name);
    }
};

fn notify(body: []const u8) void {
    _ = run(&.{ "notify-send", "myenv", body }) catch return;
}
fn run(args: []const []const u8) !std.process.Child.RunResult {
    return try std.process.Child.run(.{
        .allocator = alloc,
        .argv = args,
    });
}

fn has_line(string: []const u8, target: []const u8) bool {
    var iter = std.mem.splitScalar(u8, string, '\n');
    while (iter.next()) |line| {
        if (std.mem.eql(u8, line, target)) return true;
    }
    return false;
}

fn format(comptime fmt: []const u8, args: anytype) []const u8 {
    return std.fmt.allocPrint(alloc, fmt, args) catch @panic("OOM");
}

const std = @import("std");
