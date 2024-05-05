local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")

local yellowish = "#FFC674"
local border_color = "#AAAAAA"

local widgets = {

    mykeyboardlayout = awful.widget.keyboardlayout(),
    -- date = awful.widget.textclock( "%b %m/%d %A"),
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

full_ram_widget = {
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

gears.table.join(full_ram_widget, margin)
