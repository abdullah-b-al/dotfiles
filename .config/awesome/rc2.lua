local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")

local yellowish = "#FFC674"
local border_color = "#FFFFFF"

local network_data = {
    prev_rx = 0,
    prev_tx = 0,
    timeout = 1,

    convert_to_mega_bits   = function (bytes)
        local speed = (bytes * 8)/1000000
        return string.format("%.2f", speed)
    end,
}

local spawn_or_goto = function(win_name_pattren, program)

    local focused_client = client.focus
    local clients =  awful.screen.focused().all_clients

    for _, c in ipairs(clients) do
        local is_window =
        string.match(tostring(c.name), win_name_pattren) or
        string.match(tostring(c.class), win_name_pattren)

        local is_focused = c == focused_client

        if is_window then
            if not is_focused then
                c.first_tag:view_only()
                client.focus = c
                c:raise()
            end

            return
        end

    end

    awful.spawn(program)
end

local spawn_or_goto_terminal = function () spawn_or_goto('^kitty$', 'kitty') end

local combine = function (widget, shape, margin)
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

    date = awful.widget.textclock("%b %m/%d %A"),
    time = awful.widget.textclock("%H:%M"),

    used_memory = awful.widget.watch([[bash -c "cat /proc/meminfo | head -n 3"]], 30, function(widget, stdout)
        widget:set_text(string.format("%.1f", get_memory(stdout).used))
    end),

    free_memory = awful.widget.watch([[bash -c "cat /proc/meminfo | head -n 3"]], 30, function(widget, stdout)
        widget:set_text(string.format("%.1f", get_memory(stdout).available))
    end),

    battery = awful.widget.watch('cat /sys/class/power_supply/BAT0/capacity', 60, function(widget, stdout)

        local value = ''
        if tonumber(stdout) ~= nil then
            value = '%' .. stdout
        end

        widget:set_text(value)

    end),

    cpu_temp = awful.widget.watch('cat /sys/devices/virtual/thermal/thermal_zone0/hwmon3/temp1_input', 10,
        function(widget, stdout) widget:set_text(tonumber(stdout)/1000) end),

    gpu_temp = awful.widget.watch('cat /sys/devices/pci0000:00/0000:00:03.1/0000:0e:00.0/hwmon/hwmon0/temp1_input', 10,
        function(widget, stdout)
            local temp = tonumber(stdout)/1000
            if temp >= 95 then
                local preset = naughty.config.presets.critical
                preset.timeout = 10
                awful.screen.connect_for_each_screen(function(s)
                    naughty.notify({
                        screen = s,
                        preset = preset,
                        text = "GPU temperature is too high!"
                    })
                end)
            end
            widget:set_text(temp)
        end),

    network_rx = awful.widget.watch([[bash -c "cat /sys/class/net/wlp8s0/statistics/rx_bytes"]], network_data.timeout, function (widget, stdout)
        local cur_rx = tonumber(stdout)
        local speed_rx = (cur_rx - network_data.prev_rx) / network_data.timeout
        widget:set_text(network_data.convert_to_mega_bits(speed_rx))
        network_data.prev_rx = cur_rx
    end),

    network_tx = awful.widget.watch([[bash -c "cat /sys/class/net/wlp8s0/statistics/tx_bytes"]], network_data.timeout, function (widget, stdout)
        local cur_tx = tonumber(stdout)
        local speed_tx = (cur_tx - network_data.prev_tx) / network_data.timeout
        widget:set_text(network_data.convert_to_mega_bits(speed_tx))
        network_data.prev_tx = cur_tx
    end),

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
    widget = wibox.container.margin
}


local shape = {
    shape = gears.shape.rounded_rect,
    shape_border_color = border_color,
    shape_border_width = 0.3,
    widget             = wibox.container.background
}

local ram = {
    layout = wibox.layout.fixed.horizontal,
    textbox_color("RAM ", yellowish),

    wibox.widget.textbox("-"),
    widgets.used_memory,
    textbox_color("GiB", yellowish),

    wibox.widget.textbox(" "),

    wibox.widget.textbox("+"),
    widgets.free_memory,
    textbox_color("GiB", yellowish),
}

local gpu = {
    layout = wibox.layout.fixed.horizontal,
    textbox_color("GPU ", yellowish),
    widgets.gpu_temp,
    textbox_color("°", "#FF0000"),
}

local cpu = {
    layout = wibox.layout.fixed.horizontal,
    textbox_color("CPU ", yellowish),
    widgets.cpu_temp,
    textbox_color("°", "#FF0000"),
}

local date_and_time = {
    layout = wibox.layout.fixed.horizontal,
    {
        fg = yellowish,
        widgets.date,
        widget = wibox.container.background,
    },
    wibox.widget.textbox(" "),
    widgets.time,
}

local network = {
    layout = wibox.layout.fixed.horizontal,
    textbox_color("↓", yellowish),
    widgets.network_rx,
    textbox_color("Mb/s ", yellowish),

    textbox_color("↑", yellowish),
    widgets.network_tx,
    textbox_color("Mb/s", yellowish),
}

return {
    widgets = {
        battery = widgets.battery,
        ram = combine(ram, shape, margin),
        date_and_time = combine(date_and_time, shape, margin),
        cpu = combine(cpu, shape, margin),
        gpu = combine(gpu, shape, margin),
        network = combine(network, shape, margin),
    },


    spawn_or_goto = spawn_or_goto,
    spawn_or_goto_terminal = spawn_or_goto_terminal,
}
