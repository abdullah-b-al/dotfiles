import tmux
import run
import window_manager as wm

def run_in_window(window: str, bin: list[str]):
    tmux.window_run(tools_session_name, window, bin)

    if wm.window_exists_by_app_id("scratch_terminal"):
        wm.window_focus_by_app_id("scratch_terminal")
    else:
        wm.terminal_scratch(
            "scratch_terminal",
            [ "tmux", "attach", "-t", "{}:{}".format(tools_session_name, window)]
        )

def menu():
    run_in_window("menu", ["myenv.sh", "tools_pick"])


def calculator():
    run_in_window("calculator", ["qalc"])


def bluetooth():
    run_in_window("bluetui", ["bluetui"])


def network():
    run_in_window("nmtui", ["nmtui", "connect"])


def audio_mixer():
    run_in_window("plusemixer", ["plusemixer"])


def system_monitor():
    run_in_window("btop", ["btop"])


def tools_pick():
    result = run.pipe(
        ["fzf", "--style=minimal"],
        "\n".join(tools_list_readable_strings()),
    )
    if result.returncode == 0:
        return result.stdout.lower().strip()

    return ""


def tools_list_readable_strings() -> list[str]:
    """Human readable string for the tools list"""
    result = []
    for tool, _ in tools_list:
        result.append(tool.replace("tools", " ").replace("_", " ").strip().title())

    return result

def tools_list_strings() -> list[str]:
    result = []
    for tool, _ in tools_list:
        result.append(tool)

    return result
    
def tooll_from_cli(name: str) -> str:
    """Turn the action into the tools name format"""
    return "tools_{}".format(name).replace(" ", "_")
    

tools_list = [
    ("tools_calculator", calculator),
    ("tools_system_monitor", system_monitor),
    ("tools_bluetooth", bluetooth),
    ("tools_network", network),
    ("tools_audio_mixer", audio_mixer),
    ("tools_menu", menu),
]
tools_session_name = "tools"

