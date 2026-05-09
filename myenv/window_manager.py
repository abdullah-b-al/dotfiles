import run

def terminal_scratch(name: str, args: list[str]):
    result = run.run(
        [ "alacritty", "msg", "create-window", "--class", name, "-e" ] + args,
    )

    if result.returncode != 0:
        run.run(
            [ "alacritty", "--class", name, "-e" ] + args,
        )
    

def window_exists_by_app_id(app_id: str):
    result = run.run(
        ["sh", "-c", "swaymsg --raw -t get_tree | jq -r '.. | .app_id? // empty'"],
    )

    return app_id in result.stdout
    

def window_focus_by_app_id(app_id: str):
    run.run(
        ["swaymsg", "[app_id={}] focus".format(app_id)],
    )
