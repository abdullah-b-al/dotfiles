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
-- Notification library
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local focused = awful.screen.focused
local focused_screen = awful.screen.focused
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

naughty.config.defaults['font'] = "Ubuntu Condensed 24"

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

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
gears.wallpaper.set("#000000")
-- beautiful.border_width = 2
-- beautiful.border_focus = "#FFFFFF"

beautiful.fg_normal  = "#FFFFFF"
beautiful.bg_normal  = "#1c1c1c"
beautiful.tasklist_bg_focus = "#555555"
beautiful.tasklist_fg_focus  = "#CCCCCC"
beautiful.tasklist_fg_normal = "#CCCCCC"

terminal = "alacritty"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

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


        -- buttons = tasklist_buttons,
        -- makes the tasklist a spacing widget only
        -- layout = {}
    }

  -- Create the wibox
    s.topwibox = awful.wibar({ position = "top", screen = s, height = 13 })
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
            spacing = 6,
            layout = wibox.layout.fixed.horizontal,

            rc.widgets.auto_cpufreq,
            rc.widgets.battery,
            rc.widgets.network,
            rc.widgets.ram,
            rc.widgets.cpu,
            rc.widgets.gpu,

            -- rc.widgets.date_and_time,

            awful.widget.keyboardlayout(),
            wibox.widget.systray(),
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
  awful.key({ modkey,           }, "F1",      hotkeys_popup.show_help,
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
      -- Skip master if on half layout
      if awful.layout.get(focused()).name == 'half' and
        awful.client.next(1) == awful.client.getmaster() and
        #focused().selected_tag:clients() > 2
      then
        awful.client.focus.byidx(2)
      else
        awful.client.focus.byidx(1)
      end
    end,
    {description = "focus next by index", group = "client"}
  ),

  awful.key(
    {modkey}, "h",
    function ()
      -- Skip master if on half layout
      if awful.layout.get(focused()).name == 'half' and
        awful.client.next(-1) == awful.client.getmaster() and
        #focused().selected_tag:clients() > 2
      then
        awful.client.focus.byidx(-2)
      else
        awful.client.focus.byidx(-1)
      end
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

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "l", function () awful.client.swap.byidx(  1)    end,
    {description = "swap with next client by index", group = "client"}),

  awful.key({ modkey,           }, "Return", function () awful.screen.focus_relative(-1) end,
    {description = "focus the previous screen", group = "screen"}),

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

  awful.key( { modkey, }, "t", function()
        rc.spawn_or_goto_terminal()
        awful.spawn("tmux-switch-to.sh shell")
    end,
    {description = "Open a terminal if it's not already open on the focused screen", group = "launcher"}
  ),

  awful.key( { modkey, }, "e", function()
        awful.spawn("tmux-switch-to.sh editor")
        rc.spawn_or_goto_terminal()
    end,
    {description = "Open a terminal if it's not already open on the focused screen", group = "launcher"}
  ),

    awful.key( { modkey, }, "b", function() rc.spawn_or_goto('^Brave', 'brave-browser') end,
        {description = "Open a terminal if it's not already open on the focused screen", group = "launcher"}
    ),
    awful.key( { modkey, "Control" }, "b", function() awful.spawn('brave-browser') end,
        {description = "Open a terminal if it's not already open on the focused screen", group = "launcher"}
    ),

  awful.key(
    { modkey, "Shift"}, "t", function ()
      awful.spawn(terminal)
    end,
    {description = "Force open a terminal", group = "launcher"}
  ),

  awful.key({ modkey, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit,
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
    {description = "select previous", group = "layout"})


  --]]
)

clientkeys = gears.table.join(
  awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
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
for i = 1, 5 do
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
    }, properties = { floating = true, screen = 1, tag = "5", fullscreen = true}
  },

    {
        rule_any = {
            class = { "zenity", "Zenity" }
        },
        properties = {
            floating = true,
            placement = awful.placement.centered,
        }
    },


  {
    rule_any = {
      class = {
        "scratch-terminal",
        "TestWindow",
      },
    }, properties = {
      floating = true,
      center = true,
      x = 0,
      y = awful.screen.focused().geometry.height / 8,
      height = awful.screen.focused().geometry.height * 0.75,
      width = awful.screen.focused().geometry.width - 6
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
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) 
  
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

awful.util.spawn(os.getenv("HOME") .. "/.dotfiles/bin/post-graphical-setup.sh")
