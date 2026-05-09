import tmux
import window_manager as wm

window_ids = {
    "shell" : "Alacritty",
    "build" : "Alacritty",
    "editor" : "Alacritty",
    "docs" : ".*firefox.*",
    "browser" : "brave-browser",
}

window_commands = {
    "shell" : "alacritty",
    "build" : "alacritty",
    "editor" : "alacritty",
    "docs" : "firefox",
    "browser" : "brave",
}

def focus_editor():
    tmux.focus_editor()
    wm.window_focus_or_open(window_ids["editor"], [window_commands["editor"]])


def focus_build():
    tmux.focus_build()
    wm.window_focus_or_open(window_ids["build"], [window_commands["build"]])


def focus_shell():
    tmux.focus_shell()
    wm.window_focus_or_open(window_ids["shell"], [window_commands["shell"]])

def focus_browser():
    wm.window_focus_or_open(window_ids["browser"], [window_commands["browser"]])

def focus_docs():
    wm.window_focus_or_open(window_ids["docs"], [window_commands["docs"]])

def action_list_strings() -> list[str]:
    result = []
    for action, _ in action_list:
        result.append(action)

    return result

action_list = [
    ("focus_editor", focus_editor),
    ("focus_build", focus_build),
    ("focus_shell", focus_shell),
    ("focus_browser", focus_browser),
    ("focus_docs", focus_docs),
]
