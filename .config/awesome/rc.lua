-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local focused = awful.screen.focused
local naughty = require("naughty")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

local rc = require("rc2")

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

local home = os.getenv("HOME")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
gears.wallpaper.set("#000000")
-- beautiful.border_width = 2
-- beautiful.border_focus = "#FFFFFF"

beautiful.font = rc.get_font()
beautiful.notification_font = rc.get_font(32)
beautiful.fg_normal  = "#FFFFFF"
beautiful.bg_normal  = "#282C34"
beautiful.titlebar_fg  = beautiful.fg_normal
beautiful.titlebar_bg  = beautiful.bg_normal
beautiful.tasklist_bg_focus = "#555555"
beautiful.tasklist_fg_focus  = "#CCCCCC"
beautiful.tasklist_fg_normal = "#CCCCCC"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"
local Alt = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.max,
}
-- }}}

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({ }, 1, function(t) t:view_only() end),

  awful.button({ modkey }, 1, function(t)
    if client.focus then client.focus:move_to_tag(t) end
  end),

  awful.button({ }, 3, awful.tag.viewtoggle),

  awful.button({ modkey }, 3, function(t)
    if client.focus then client.focus:toggle_tag(t) end
  end),

  awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),

  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
  awful.button({ }, 1, function (c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal(
        "request::activate",
        "tasklist",
        {raise = true}
      )
    end
  end),

  awful.button({ }, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
  end),

  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
  end),

  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
  end)
)

awful.screen.connect_for_each_screen(function(s)
  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

  if s.index == 1 then
  s.tags[1].layout = awful.layout.layouts[3];
  end

  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)))
  -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        -- filter = function (t) return t.selected or #t:clients() > 0 end,

        buttons = taglist_buttons,
    }

  -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        layout   = {
            layout = wibox.layout.flex.vertical,
            widget = wibox.container.rotate,
        },


        buttons = tasklist_buttons,
        -- makes the tasklist a spacing widget only
        -- layout = {}
    }

  -- Create the wibox
    s.topwibox = awful.wibar({ position = "top", screen = s, height = 15 })
    s.leftwibox = awful.wibar({ position = "left", screen = s, width = 20, height = s.geometry.height })
    s.topwibox.x = s.topwibox.x + 20
    s.leftwibox.y = s.topwibox.y

    s.leftwibox:setup{
        layout = wibox.layout.align.vertical,
        s.mylayoutbox,
        {
            layout = wibox.layout.align.vertical,
            widget = wibox.container.rotate,
            s.mytasklist,
        },
    }
    s.topwibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",

        { -- Left widgets
            spacing = 1,
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
        },

        {
            spacing = 5,
            layout = wibox.layout.fixed.horizontal,

            -- rc.widgets.updates,
            rc.widgets.auto_cpufreq,
            rc.widgets.battery,
            rc.widgets.network,
            rc.widgets.ram,
            rc.widgets.cpu,
            rc.widgets.gpu,

            rc.widgets.date_and_time,

            {
                layout = wibox.layout.fixed.horizontal,
                spacing = 0,
                wibox.widget.systray(),
                awful.widget.keyboardlayout(),
            },
        },

        { -- Right widgets
            widget = wibox.container.margin,
        },
    }

end)
-- }}}

