from typing import List
from kittens.tui.loop import debug
from kitty.boss import Boss

from os import getcwd
from subprocess import check_output
from glob import glob


def run(string: str, txt_input=""):
    try:
        return check_output(string, input=txt_input, shell=True).decode("utf-8")
    except Exception:
        exit(1)


def main(args: List[str]) -> str:
    paths_list = glob("/*", recursive=False)
    paths_list.insert(0, "cwd")

    paths = ""
    for p in paths_list:
        paths += p + "\n"

    path = run("fzf", txt_input=bytearray(paths, "utf-8")).strip('\n')
    if path == "cwd":
        path = getcwd()

    return run("find {0} | fzf".format(path)).strip('\n')


def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    # get the kitty window into which to paste answer
    w = boss.window_id_map.get(target_window_id)
    if w is not None:
        w.paste_text(answer)
