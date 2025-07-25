local M = {}

local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")

-- local terminal = "konsole"
-- local terminal_class = "konsole"
local terminal = "alacritty"
local terminal_class = "Alacritty"

local secondary_fg = "#61AFEF"
local border_color = "#FFFFFF"

local battery_file_path = "/sys/class/power_supply/BAT0/capacity"

local file_exists = function (name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end


local network_data = {
    prev_rx = 0,
    prev_tx = 0,
    timeout = 1,

    convert_to_mega_bits   = function (bytes)
        local speed = (bytes * 8)/1000000
        return string.format("%.2f", speed)
    end,
}

local cpu_usage_data = {
    prev_total = 0,
    prev_idle = 0,
}

M.get_font = function (size)
    size = tostring(size or 9)
    return "JetBrains Mono " .. size
end

M.notify_all_monitors = function (message)
    awful.screen.connect_for_each_screen(function(s)
        message.screen = s
        naughty.notify(message)
    end)
end

M.prevent_clients_on_tag_except = function(client_class, tag_name, c)
    c._previous_tag = c._current_tag
    c._current_tag = c.first_tag
    if c.first_tag.name == tag_name and c.class ~= client_class then
        local tag = c._previous_tag or awful.tag.find_by_name(awful.screen.focused(), "1")
        c:move_to_tag(tag)
    end
end

M.goto_window = function(win_name_pattren, match)
    match = match or "class_and_name"

    local focused_client = client.focus
    -- local clients =  awful.screen.focused().all_clients

    -- reorder the the screens to prioritize the focused one
    local screens = {}
    for s in screen do
        if s ~= awful.screen.focused() then
            screens[#screens] = s
        end
    end
    table.insert(screens, 1, awful.screen.focused())

    for _, current_screen in pairs(screens) do
        local clients =  current_screen.all_clients
        for _, c in ipairs(clients) do
            local is_window = false
            if match == "name" or match == "class_and_name" then
                is_window = is_window or string.match(tostring(c.name), win_name_pattren)
            end
            if match == "class" or match == "class_and_name" then
                is_window = is_window or string.match(tostring(c.class), win_name_pattren)
            end

            if is_window then
                if c ~= focused_client then
                    c.first_tag:view_only()
                    client.focus = c
                    c:raise()
                    awful.screen.focus(current_screen)
                end

                return true
            end
        end
    end

    return false
end

M.spawn_or_goto = function(win_name_pattren, program, match)
    if not M.goto_window(win_name_pattren, match) then
        awful.spawn(program)
    end
end

M.spawn_or_goto_terminal = function () M.spawn_or_goto('^'..terminal_class..'$', terminal, "class") end

M.screen_settings_set = function()
    -- Put it in a delay so that spamming doesn't cause problems
    gears.timer.start_new(1, function()
        local s = awful.screen.focused()
        local c = client.focus

        if c.screen.index == 1 and s.index == 1 then
            local bin = os.getenv("DOTFILES") .. "/bin/screen-settings-set.sh"
            if c.class == "gamescope" or string.match(c.class, "steam_app_.*") then
                awful.util.spawn(bin .. ' gaming')
            else
                awful.util.spawn(bin)
            end
        end

        return false
    end)
end

local combine = function (widget, shape, margin)
    if widget == nil then return end

    local t = gears.table.join(margin, {widget})
    return gears.table.join(shape, {t})
end

local get_memory = function (stdout)
    local total = tonumber(string.gmatch(stdout, "MemTotal:%s*(%d+)")())
    local available = tonumber(string.gmatch(stdout, "MemAvailable:%s*(%d+)")())
    return {
        used = (total - available) / (1024 * 1024),
        available = available / (1024 * 1024) ,
    }
end

local widgets = {

    used_memory = awful.widget.watch("cat /proc/meminfo", 10, function(widget, stdout)
        widget:set_text(string.format("%.1f", get_memory(stdout).used))
    end),

    free_memory = awful.widget.watch("cat /proc/meminfo", 10, function(widget, stdout)
        widget:set_text(string.format("%.1f", get_memory(stdout).available))
    end),

    battery = (function ()
        if not file_exists(battery_file_path) then return nil end

        return awful.widget.watch('cat ' .. battery_file_path, 60, function(widget, stdout)

            local value = ''
            if tonumber(stdout) ~= nil then
                value = stdout
            end

            widget:set_text(value)

        end)
    end)(), -- don't forget to call

    cpu_temp = awful.widget.watch('cat /sys/devices/virtual/thermal/thermal_zone0/hwmon4/temp1_input', 10,
        function(widget, stdout) widget:set_text(tonumber(stdout)/1000) end),

    cpu_usage = awful.widget.watch([[bash -c "cat /proc/stat | head -n 1"]], 10,
        function(widget, stdout)
            local _, user, nice, system, idle, iowait, irq, softirq, steal, _, _ =
            stdout:match('(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)')

            local total = user + nice + system + idle + iowait + irq + softirq + steal

            local diff_idle = idle - tonumber(cpu_usage_data.prev_idle == nil and 0 or cpu_usage_data.prev_idle)
            local diff_total = total - tonumber(cpu_usage_data.prev_total == nil and 0 or cpu_usage_data.prev_total)
            local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

            cpu_usage_data.prev_total = total
            cpu_usage_data.prev_idle = idle

            widget:set_text(string.format("%.0f",tostring(diff_usage)))

        end),

    cpu_nproc = awful.widget.watch('nproc', 10, function (widget, stdout)
        widget:set_text(stdout)
    end),

    gpu_temp = awful.widget.watch('gpu-temp.sh', 60,
        function(widget, stdout)
            local temp = tonumber(stdout)
            if temp >= 100 then
                local preset = naughty.config.presets.critical
                preset.timeout = 10
                M.notify_all_monitors({
                    preset = preset,
                    text = "GPU temperature is too high!"
                })
            end
            widget:set_text(temp)
        end),

    gpu_usage = awful.widget.watch([[bash -c "radeontop -d - -l 1 | grep -Po 'gpu \d+'"]], 60,
        function(widget, stdout)
            local str = gears.string.split(stdout, ' ')[2]
            widget:set_text(str)
        end),

    network_rx = awful.widget.watch("cat /sys/class/net/wlp8s0/statistics/rx_bytes", network_data.timeout, function (widget, stdout)
        local cur_rx = tonumber(stdout)
        local speed_rx = (cur_rx - network_data.prev_rx) / network_data.timeout
        widget:set_text(network_data.convert_to_mega_bits(speed_rx))
        network_data.prev_rx = cur_rx
    end),

    network_tx = awful.widget.watch("cat /sys/class/net/wlp8s0/statistics/tx_bytes", network_data.timeout, function (widget, stdout)
        local cur_tx = tonumber(stdout)
        local speed_tx = (cur_tx - network_data.prev_tx) / network_data.timeout
        widget:set_text(network_data.convert_to_mega_bits(speed_tx))
        network_data.prev_tx = cur_tx
    end),

    updates = awful.widget.watch("bash -c 'dnf check-upgrade | wc -l'", 60 * 60, function(widget, stdout)
        widget:set_text(stdout)
    end),


    auto_cpufreq = (function ()
        if not file_exists(battery_file_path) then return nil end

        return awful.widget.watch([[bash -c "systemctl status auto-cpufreq | grep 'Active:'"]], 60 * 30,
            function (widget, stdout)
                if not string.match(stdout, "active") then
                    widget:set_text("auto-cpufreq is inactive!")
                end
            end)
    end)(), -- don't forget to call
}

local textbox_color = function (text, color)
    return {
        wibox.widget.textbox(text),
        fg = color,
        widget = wibox.container.background,
    }
end

local margin = {
    left   = 5,
    right  = 5,
    top    = 1,
    bottom = 1,
    widget = wibox.container.margin,
}


local shape = {
    shape = gears.shape.rounded_rect,
    shape_border_color = border_color,
    shape_border_width = 0.3,
    widget             = wibox.container.background,
}

local ram = {
    layout = wibox.layout.fixed.horizontal,
    textbox_color("RAM ", secondary_fg),

    textbox_color("-", "#FF0000"),
    widgets.used_memory,
    textbox_color("GiB", secondary_fg),

    wibox.widget.textbox(" "),

    textbox_color("+", "#00AA00"),
    widgets.free_memory,
    textbox_color("GiB", secondary_fg),
}

local gpu = {
    layout = wibox.layout.fixed.horizontal,
    textbox_color("GPU ", secondary_fg),
    widgets.gpu_usage,
    textbox_color("% ", "#00AA00"),
    widgets.gpu_temp,
    textbox_color("°", "#FF0000"),
}

local cpu = {
    layout = wibox.layout.fixed.horizontal,
    textbox_color("CPU ", secondary_fg),
    widgets.cpu_nproc,
    textbox_color("⣿ ", "#00AA00"),
    widgets.cpu_usage,
    textbox_color("% ", "#00AA00"),
    widgets.cpu_temp,
    textbox_color("°", "#FF0000"),
}

local date_and_time = {
    layout = wibox.layout.fixed.horizontal,
    {
        fg = secondary_fg,
        awful.widget.textclock("%-d "),
        widget = wibox.container.background,
    },
    awful.widget.textclock("%b "),

    {
        fg = secondary_fg,
        awful.widget.textclock("%A"),
        widget = wibox.container.background,
    },
    awful.widget.textclock(" %H:%M"),
}

local network = {
    layout = wibox.layout.fixed.horizontal,
    textbox_color("↓", secondary_fg),
    widgets.network_rx,
    textbox_color("Mb/s ", secondary_fg),

    textbox_color("↑", secondary_fg),
    widgets.network_tx,
    textbox_color("Mb/s", secondary_fg),
}

local updates = {
    layout = wibox.layout.fixed.horizontal,
    textbox_color(" ", secondary_fg),
    widgets.updates
}

function M.multi_key_map  (keys)

    for _, v in ipairs(keys) do
        local mods = v[1]
        local key = v[2]
        local callback = v[3]
        if type(mods) ~= "table" then
            naughty.notify({ preset = naughty.config.presets.critical,
                title = "Wrong type passed to multi_key_map",
                text = "Expected mods as table got " .. type(key) })
            return
        end
        if type(key) ~= "string" then
            naughty.notify({ preset = naughty.config.presets.critical,
                title = "Wrong type passed to multi_key_map",
                text = "Expected key as string got " .. type(key) })
            return
        end
        if type(callback) ~= "function" then
            naughty.notify({ preset = naughty.config.presets.critical,
                title = "Wrong type passed to multi_key_map",
                text = "Expected callback as function got " .. type(callback) })
            return
        end
    end


    local grabber
    grabber = awful.keygrabber.run(function (received_mods, received_key, received_event)
        if received_event == "release" then return end

        received_key = string.lower(received_key)

        local mods_set = {
            super_l   = true, super_r   = true,
            shift_l   = true, shift_r   = true,
            control_l = true, control_r = true,
            alt_l     = true, alt_r     = true,
        }
        local key_is_mod = mods_set[received_key] ~= nil

        for _, v in ipairs(keys) do
            local mods = v[1]
            local key = v[2]
            local callback = v[3]

            local mods_are_eql = #mods == #received_mods
            for i, _ in ipairs(mods) do
                if not mods_are_eql then break end
                if mods[i] ~= received_mods[i] then
                    mods_are_eql = false
                end
            end

            if key == received_key and mods_are_eql then
                callback()
                awful.keygrabber.stop(grabber)
            elseif key_is_mod then
                goto continue
            else
                awful.keygrabber.stop(grabber)
            end

            ::continue::
        end
    end)

end

local battery = nil
if widgets.battery then
    battery = {
        layout = wibox.layout.fixed.horizontal,
        textbox_color("%", secondary_fg),
        widgets.battery,
    }
end


M.widgets = {
    battery = combine(battery, shape, margin),
    ram = combine(ram, shape, margin),
    date_and_time = combine(date_and_time, shape, margin),
    cpu = combine(cpu, shape, margin),
    gpu = combine(gpu, shape, margin),
    network = combine(network, shape, margin),
    updates = combine(updates, shape, margin),
    auto_cpufreq = widgets.auto_cpufreq,
    terminal = terminal,
}

return M