-- {{{ Mouse bindings
-- root.buttons(gears.table.join(
--     awful.button({ }, 3, function () mymainmenu:toggle() end),
--     awful.button({ }, 4, awful.tag.viewnext),
--     awful.button({ }, 5, awful.tag.viewprev)
-- ))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    -- Destroy all notifications
    awful.key({ modkey, "Control",}, "space", function() naughty.destroy_all_notifications() end,
        {description = "destroy all notifications", group = "hotkeys"}),

    -- Show help
    awful.key({ modkey, "Shift"}, "/",      hotkeys_popup.show_help,
        {description="show help", group="awesome"}),

    -- Tag browsing
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
        {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
        {description = "view next", group = "tag"}),

    -- Default client focus
    awful.key(
        {modkey}, "l",
        function ()
            awful.client.focus.byidx(1)
        end,
        {description = "focus next by index", group = "client"}
    ),

    awful.key(
        {modkey}, "h",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({modkey}, "a",
        function ()
            client.focus = awful.client.getmaster();
            awful.client.focus.byidx(-1)
            awful.client.focus.byidx(1)
        end,
        {description = "Focus master window", group = "client"}
    ),

    awful.key({modkey}, "t",
        function ()
            local spawn = function (name)
                return function ()
                    local cmd = string.format(
                        [[scratch-term.sh nvim --cmd "cd %s/personal/notes" %s/personal/%s]],
                        home, home, name
                    )
                    awful.spawn(cmd)
                end
            end

            rc.multi_key_map({
                {{}, "e", spawn("notes/notes.md")},
                {{}, "a", spawn("a.md")},
                {{}, "t", spawn("e.md")},
            })

        end, {}),


    awful.key({modkey, Alt}, "s", function() awful.spawn([[find.sh open root]]) end),
    awful.key({modkey, Alt}, "r", function() awful.spawn([[find.sh open personal]]) end),
    awful.key({modkey, Alt}, "a", function() awful.spawn([[find.sh open dotfiles]]) end),
    awful.key({modkey, Alt}, "t", function() awful.spawn([[find.sh open home]]) end),
    awful.key({modkey, Alt}, "p", function() awful.spawn([[find.sh open prog]]) end),
    -- awful.key({modkey}, "s", function (
    --     local spawn = function (name)
    --         return function () awful.spawn([[find.sh open ]] .. name) end
    --     end
    --     rc.multi_key_map({
    --         {{}, "a", spawn("dotfiles")},
    --         {{}, "p", spawn("prog")},
    --         {{}, "r", spawn("personal")},
    --         {{}, "s", spawn("root")},
    --         {{}, "t", spawn("home")},
    --     })
    -- end, {}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "l", function () awful.client.swap.byidx(  1)    end,
        {description = "swap with next client by index", group = "client"}),

    awful.key({ modkey,           }, "Tab", function ()
        client.focus = nil
    end,
        {description = "Unfocus the current client", group = "screen"}),

    awful.key({ modkey, "Shift"   }, "h", function () awful.client.swap.byidx( -1)    end,
        {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "l", function () awful.screen.focus_relative( 1) end,
        {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "h", function () awful.screen.focus_relative(-1) end,
        {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Shift" }, "u", awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}),

    -- Show/hide wibox
    awful.key({ modkey, 'Shift' }, "b", function ()
        for s in screen do
            s.topwibox.visible = not s.topwibox.visible
            s.leftwibox.visible = not s.leftwibox.visible
            if s.mybottomwibox then
                s.mybottomwibox.visible = not s.mybottomwibox.visible
            end
        end
    end,
        {description = "toggle wibox", group = "awesome"}),

    awful.key( { modkey, }, "n", function()
        rc.spawn_or_goto_terminal()
        awful.spawn("tmux-switch-to.sh shell")
    end,
        {description = "Open or go to a terminal if it's not already open on the focused screen"}
    ),

    awful.key( { modkey, }, "e", function()
        awful.spawn("tmux-switch-to.sh editor")
        rc.spawn_or_goto_terminal()
    end,
        {description = "Open or go to the editor if it's not already open on the focused screen"}
    ),

    awful.key( { modkey, }, "i", function()
        awful.spawn("tmux-switch-to.sh build")
        rc.spawn_or_goto_terminal()
    end,
        {description = "Open or go to the build shell if it's not already open on the focused screen"}),

    awful.key( { modkey, }, "d", function() rc.spawn_or_goto('- Brave$', 'brave-browser', "name") end,
        {description = "Open or go to a brsower if it's not already open on the focused screen"}
    ),
    awful.key( { modkey, "Control" }, "d", function() awful.spawn('brave-browser') end,
        {description = "Open a brsower if it's not already open on the focused screen"}
    ),

    awful.key( { modkey, }, "x", function() awful.spawn("plumer.sh") end,
        {description = "Open plumer tool"}
    ),

    awful.key( { modkey, }, "b", function() awful.spawn("bookmarks.sh get") end,
        {description = "Open bookmarks"}
    ),

    awful.key( { modkey, Alt }, "l", function() awful.spawn("pick-compile-cmds.sh rofi switch") end,
        {description = "Display list of ran commands"}
    ),
    awful.key( { modkey, Alt }, "u", function() awful.spawn("pick-compile-cmds.sh pick-last-used switch") end,
        {description = "Execute last ran command"}
    ),
    awful.key( { modkey, Alt }, "y", function() awful.spawn("pick-compile-cmds.sh pick-last-used vim") end,
        {description = "Execute last ran command"}
    ),

    awful.key( { modkey, Alt }, "F1", function() awful.spawn(os.getenv("HOME") .. "/personal/audio/q/play.sh") end,
        {description = "Execute last ran command"}
    ),

    awful.key(
        { modkey }, "o", function ()
            if not rc.goto_window('^docs$', "class") then
                awful.util.spawn("open-docs.sh")
            end
        end,
        {description = "Open or go to a window containing documentaion.", group = "launcher"}
    ),
    awful.key(
        { modkey, Alt }, "o", function ()
            awful.util.spawn("open-docs.sh")
        end,
        {description = "Force Open a window containing documentaion.", group = "launcher"}
    ),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
        {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift", "Control"   }, "q", awesome.quit,
        {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "j",     function () awful.tag.incmwfact( 0.02)          end,
        {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "k",     function () awful.tag.incmwfact(-0.02)          end,
        {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "j",     function () awful.tag.incnmaster( 1, nil, true) end,
        {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "k",     function () awful.tag.incnmaster(-1, nil, true) end,
        {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "j",     function () awful.tag.incncol( 1, nil, true)    end,
        {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "k",     function () awful.tag.incncol(-1, nil, true)    end,
        {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
        {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
        {description = "select previous", group = "layout"}),

    awful.key({modkey, "Control"}, "x", function ()
        awful.spawn("lockscreen.sh")
    end, {description = "Lock screen"}),

    awful.key({modkey}, "z", function ()
        awful.spawn("rofi -show run")
    end, {description = "Open progam launcher"}),

    awful.key({modkey}, "c", function ()
        awful.spawn("rofi -modi calc -show calc")
    end, {description = "Open calculator"}),

    awful.key({modkey}, "F2", function ()
        awful.spawn("set-language.sh ara")
    end, {description = "Set keyboard to arabic"}),
    awful.key({modkey}, "F3", function ()
        awful.spawn("set-language.sh us")
    end, {description = "Set keyboard to english"})

    --]] This is a function call. Do not place a comma at the end
)

clientkeys = gears.table.join(
  awful.key({ modkey }, "q",      function (c)
        if c.class == "gamescope" then
            return
        end
        c:kill()
    end,
        {description = "close", group = "client"}),
  awful.key({ modkey, "Control" }, "]",  awful.client.floating.toggle                     ,
    {description = "toggle floating", group = "client"}),
  awful.key({ modkey, "Control" }, "[",  function(c) awful.titlebar.toggle(c) end                     ,
    {description = "Toggle titlebar", group = "client"}),
  -- awful.key({ modkey }, "Return", function (c) c:swap(awful.client.getmaster()) end,
  -- {description = "move to master", group = "client"}),
    awful.key({ modkey, "Shift"}, "o",      function (c) c:move_to_screen()               end,
    {description = "move to screen", group = "client"}),
  awful.key({ modkey, "Control"           }, "Return",      function (c) c.ontop = not c.ontop            end,
    {description = "toggle keep on top", group = "client"}),

  awful.key({ modkey,           }, "m",
    function (c)
      c.maximized = not c.maximized
      c:raise()
    end ,
    {description = "(un)maximize", group = "client"}),
  awful.key({ modkey, "Control" }, "m",
    function (c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end ,
    {description = "(un)maximize vertically", group = "client"}),
  awful.key({ modkey, "Shift"   }, "m",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end ,
    {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
        properties = { border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
            "DTA",  -- Firefox addon DownThemAll.
            "copyq",  -- Includes session name in class.
            "pinentry",
        },
        class = {
            "Arandr",
            "Blueman-manager",
            "Gpick",
            "Kruler",
            "MessageWin",  -- kalarm.
            "Sxiv",
            "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
            "Wpa_gui",
            "veromix",
            "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
            "Event Tester",  -- xev.
        },
        role = {
            "AlarmWindow",  -- Thunderbird's calendar.
            "ConfigManager",  -- Thunderbird's about:config.
            "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = true }},
    -- Add titlebars to normal clients and dialogs
    {
        rule_any = {type = { "normal", "dialog" }
        }, properties = { titlebars_enabled = true }
    },


    {
        rule_any = {
            class = { "looking-glass-client" }
        }, properties = { floating = true, screen = 1, fullscreen = true, new_tag = true }
    },

    {
        rule_any = {
            class = { "gamescope" }
        }, properties = { floating = true, screen = 1, new_tag = true }
    },

    {
        rule_any = {
            class = { "steam" }
        }, properties = { floating = true, fullscreen = false, maximized = false }
    },

    {
        rule_any = {
            class = {"terminal-prompt" }
        },
        properties = {
            callback = function (c)
                c.x = awful.screen.focused().geometry.width * 0.25
                c.y = awful.screen.focused().geometry.height * 0.25
                c.height = awful.screen.focused().geometry.height * 0.5
                c.width = awful.screen.focused().geometry.width * 0.5
                c.screen = awful.screen.focused()

                local titlebar = awful.titlebar(c)

                beautiful.font = rc.get_font(12)
                titlebar:setup({
                    { -- Title
                        align  = 'center',
                        widget = awful.titlebar.widget.titlewidget(c),
                    },
                    layout  = wibox.layout.flex.horizontal

                })
                beautiful.font = rc.get_font()
            end,
            floating = true,
            placement = awful.placement.centered,
        }
    },
    {
        rule_any = {
            class = { "zenity", "Zenity", "Gcr-prompter", "yad", "Yad"}
        },
        properties = {
            callback = function (c)
                local titlebar = awful.titlebar(c)

                beautiful.font = rc.get_font(12)
                titlebar:setup({
                    { -- Title
                        align  = 'center',
                        widget = awful.titlebar.widget.titlewidget(c),
                    },
                    layout  = wibox.layout.flex.horizontal

                })
                beautiful.font = rc.get_font()
            end,
            floating = true,
            placement = awful.placement.centered,
        }
    },


    {
        rule_any = {
            class = {
                "scratch-terminal",
            },
        }, properties = {
            callback = function (c)
                c.x = awful.screen.focused().geometry.width * 0.25
                c.y = awful.screen.focused().geometry.height * 0.5
                c.height = awful.screen.focused().geometry.height * 0.5
                c.width = awful.screen.focused().geometry.width * 0.5
                c.screen = awful.screen.focused()
            end,
            floating = true,
        },
    },

    {
        rule_any = {
            class = {
                "terminal-calculator",
            },
        }, properties = {
            floating = true,
            center = true,
            callback = function (c)
                c.x = awful.screen.focused().geometry.width * 0.25
                c.y = awful.screen.focused().geometry.height * 0.25
                c.height = awful.screen.focused().geometry.height * 0.5
                c.width = awful.screen.focused().geometry.width * 0.5
                c.screen = awful.screen.focused()
            end,
        },
    },

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- Rules based on patterns
    local client_name = c.name or ""
    if string.match(client_name, "^TestWindow") then
        c.floating = true
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c)
    rc.screen_settings_set()

    -- border color
    c.border_color = '#00FF00'
    c.border_width = 1

    gears.timer.start_new(0.3, function()
        local focused_client = client.focus
        focused_client.border_color = '#000000'
        focused_client.border_width = 1

        collectgarbage("collect")
        return false
    end)

end)

client.connect_signal("unfocus", function(c)
  c.border_color = '#000000'
  c.border_width = 1
end)

-- Prevent windows from moving to the looking glass tag
client.connect_signal("tagged", function(c)
    rc.prevent_clients_on_tag_except("looking-glass-client", "looking-glass-client", c)
end)

require("restore_floating_clients")

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- awful.util.spawn(os.getenv("HOME") .. "/.dotfiles/bin/post-graphical-setup.sh")
awful.util.spawn(os.getenv("DOTFILES") .. "/bin/post-graphical-setup.sh")
