#!/bin/python3

from subprocess import check_output

command = 'tmux display-message -p "#{cursor_x} #{cursor_y} #{pane_top} #{pane_left} #{pane_height} #{pane_width} #{window_height} #{window_width}"'
out = check_output(command, shell=True).decode("utf-8").split(" ")

out_x = int(out[0])
out_y = int(out[1])
out_top = int(out[2])
out_left = int(out[3])
out_pane_h = int(out[4])
out_pane_w = int(out[5])
out_win_h = int(out[6])
out_win_w = int(out[7])

w = out_pane_w
h = 25
x = abs(out_x + out_left - 3)
y = out_y + out_top + h + 1

layout = "reverse"
if y > out_win_h:
    y -= h + 1
    layout = "default"

if w == out_win_w or x + w >= out_win_w:
    w = abs(x - out_pane_w)


print("-x {} -y {} -w {} -h {},{}".format(x, y, w, h, layout))
