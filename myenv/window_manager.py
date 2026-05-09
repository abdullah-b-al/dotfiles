import run
import re
import time

def terminal_scratch(name: str, args: list[str]):
    result = run.run(
        [ "alacritty", "msg", "create-window", "--class", name, "-e" ] + args,
    )

    if result.returncode != 0:
        run.run(
            [ "alacritty", "--class", name, "-e" ] + args,
        )
    

def window_exists_by_app_id(regex: str):
    result = run.run(
        ["sh", "-c", "swaymsg --raw -t get_tree | jq -r '.. | .app_id? // empty'"],
    )

    return (re.search(regex, result.stdout))
    

def window_focus_by_app_id(app_id: str):
    run.run(
        ["swaymsg", "[app_id={}] focus".format(app_id)],
    )


def window_focus_or_open(regex: str, command: list[str]):
    if window_exists_by_app_id(regex):
        window_focus_by_app_id(regex)
    else:
        run.run(command)
        while not window_exists_by_app_id(regex):
            time.sleep(0.25)

        window_focus_by_app_id(regex)
