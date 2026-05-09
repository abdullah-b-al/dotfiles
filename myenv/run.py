import subprocess
import logging

def run(args: list[str]):
    log = logging.getLogger("Running") 
    log.debug(args)

    result = subprocess.run(
        args,
        text=True,
        capture_output=True,
    )

    if len(result.stdout) > 0:
        log.debug("== stdout ==\n{}".format(result.stdout))
        log.debug("== stderr ==\n{}".format(result.stderr))

    return result


def shell(args: list[str]):
    log = logging.getLogger("Shell") 
    log.debug(args)

    result = subprocess.run(
        args,
        text=True,
        shell=True,
        capture_output=True,
    )

    if len(result.stdout) > 0:
        log.debug(result.stdout)

    return result


def pipe(args: list[str], input: str):
    # logging.getLogger("Piping").debug("Input: " + input)
    # logging.getLogger("Piping").debug(args)
    logging.getLogger("Piping").debug("{} <=\n{}".format(args, input))

    return subprocess.run(
        args,
        input=input,
        text=True,
        capture_output=True,
    )
