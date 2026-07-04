import run

def sessions() -> list[str]:
    result = run.shell(["zellij list-sessions -n | grep -vi exited | cut -f 1 -d ' '"])
    return result.stdout.splitlines()
    

def focus_editor():
    for session in sessions():
        run.run(["zellij", "--session", session, "action", "go-to-tab-name", "editor"])

def focus_build():
    for session in sessions():
        run.run(["zellij", "--session", session, "action", "go-to-tab-name", "build"])

def focus_debugger():
    for session in sessions():
        run.run(["zellij", "--session", session, "action", "go-to-tab-name", "debugger"])

def focus_shell():
    for session in sessions():
        run.run(["zellij", "--session", session, "action", "go-to-tab-name", "shell"])
