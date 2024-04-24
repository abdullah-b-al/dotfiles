from typing import List
from kitty.boss import Boss

from subprocess import check_output


def main(args: List[str]) -> str:
    out = check_output("find /home/ab55al/test | fzf", shell=True)
    if len(out) > 0:
        out = out[0:len(out) - 1: 1]

    return out.decode('ascii')


def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    # get the kitty window into which to paste answer
    w = boss.window_id_map.get(target_window_id)
    if w is not None:
        w.paste_text(answer)
