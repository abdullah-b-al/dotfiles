import tmux
import window_manager as wm
import run

window_ids = {
    "shell" : "Alacritty",
    "build" : "Alacritty",
    "editor" : "Alacritty",
    "docs" : ".*firefox.*",
    "browser" : "brave-browser",
}

def focus_editor():
    tmux.focus_editor()
    wm.window_focus_by_app_id(window_ids["editor"])


def focus_build():
    tmux.focus_build()
    wm.window_focus_by_app_id(window_ids["build"])


def focus_shell():
    tmux.focus_shell()
    wm.window_focus_by_app_id(window_ids["shell"])

def focus_browser():
    wm.window_focus_by_app_id(window_ids["browser"])

def focus_docs():
    wm.window_focus_by_app_id(window_ids["docs"])

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
