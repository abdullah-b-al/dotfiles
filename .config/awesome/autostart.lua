local awful = require("awful")


awful.spawn.with_shell("picom")
awful.spawn.with_shell("redshift -O 3750")
awful.spawn.with_shell("setxkbmap -layout 'us(colemak),ar,us,' -option 'grp:alt_shift_toggle' -option caps:swapescape");
awful.spawn.with_shell("feh --bg-fill --randomize ~/Pictures/Wallpapers/*")

awful.spawn.with_shell("xinput -set-prop 'Cooler Master Technology Inc. MM710 Gaming Mouse' 'Coordinate Transformation Matrix' 0.4 0 0 0 0.4 0 0 0 0.9")
-- awful.spawn.with_shell("xset s off && xset s noblank && xset -dpms")
