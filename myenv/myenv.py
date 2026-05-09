import logging
import run
import argparse
import tools
import actions

parser = argparse.ArgumentParser()
parser.add_argument(
    'command',
    choices=tools.tools_list_strings() + actions.action_list_strings() + ["tools_pick"]
)
parser.add_argument("--debug", action="store_true")
args = parser.parse_args()

logging.basicConfig(
    level=logging.DEBUG if args.debug else logging.INFO,
    format="%(levelname)s(%(name)s): %(message)s"
)
log = logging.getLogger("myenv") 

command = args.command.lower()

if command == "tools_pick":
    command = tools.tools_pick()


### Check tools
for tool, func in tools.tools_list:
    if tools.tooll_from_cli(command) == tool or command == tool:
        log.debug("== Tool({}) ==".format(command))
        func()


### Check actions
for action, func in actions.action_list:
    if command == action:
        log.debug("== Action({}) ==".format(command))
        func()
