import run
from enum import Enum
from pathlib import Path

def session_exists(session):
    result = run.run(
        ["tmux", "has-session", "-t", session],
    )
    return result.returncode == 0


def session_new_with_window(session, window, bin: list[str]):
    run.run(
        [ "tmux", "new-session", "-d", "-s", session, "-n", window  ] + bin,
    )
    

def window_exists(session, window):
    result = run.run(
        [ "tmux", "has-session", "-t", session + ":" + window ],
    )
    return result.returncode == 0


def window_new(session, window, bin: list[str]):
    run.run(
        [ "tmux", "new-window", "-t", session, "-n", window  ] + bin,
    )


def window_focus(session, window):
    run.run(
        [ "tmux", "select-window", "-t", session + ":" + window ],
    )


def window_run(session, window, bin: list[str]):
    if not session_exists(session):
        session_new_with_window(session, window, bin)
    elif not window_exists(session, window):
        window_new(session, window, bin)
    else:
        window_focus(session, window)


def active_session():
    tmux = "tmux list-sessions -F '#{session_name},#{session_activity}'"
    sort = "sort -r -k2 --field-separator=','"
    head = "head --lines 1"
    cut = "cut -d ',' -f 1"
    command = "{} | {} | {} | {}".format(tmux, sort, head, cut)
    result = run.shell([command])
    return result.stdout.strip()


def active_window():
    return run.run([
        "tmux",
        "list-windows",
        "-t",
        active_session(),
        "-F",
        "#{?window_active,#{window_name},}"
    ]).stdout.strip()


def active_session_pane_cwd():
    return run.run([
        "tmux",
        "display",
        "-t",
        active_session(),
        "-p",
        "#{pane_current_path}",
    ]).stdout.strip()


def active_session_cwd():
    return run.run([
        "tmux",
        "display",
        "-t",
        active_session(),
        "-p",
        "#{session_path}",
    ]).stdout.strip()

def non_special_window_index():
    # the window index is always the last used non-special window
    tmux = run.run([
        "tmux",
        "list-windows",
        "-t",
        active_session(),
        "-F",
        "#{window_index},#{window_name},#{window_activity}",
    ]).stdout
    
    rg = run.pipe(["rg", "-v","editor,|build,|debug,"], tmux).stdout
    sort = run.pipe([ "sort", "-r", "-k3", "--field-separator=," ], rg).stdout
    head = run.pipe(["head", "--lines", "1"], sort).stdout
    cut = run.pipe([ "cut", "-d", ',', "-f", "1" ], head).stdout

    return cut.strip()
    


class SpecialWindow(Enum):
    editor = 10
    build = 11
    debug = 12
    
def focus_and_create_special_window(window: SpecialWindow):
    session = active_session()
    cwd = active_session_pane_cwd()
    flake_exists = Path(cwd + "/" + "flake.nix").exists()
    flake_args = [ "nix", "develop", "--command", "fish", ] if flake_exists else []

    run.run([
        "tmux",
        "new-window",
        "-d",
        "-c",
        cwd,
        "-t",
        "{}:{}".format(session, window.value),
        "-n",
        window.name,
        "-d",
    ] + flake_args)

    run.run([
        "tmux",
        "switch-client",
        "-Z",
        "-t",
        "{}:{}".format(session, window.name),
    ])



def focus_editor():
    focus_and_create_special_window(SpecialWindow.editor)

def focus_build():
    focus_and_create_special_window(SpecialWindow.build)

def focus_debug():
    focus_and_create_special_window(SpecialWindow.debug)

def focus_shell():
    session = active_session()
    index = non_special_window_index()
    run.run([ "tmux", "select-window", "-t", "{}:{}".format(session, index)])

    
